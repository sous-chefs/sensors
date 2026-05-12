# frozen_string_literal: true

title 'Sensors default resource'

control 'sensors-package-01' do
  impact 1.0
  title 'lm-sensors package is installed'

  describe package(os.debian? ? 'lm-sensors' : 'lm_sensors') do
    it { should be_installed }
  end
end

control 'sensors-config-01' do
  impact 1.0
  title 'lm-sensors ignore configuration is rendered'

  describe file('/etc/sensors.d/x7dvl') do
    it { should exist }
    its('mode') { should cmp '0644' }
    its('content') { should include 'chip "w83627hf-isa-0290"' }
    its('content') { should include 'ignore fan1' }
  end
end
