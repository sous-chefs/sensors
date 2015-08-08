require 'spec_helper'

describe 'default installation' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04') }
  let(:chef_run) { runner.converge('sensors::default') }
end
