#
# Cookbook Name:: webserver
# Attributes:: default
#

# Nginx attributes.

override['nginx']['user'] = "www-data"
override['nginx']['group'] = "www-data"

# Normally, we'd keep this at >= 2048,
# but making it smaller here for the sake of faster execution.

override['nginx-hardening']['dh-size'] = '512'