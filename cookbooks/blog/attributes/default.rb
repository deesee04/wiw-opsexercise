#
# Cookbook Name:: blog
# Attributes:: default
#

default['blog']['version'] = 'latest'

default['blog']['db']['host'] = 'localhost'
default['blog']['db']['root_password'] = 'my_root_password'
default['blog']['db']['port'] = '3306'
default['blog']['db']['instance_name'] = 'localdb'
default['blog']['db']['mysql_version'] = '5.6'
default['blog']['db']['name'] = 'wordpressdb'
default['blog']['db']['user'] = 'wp_user'
default['blog']['db']['pass'] = nil
default['blog']['db']['server_name'] = 'localhost'
default['blog']['db']['prefix'] = 'wp_'
default['blog']['db']['charset'] = 'utf8'
default['blog']['db']['collate'] = ''
default['blog']['languages']['lang'] = ''
default['blog']['allow_multisite'] = false
default['blog']['wp_config_options'] = {}
default['blog']['parent_dir'] = '/var/www'
default['blog']['dir'] = "#{node['blog']['parent_dir']}/wordpress"
default['blog']['url'] = "https://wordpress.org/wordpress-#{node['blog']['version']}.tar.gz"
default['blog']['install']['user'] = 'www-data'
default['blog']['install']['group'] = 'www-data'
default['blog']['config_perms'] = 0644
