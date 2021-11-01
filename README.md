# Sensors Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/sensors.svg)](https://supermarket.chef.io/cookbooks/sensors)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/sensors/master.svg)](https://circleci.com/gh/sous-chefs/sensors)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Cookbook to manage hardware sensors via openipmi or lm-sensors on Linux systems.  Installs only on hardware systems. Defines sensors to poll via data bag items and installs either lm-sensors or openipmi to poll sensors depending on data bag attributes.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Chef

Chef 15.5+

### Platform

* Debian
* Ubuntu
* CentOS
* Redhat
* Oracle
* Scientific

### Attributes

`default['sensors']['service_name']` - automatically set based on platform. Debian derivatives: lm-sensors & RHEL derivatives: lm_sensors

### Data Bags

This cookbook uses a required data bag item per mainboard to configure which sensors should be ignored. This allows you to ignore fans or temperature sensors present in the chipset, but not actually used by the system manufacturer.  The cookbook will attempt to load a databag item with the ID of the mainboard in the `sensors` data bag.  The ID can be found using Ohai at `node['dmi']['base_board']['product_name']`.  Example data bags are included in the example_databags directory.

#### Example data bag for a non-IPMI systems, which will use lm-sensors

```ruby
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

```ruby
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

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
