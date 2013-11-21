name             'sensors'
maintainer       'Limelight Networks, Inc.'
maintainer_email 'tsmith@limelight.com'
license          'All rights reserved'
description      'Installs/Configures sensor polling using lm-sensors or openipmi on Linux systems'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.0'

%w{ debian ubuntu centos redhat oracle scientific }.each do |os|
  supports os
end
