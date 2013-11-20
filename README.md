Sensors Cookbook
================
Cookbook to manage hardware sensors via lm-sensors on Linux systems.  Installs only on hardware systems, allows for the blacklisting of mainboards by model, and allows for defining data bags to specify individual ignored sensors values that will not be polled.


Requirements
------------
### Chef
Chef version 0.10.10+ and Ohai 0.6.12+ are required.

### Platform:

* Debian
* Ubuntu
* Centos
* Redhat
* Amazon
* Oracle
* Scientific

### Cookbooks:

*No dependencies defined*

Attributes
----------
`default['sensors']['service_name']` - automatically set based on platform. Debian derivatives: lm-sensors & RHEL derivatives: lm_sensors
`default['sensors']['ignored_mainboards']` - If these mainboards are discovered by Ohai the recipe will be skipped.  This is a workaround "twin" servers manufacturered by Supermicro that have faulty sensor chipsets design, resulting in system hangs when polling sensor data.  Defaults to X8DTL and X8DTT-H

Data Bags
---------

This cookbook uses an optional data bag item per mainboard to configure "ignore" values for sensors. This allows you to ignore fans or temperature sensors present in the chipset, but not actually used by the system manufacturer.  The cookbook will attempt to load a databag item with the ID of the mainboard in the `sensors` data bag.  The ID can be found using Ohai at `node['dmi']['base_board']['product_name']`.  Example data bags are included in the example_databags directory.

### Example data bag
```
{
  "id": "x7dvl",
  "description": "SuperMicro X7DVL",
  "chips": [
    {
      "id": "w83627hf-isa-0290",
      "ignores": [
        "in0",
        "in1",
        "in2",
        "in3",
        "in4",
        "in5",
        "in6",
        "in7",
        "in8",
        "fan1",
        "fan2",
        "fan3",
        "cpu0_vid",
        "beep_enable"
      ]
    },
    {
      "id": "w83792d-i2c-*-2f",
      "ignores": [
        "in0",
        "in1",
        "in2",
        "in3",
        "in4",
        "in5",
        "in6",
        "in7",
        "in8",
        "in9",
        "fan5",
        "fan6",
        "fan7",
        "fan8",
        "fan9",
        "fan10",
        "beep_enable",
        "intrusion0"
      ]
    }
  ]
}
```
License and Author
------------------

Author:: Limelight Networks, Inc. (<tsmith@limelight.com>)

Copyright:: 2013, Limelight Networks, Inc.

License:: All rights reserved

