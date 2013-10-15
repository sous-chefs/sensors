name             'sensors'
maintainer       'Limelight Networks, Inc.'
maintainer_email 'tsmith@limelight.com'
license          'All rights reserved'
description      'Installs/Configures lm-sensors on Linux systems'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

%w{ debian ubuntu centos redhat amazon oracle scientific }.each do |os|
  supports os
end
