require 'spec_helper'

describe 'default installation' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge 'sensors::default'
  end

end
