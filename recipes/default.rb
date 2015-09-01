#
# Cookbook Name:: sensors
# Recipe:: default
#
# Copyright 2013-2014, Limelight Networks, Inc.
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

# method to sanitize the possible names for the mainboard
def sanitize_name(name)
  name = name.downcase # data bags are lowercase
  name = name.delete('+') # + symbols aren't valid for mainboards
  name = name.split('/')[0] # some mainboards report multiple models sep by /
  name
end

# Don't run on EC2 or virtualized systems
unless node['ec2'] || node['virtualization']['role'] == 'guest'

  mainboard = sanitize_name(node['dmi']['base_board']['product_name'])
  # try to load the sensor config data bag for this node.  If it doesn't exist we'll do nothing
  begin
    sensor_config = data_bag_item('sensors', mainboard)
  rescue
    Chef::Log.info("Mainboard #{mainboard} does not have a data bag.  Not setting up sensor data gathering")
    return
  end

  # Setup lm-sensors or ipmi depending on which is defined in the mainboard databag
  case sensor_config['type']
  when 'lmsensors'

    include_recipe 'sensors::_install_lmsensors'

    template "/etc/sensors.d/#{node['dmi']['base_board']['product_name'].downcase}" do
      source 'lmsensors_config.erb'
      mode '0644'
      notifies :restart, 'service[lm-sensors]'
      notifies :restart, 'service[collectd]' if node['recipes'].include?('collectd::default') || node['recipes'].include?('collectd')
      variables(
        sensor_config: sensor_config
      )
    end

    if node['recipes'].include?('collectd::default') || node['recipes'].include?('collectd')
      collectd_plugin 'sensors'
    end

  when 'ipmi'

    include_recipe 'sensors::_install_ipmi'

    # if using collectd template out the ipmi plugin config.  The LWRP isn't advanced enough to do this at the moment.
    if node['recipes'].include?('collectd::default') || node['recipes'].include?('collectd')
      directory '/etc/collectd/plugins/' do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template '/etc/collectd/plugins/ipmi.conf' do
        source 'ipmi_config.erb'
        mode '0644'
        notifies :restart, 'service[collectd]'
        variables(
          sensor_config: sensor_config
        )
      end
    end

  else # if type isn't lmsensors or ipmi it's an invalid type and we should log an error
    Chef::Log.error("The databag for mainboard #{mainboard} lists the invalid type #{sensor_config['type']}")
  end

end
