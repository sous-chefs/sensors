#
# Cookbook Name:: sensors
# Recipe:: default
#
# Copyright 2013, Limelight Networks, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Don't run on EC2, virtualized systems, or systems with the X8DTL mobo as it crashes when data is polled
if !node['ec2'] && !node['virtualization']['role'] && !node['sensors']['ignored_mainboards'].include?(node['dmi']['base_board']['product_name'])

  # install the lm-sensors package
  package node['sensors']['service_name'] do
    action :install
  end

  # make sure lm-sensors is started and enabled to start at boot
  service node['sensors']['service_name'] do
    supports :status => true, :restart => true
    action [:enable, :start]
  end

  # manage module-init-tools so we can restart it if we add modules to the config
  service 'module-init-tools' do
    action :nothing
  end

  # run the sensor module detection (only once) and then restart module-init-tools
  execute 'load_sensor_modules' do
    command "/usr/bin/yes | /usr/sbin/sensors-detect && touch #{Chef::Config[:file_cache_path]}/sensors_detect_ran"
    creates "#{Chef::Config[:file_cache_path]}/sensors_detect_ran"
    notifies :restart, 'service[module-init-tools]'
    action :run
  end

  # attempt to load a data bag for the node's mainboard. ignore any failure here
  begin
    sensor_config = data_bag_item('sensors', node['dmi']['base_board']['product_name'].downcase)

    template "/etc/sensors.d/#{node['dmi']['base_board']['product_name'].downcase}" do
      source 'sensors.erb'
      mode 00644
      notifies :restart, 'service[lm-sensors]'
      notifies :restart, 'service[collectd]'
      variables(
        :sensor_config => sensor_config
      )
    end
  rescue Exception => e
  end
end
