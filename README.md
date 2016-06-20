# // WIW - Ops Exercise
## // Author: Dustin Camilleri // Date: 2016-06-20


### // Overview

This project contains three cookbooks:

base - configures a base node with extra security precautions.

webserver - configures a basic Nginx-based, HHVM-backed webserver.

blog - configures a Wordpress installation backed by a local MySQL database.

Tested with Vagrant, Chef-Zero and Chef Server. 

### // Usage

#### Testing: 

Tests performed with serverspec via Test Kitchen. Tests may be run with the `kitchen test` command in the root or individual cookbook directory. 

#### Vagrant:

To start, run `vagrant up`. Once the run is complete, Wordpress installation will be available at: http://localhost:8080/

#### Chef Server:

To bootstrap and cook a node, run:

`knife bootstrap NODE_ADDRESS -N NODE_NAME --ssh-user ubuntu --sudo --bootstrap-version 12.10.24 --identity-file SSH_IDENTITY_FILE --secret-file /PATH/TO/.secrets/encrypted_data_bag_secret --run-list "recipe[base], recipe[webserver], recipe[blog]"`

Once the run has completed, Wordpress installation will be available at: http://NODE_ADDRESS/





