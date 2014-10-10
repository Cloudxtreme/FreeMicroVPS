#!/bin/bash
# initialize the httpd container (this is copied into the container and run via ssh)

# install chef and git
apt-get update
apt-get -y install chef git

# download & extract the chef cookbook
git clone https://github.com/br1cked/FreeMicroVPS.git /tmp/chef

# configure the container
cd /tmp/chef
chef-client -z -o <%= @name %>
