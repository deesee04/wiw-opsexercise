#
# Cookbook Name:: blog
# Recipe:: wp
#
# Copyright (c) 2016 dc, All Rights Reserved.

# Create random passwords for wp-config.php

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['blog']['keys']['auth'] = secure_password
node.set_unless['blog']['keys']['secure_auth'] = secure_password
node.set_unless['blog']['keys']['logged_in'] = secure_password
node.set_unless['blog']['keys']['nonce'] = secure_password
node.set_unless['blog']['salt']['auth'] = secure_password
node.set_unless['blog']['salt']['secure_auth'] = secure_password
node.set_unless['blog']['salt']['logged_in'] = secure_password
node.set_unless['blog']['salt']['nonce'] = secure_password
node.save unless Chef::Config[:solo]

# Create the installation directory.

directory node['blog']['dir'] do
  action :create
  recursive true
  owner node['blog']['install']['user']
  group node['blog']['install']['group']
  mode  '00755'
end

# Fetch and untar the requested Wordpress release.

tar_extract node['blog']['url'] do
  target_dir node['blog']['dir']
  creates File.join(node['blog']['dir'], 'index.php')
  user node['blog']['install']['user']
  group node['blog']['install']['group']
  tar_flags [ '--strip-components 1' ]
  not_if { ::File.exists?("#{node['blog']['dir']}/index.php") }
end

# Configure wp-config.php

template "#{node['blog']['dir']}/wp-config.php" do
  source 'wp-config.php.erb'
  mode node['blog']['config_perms']
  variables(
    :db_name           => node['blog']['db']['name'],
    :db_user           => node['blog']['db']['user'],
    :db_password       => node['blog']['db']['pass'],
    :db_host           => node['blog']['db']['host'],
    :db_prefix         => node['blog']['db']['prefix'],
    :db_charset        => node['blog']['db']['charset'],
    :db_collate        => node['blog']['db']['collate'],
    :auth_key          => node['blog']['keys']['auth'],
    :secure_auth_key   => node['blog']['keys']['secure_auth'],
    :logged_in_key     => node['blog']['keys']['logged_in'],
    :nonce_key         => node['blog']['keys']['nonce'],
    :auth_salt         => node['blog']['salt']['auth'],
    :secure_auth_salt  => node['blog']['salt']['secure_auth'],
    :logged_in_salt    => node['blog']['salt']['logged_in'],
    :nonce_salt        => node['blog']['salt']['nonce'],
    :lang              => node['blog']['languages']['lang'],
    :allow_multisite   => node['blog']['allow_multisite'],
    :wp_config_options => node['blog']['wp_config_options']
  )
  owner node['blog']['install']['user']
  group node['blog']['install']['group']
  action :create
end

# Load new nginx config.
# Configures the newly installed wordpress as the only available site.

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Include the HHVM config in place of the default for our enabled site.

template '/etc/nginx/sites-enabled/wordpress.conf' do
  source 'wordpress.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end