#
# Cookbook Name:: blog
# Recipe:: default
#
# Copyright (c) 2016 dc, All Rights Reserved.

# Include the webserver recipe.

include_recipe 'webserver'

# Grab encrypted credentials.

mysql_root_password = data_bag_item('database_passwords', 'mysql')
wordpress_user_password = data_bag_item('wordpress_passwords', 'wp_user')

node.set_unless['blog']['db']['pass'] = wordpress_user_password['password']
node.save

##
# Configure MySQL
##

# Shortname.

db = node['blog']['db']

# Create and start the MySQL instance.

mysql_service db['instance_name'] do
    port db['port']
    version db['mysql_version']
    initial_root_password mysql_root_password['password']
    action [:create, :start]
end

# Install the mysql2 Chef gem. In the original cookbook,
# this happens before the instance creation, but was causing
# some db pool allocation issues during the run. 

mysql2_chef_gem "default" do
  action :install
end

# Create a link to the socket in its expected location. 

socket = "/var/run/mysql-#{db['instance_name']}/mysqld.sock"

link '/var/run/mysqld/mysqld.sock' do
  to socket
  not_if 'test -f /var/run/mysqld/mysqld.sock'
end

# Set up client connection.

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :socket   => socket,
  :password => mysql_root_password['password']
}

# Create the database.

mysql_database db['name'] do
  connection  mysql_connection_info
  action      :create
end

# Create the database user.

mysql_database_user db['user'] do
  connection    mysql_connection_info
  password      wordpress_user_password['password']
  host          db['host']
  database_name db['name']
  action        :create
end

# Grant user access.

mysql_database_user db['user'] do
  connection    mysql_connection_info
  database_name db['name']
  privileges    [:all]
  action        :grant
end

# Include the wordpress installation recipe.

include_recipe "blog::wp"

