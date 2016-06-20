require 'spec_helper'

## Recipe - BASE

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
  its(:content) { should contain('-security').after('Allowed-Origins').before('Package-Blacklist') }
end

## Recipe - WEBSERVER

# Verify nginx service is running.

describe service('nginx') do
  it { should be_running }
end

# Verify HHVM is our working PHP.

describe command('php -v') do
   its(:stdout) { should contain('HipHop') }
end


## Recipe - BLOG

# Check that mysql is running. We check for the process, as
# the instance name is set as an attribute, and thus, 'service' 
# is unreliable.

describe command('ps aux | grep mysql') do
   its(:stdout) { should contain('/usr/sbin/mysqld') }
end

# Check MySQL port.

describe port(3306) do
  it { should be_listening }
end

# Check for Nginx config changes.

describe file('/etc/nginx/nginx.conf') do
  its(:content) { should contain('include /etc/nginx/sites-enabled/wordpress.conf') }
end

# Check that HHVM is added to the Wordpress config.

describe file('/etc/nginx/sites-enabled/wordpress.conf') do
  its(:content) { should contain('include hhvm.conf') }
end

# Check that Nginx is listening.

describe port(80) do
  it { should be_listening }
end

# Check that Nginx is serving via HHVM.

describe command ('curl -I localhost') do
  its(:stdout) { should contain('X-Powered-By: HHVM') }
end