#!/bin/bash
# initialize the httpd container (this is copied into the container and run via ssh)

# install git and chef
apt-get update
apt-get -y install git chef

# download the chef cookbook
git clone https://github.com/br1cked/FreeMicroVPS.git /tmp/cookbook

# configure the container
cd /tmp/cookbook
chef-client -z -o <%= @name %>
