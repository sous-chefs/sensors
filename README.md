Sensors Cookbook
================
Cookbook to manage hardware sensors via openipmi or lm-sensors on Linux systems.  Installs only on hardware systems. Defines sensors to poll via data bag items and installs either lm-sensors or openipmi to poll sensors depending on data bag attributes.


Requirements
------------
### Chef
Chef version 0.10.10+ and Ohai 0.6.12+ are required.

### Platform:

* Debian
* Ubuntu
* Centos
* Redhat
* Oracle
* Scientific

### Cookbooks:

*No dependencies defined*

Attributes
----------
`default['sensors']['service_name']` - automatically set based on platform. Debian derivatives: lm-sensors & RHEL derivatives: lm_sensors

Data Bags
---------

This cookbook uses a required data bag item per mainboard to configure which sensors should be ignored. This allows you to ignore fans or temperature sensors present in the chipset, but not actually used by the system manufacturer.  The cookbook will attempt to load a databag item with the ID of the mainboard in the `sensors` data bag.  The ID can be found using Ohai at `node['dmi']['base_board']['product_name']`.  Example data bags are included in the example_databags directory.

#### Example data bag for a non-IPMI systems, which will use lm-sensors
```
{
  "id": "x7dvl",
  "description": "SuperMicro X7DVL",
  "type": "lmsensors"
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

#### Example data bag for an IPMI systems, which will use OpenIPMI
```
{
  "id": "x8dtt-h",
  "description": "SuperMicro X8DTT-H",
  "type": "ipmi",
  "sensors": [
        "fan3",
        "fan4"]
}
```

License and Author
------------------

Author:: Limelight Networks, Inc. (<tsmith@limelight.com>)

Copyright:: 2013-2014, Limelight Networks, Inc.

License:: Apache 2.0

