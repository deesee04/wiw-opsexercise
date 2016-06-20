#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2016 dc, All Rights Reserved.

# Include the required base recipes.

include_recipe 'apt::default'
include_recipe 'apt::unattended-upgrades'
include_recipe 'os-hardening'
include_recipe 'ssh-hardening'
include_recipe 'poise-monit'

# Allowed apt origins.

node_metadata = node['lsb']['id'] + " " + node['lsb']['codename']

node.override['apt']['unattended_upgrades']['allowed_origins'] = [
	node_metadata,
	node_metadata + "-security",
	node_metadata + "-updates" 
]

# Sysbench.

package 'sysbench' do
	action :install
end

# Monit.

monit_password = data_bag_item('monit_passwords', 'monitor')

monit "monit" do
	daemon_interval 60
	httpd_port 2812
	httpd_username "monitor"
	httpd_password monit_password['password']
end

# Create a deployment user.

deploy_password = data_bag_item('user_passwords', 'deploy')

user "deploy" do
 comment "Deployments"
 uid 2000
 gid "www-data"
 home "/home/deploy"
 shell "/bin/sh"
 password deploy_password['password']
 action :create
end