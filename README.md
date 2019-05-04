Sensors Cookbook
================
[![CircleCI](https://circleci.com/gh/sous-chefs/sensors.svg?style=svg)](https://circleci.com/gh/sous-chefs/sensors)
[![Cookbook Version](https://img.shields.io/cookbook/v/sensors.svg)](https://supermarket.chef.io/cookbooks/sensors)

Cookbook to manage hardware sensors via openipmi or lm-sensors on Linux systems.  Installs only on hardware systems. Defines sensors to poll via data bag items and installs either lm-sensors or openipmi to poll sensors depending on data bag attributes.


Requirements
------------
### Chef
Chef 12.12.1+

### Platform

* Debian
* Ubuntu
* Centos
* Redhat
* Oracle
* Scientific

### Cookbooks:

*None*

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

## Contributors

This project exists thanks to all the people who contribute.
<img src="https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false" /></a>


### Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/sous-chefs#backer)]
<a href="https://opencollective.com/sous-chefs#backers" target="_blank"><img src="https://opencollective.com/sous-chefs/backers.svg?width=890"></a>

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/sous-chefs#sponsor)]
<a href="https://opencollective.com/sous-chefs/sponsor/0/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/1/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/2/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/3/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/4/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/5/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/6/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/7/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/8/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/9/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/9/avatar.svg"></a>

License and Author
------------------

Author:: Tim Smith (<tsmith84@gmail.com>)

```text
Copyright:: 2013-2014, Limelight Networks, Inc.
Copyright:: 2015, Cozy Services, Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
