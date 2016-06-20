require 'spec_helper'

# Verify monit service.

describe service('monit') do
  it { should be_running }
end

# Verify monit port.

describe port(2812) do
  it { should be_listening }
end

# Verify deployment user data.

describe user('deploy') do
  it { should exist }
  it { should have_home_directory '/home/deploy' }
end

# Verify security auto-updates.

describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
  its(:content) { should contain('-security').after('Allowed-Origins').before('Origins-Pattern') }
  its(:content) { should contain('-security').after('Origins-Pattern').before('Package-Blacklist') }
end