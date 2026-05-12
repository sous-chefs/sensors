# sensors

Manages Linux hardware sensor polling with lm-sensors or OpenIPMI.

## Actions

| Action    | Description                                     |
|-----------|-------------------------------------------------|
| `:create` | Installs packages and writes sensor config      |
| `:delete` | Removes packages and generated config artifacts |

## Properties

| Property                | Type        | Default                         | Description                                           |
|-------------------------|-------------|---------------------------------|-------------------------------------------------------|
| `mainboard`             | String      | name property                   | Mainboard identifier used for data bag lookup/config  |
| `sensor_config`         | Hash, nil   | `nil`                           | Sensor configuration hash replacing data bag content  |
| `data_bag`              | String      | `'sensors'`                     | Data bag name used when `load_data_bag` is true       |
| `load_data_bag`         | true, false | `true`                          | Load `data_bag/mainboard` when `sensor_config` is nil |
| `skip_virtual_guests`   | true, false | `true`                          | Skip setup on EC2 or virtual guests                   |
| `configure_collectd`    | true, false | run list includes collectd      | Render collectd/IPMI integration                      |
| `lmsensors_package`     | String      | platform default                | lm-sensors package name                               |
| `lmsensors_service`     | String      | platform default                | lm-sensors service name                               |
| `ipmi_package`          | String      | platform default                | OpenIPMI package name                                 |
| `run_sensors_detect`    | true, false | `true`                          | Run `sensors-detect` once for lm-sensors              |
| `sensors_detect_marker` | String      | Chef file cache marker path     | Marker file used to make detection idempotent         |

## Examples

### lm-sensors

```ruby
sensors 'x7dvl' do
  sensor_config(
    'id' => 'x7dvl',
    'description' => 'SuperMicro X7DVL',
    'type' => 'lmsensors',
    'chips' => [
      {
        'id' => 'w83627hf-isa-0290',
        'ignores' => %w(fan1 in0),
      },
    ]
  )
  run_sensors_detect false
end
```

### OpenIPMI with collectd

```ruby
sensors 'x8dtt-h' do
  sensor_config(
    'id' => 'x8dtt-h',
    'description' => 'SuperMicro X8DTT-H',
    'type' => 'ipmi',
    'sensors' => %w(fan3 fan4)
  )
  configure_collectd true
end
```

### Legacy data bag lookup

```ruby
sensors 'x7dvl' do
  data_bag 'sensors'
  load_data_bag true
end
```
