# frozen_string_literal: true

require 'spec_helper'

describe 'sensors' do
  step_into :sensors
  platform 'ubuntu', '24.04'

  let(:lmsensors_config) do
    {
      'id' => 'x7dvl',
      'description' => 'SuperMicro X7DVL',
      'type' => 'lmsensors',
      'chips' => [
        {
          'id' => 'w83627hf-isa-0290',
          'ignores' => %w(fan1 in0),
        },
      ],
    }
  end

  let(:ipmi_config) do
    {
      'id' => 'x8dtt-h',
      'description' => 'SuperMicro X8DTT-H',
      'type' => 'ipmi',
      'sensors' => %w(fan3 fan4),
    }
  end

  context 'with lmsensors config' do
    recipe do
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
    end

    it { is_expected.to install_package('lm-sensors') }
    it { is_expected.to enable_service('lm-sensors') }
    it { is_expected.to start_service('lm-sensors') }
    it { is_expected.to_not run_execute('load_sensor_modules') }
    it { is_expected.to create_template('/etc/sensors.d/x7dvl').with(mode: '0644') }
    it { is_expected.to render_file('/etc/sensors.d/x7dvl').with_content('chip "w83627hf-isa-0290"') }
    it { is_expected.to render_file('/etc/sensors.d/x7dvl').with_content('ignore fan1') }
  end

  context 'with ipmi config' do
    recipe do
      sensors 'x8dtt-h' do
        sensor_config(
          'id' => 'x8dtt-h',
          'description' => 'SuperMicro X8DTT-H',
          'type' => 'ipmi',
          'sensors' => %w(fan3 fan4)
        )
        configure_collectd true
        skip_virtual_guests false
      end
    end

    it { is_expected.to install_package('openipmi') }
    it { is_expected.to create_directory('/etc/collectd/plugins/').with(owner: 'root', group: 'root', mode: '0755') }
    it { is_expected.to create_template('/etc/collectd/plugins/ipmi.conf').with(mode: '0644') }
    it { is_expected.to render_file('/etc/collectd/plugins/ipmi.conf').with_content('Sensor "fan3"') }
  end

  context 'with delete action' do
    recipe do
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
        action :delete
      end
    end

    it { is_expected.to delete_file('/etc/sensors.d/x7dvl') }
    it { is_expected.to delete_file('/etc/collectd/plugins/ipmi.conf') }
    it { is_expected.to stop_service('lm-sensors') }
    it { is_expected.to disable_service('lm-sensors') }
    it { is_expected.to remove_package('lm-sensors') }
  end
end
