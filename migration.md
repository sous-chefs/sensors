# Migration

## From recipes to resources

The `sensors::default`, `sensors::_install_lmsensors`, and `sensors::_install_ipmi` recipes have been removed. Declare the `sensors` resource directly in your own wrapper cookbook or policy.

Before:

```ruby
run_list 'recipe[sensors::default]'
```

After:

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

## From attributes to properties

The `node['sensors']['service_name']` attribute has been removed. Use the `lmsensors_service` and `lmsensors_package` properties when the platform default is not correct.

```ruby
sensors 'x7dvl' do
  sensor_config(my_sensor_config)
  lmsensors_package 'lm-sensors'
  lmsensors_service 'lm-sensors'
end
```

## Data bags

The resource can still load a sensor config from `data_bag/mainboard` when `sensor_config` is not set. New code should prefer passing `sensor_config` explicitly so the resource API owns the configuration.
