#
# Cookbook Name:: sensors
# Recipe:: _install_lmsensors
#
# Copyright 2013-2014, Limelight Networks, Inc.
# Copyright 2015, Cozy Services, Ltd.
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

# install the lm-sensors package
package node['sensors']['service_name'] do
  action :install
end

# make sure lm-sensors is started and enabled to start at boot
service node['sensors']['service_name'] do
  supports status: true, restart: true
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
