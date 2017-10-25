name 'sensors'
maintainer 'Tim Smith'
maintainer_email 'tsmith84@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures sensor polling using lm-sensors or openipmi on Linux systems'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.4'

%w(debian ubuntu centos redhat fedora oracle scientific).each do |os|
  supports os
end

source_url 'https://github.com/tas50/chef-sensors'
issues_url 'https://github.com/tas50/chef-sensors/issues'

chef_version '>= 12.1' if respond_to?(:chef_version)
