# frozen_string_literal: true

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
  skip_virtual_guests false
end
