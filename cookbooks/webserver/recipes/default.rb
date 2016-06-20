#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (c) 2016 dc, All Rights Reserved.


include_recipe 'nginx::repo'
include_recipe 'nginx'
include_recipe 'nginx-hardening'

# If monit is installed, register nginx with the service.

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/monit/monitrc")
    file.insert_line_if_no_match("/nginx/", "check process nginx with pidfile /var/run/nginx.pid")
    file.insert_line_if_no_match("/nginx start/", "\s\sstart program = \"/etc/init.d/nginx start\"")
    file.insert_line_if_no_match("/nginx stop/", "\s\sstop program = \"/etc/init.d/nginx stop\"")
    file.write_file
  end
  only_if do ::File.exists?('/etc/monit/monitrc') end
end

apt_repository 'hhvm' do
	uri "http://dl.hhvm.com/ubuntu"
	keyserver "hkp://keyserver.ubuntu.com:80" 
	key "0x5a16e7281be7a449"
	distribution "trusty"
	components ["main"]
	action :add
end

package 'hhvm' do 
	action :install
end

# Replace php with hhvm
# Borrowed from the hhvm cookbook, available in the supermarket.

php_replaced = "#{Chef::Config[:file_cache_path]}/php_replaced"
hhvm_fastcgi_installed = "#{Chef::Config[:file_cache_path]}/hhvm_fastcgi_installed"


execute 'replace php' do
	command '/usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60'
	not_if do
	  ::File.exists?(php_replaced)
	end
end

file php_replaced do
	owner 'root'
	group 'root'
	mode '0644'
	action :create_if_missing
end


execute 'install fastcgi' do
	command '/usr/share/hhvm/install_fastcgi.sh'
	not_if do
	  ::File.exists?(hhvm_fastcgi_installed)
	end
end

file hhvm_fastcgi_installed do
	owner 'root'
	group 'root'
	mode '0644'
	action :create_if_missing
end

