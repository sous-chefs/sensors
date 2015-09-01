name 'sensors'
maintainer 'Tim Smith'
maintainer_email 'tsmith84@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures sensor polling using lm-sensors or openipmi on Linux systems'
version '1.1.0'

%w(debian ubuntu centos redhat fedora oracle scientific).each do |os|
  supports os
end

source_url 'https://github.com/tas50/sensors' if respond_to?(:source_url)
issues_url 'https://github.com/tas50/sensors/issues' if respond_to?(:issues_url)
