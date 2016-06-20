source 'https://supermarket.chef.io'

# Main

cookbook 'webserver', 		'0.0.1', path: 'cookbooks/webserver'
cookbook 'blog',			'0.0.1', path: 'cookbooks/blog'
cookbook 'base',			'0.0.1', path: 'cookbooks/base'

# Aux
# Berkshelf does not support nested Berksfiles (booooo),
# so cookbooks needing to fetch from sources outside the supermarket
# must be defined here. 

cookbook 'nginx-hardening',	'1.0.0', git: 'https://github.com/dev-sec/chef-nginx-hardening.git'
