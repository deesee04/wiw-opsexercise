require 'spec_helper'

# Verify nginx service is running.
#
# Note: No need to check listeners,
# as we've removed the default. To set
# up listeners.. write another cookbook :)

describe service('nginx') do
  it { should be_running }
end

# Verify HHVM is our working PHP.

describe command('php -v') do
   its(:stdout) { should contain('HipHop') }
end
