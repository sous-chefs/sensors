# frozen_string_literal: true

module SensorsCookbook
  module Helpers
    def default_service_name
      platform_family?('debian') ? 'lm-sensors' : 'lm_sensors'
    end

    def default_lmsensors_package
      default_service_name
    end

    def default_ipmi_package
      platform_family?('debian') ? 'openipmi' : 'OpenIPMI'
    end

    def sanitized_mainboard_name
      raw_name = node['dmi'] && node['dmi']['base_board'] && node['dmi']['base_board']['product_name']
      raw_name ||= new_resource.name
      sanitize_name(raw_name)
    end

    def sanitize_name(name)
      name.downcase.delete('+').split('/').first
    end

    def virtual_guest?
      node['virtualization'] && node['virtualization']['role'] == 'guest'
    end

    def ec2_node?
      node['ec2'] && !node['ec2'].empty?
    end

    def collectd_configured?
      recipes = Array(node['recipes'])
      recipes.include?('collectd') || recipes.include?('collectd::default')
    end
  end
end
