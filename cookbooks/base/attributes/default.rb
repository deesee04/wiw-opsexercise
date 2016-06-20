#
# Cookbook Name:: base
# Attributes:: default
#

override['apt']['compile_time_update'] = true
override['apt']['unattended_upgrades']['origins_patterns'] = ["origin=Ubuntu,archive=trusty-security"]
override['apt']['unattended_upgrades']['enable'] = true

