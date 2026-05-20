# frozen_string_literal: true

provides :sensors
unified_mode true

include SensorsCookbook::Helpers

property :mainboard, String, name_property: true
property :sensor_config, [Hash, nil], default: nil
property :data_bag, String, default: 'sensors'
property :load_data_bag, [true, false], default: true
property :skip_virtual_guests, [true, false], default: true
property :configure_collectd, [true, false], default: lazy { collectd_configured? }
property :lmsensors_package, String, default: lazy { default_lmsensors_package }
property :lmsensors_service, String, default: lazy { default_service_name }
property :ipmi_package, String, default: lazy { default_ipmi_package }
property :run_sensors_detect, [true, false], default: true
property :sensors_detect_marker, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], 'sensors_detect_ran') }

default_action :create

action :create do
  if new_resource.skip_virtual_guests && (ec2_node? || virtual_guest?)
    Chef::Log.info('Skipping sensors setup on virtualized hardware')
    return
  end

  config = resolved_sensor_config
  return unless config

  case config['type']
  when 'lmsensors'
    install_lmsensors(config)
  when 'ipmi'
    install_ipmi(config)
  else
    Chef::Log.error("The sensors config for #{new_resource.mainboard} lists the invalid type #{config['type']}")
  end
end

action :delete do
  config = resolved_sensor_config(log_missing: false)

  file lmsensors_config_path do
    action :delete
  end

  file '/etc/collectd/plugins/ipmi.conf' do
    action :delete
  end

  service new_resource.lmsensors_service do
    action [:stop, :disable]
    only_if { config.nil? || config['type'] == 'lmsensors' }
  end

  package new_resource.lmsensors_package do
    action :remove
    only_if { config.nil? || config['type'] == 'lmsensors' }
  end

  package new_resource.ipmi_package do
    action :remove
    only_if { config.nil? || config['type'] == 'ipmi' }
  end
end

action_class do
  include SensorsCookbook::Helpers

  def resolved_sensor_config(log_missing: true)
    return stringify_keys(new_resource.sensor_config) if new_resource.sensor_config
    return unless new_resource.load_data_bag

    stringify_keys(data_bag_item(new_resource.data_bag, new_resource.mainboard))
  rescue StandardError
    Chef::Log.info("Mainboard #{new_resource.mainboard} does not have a data bag. Not setting up sensor data gathering") if log_missing
    nil
  end

  def install_lmsensors(config)
    package new_resource.lmsensors_package

    service 'collectd' do
      action :nothing
      only_if { new_resource.configure_collectd }
    end

    service new_resource.lmsensors_service do
      supports status: true, restart: true
      action [:enable, :start]
    end

    service 'module-init-tools' do
      action :nothing
    end

    execute 'load_sensor_modules' do
      command "/usr/bin/yes | /usr/sbin/sensors-detect && touch #{new_resource.sensors_detect_marker}"
      creates new_resource.sensors_detect_marker
      notifies :restart, 'service[module-init-tools]'
      only_if { new_resource.run_sensors_detect }
    end

    template lmsensors_config_path do
      source 'lmsensors_config.erb'
      cookbook 'sensors'
      mode '0644'
      variables(sensor_config: config)
      notifies :restart, "service[#{new_resource.lmsensors_service}]"
      notifies :restart, 'service[collectd]' if new_resource.configure_collectd
    end

    collectd_plugin 'sensors' if new_resource.configure_collectd
  end

  def install_ipmi(config)
    package new_resource.ipmi_package

    return unless new_resource.configure_collectd

    service 'collectd' do
      action :nothing
    end

    directory '/etc/collectd/plugins/' do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end

    template '/etc/collectd/plugins/ipmi.conf' do
      source 'ipmi_config.erb'
      cookbook 'sensors'
      mode '0644'
      variables(sensor_config: config)
      notifies :restart, 'service[collectd]'
    end
  end

  def lmsensors_config_path
    "/etc/sensors.d/#{sanitize_name(new_resource.mainboard)}"
  end

  def stringify_keys(value)
    return value.map { |item| item.is_a?(Hash) ? stringify_keys(item) : item } if value.is_a?(Array)

    value.each_with_object({}) do |(key, item), hash|
      hash[key.to_s] = item.is_a?(Hash) || item.is_a?(Array) ? stringify_keys(item) : item
    end
  end
end
