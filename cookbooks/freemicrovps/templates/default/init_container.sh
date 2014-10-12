#!/bin/bash
# initialize the httpd container (this is copied into the container and run via ssh)

if [[ ! -d "/tmp/chef" ]]
then
    apt-get update
    apt-get -y install chef git

    git clone https://github.com/br1cked/FreeMicroVPS.git /tmp/chef
else
    git pull /tmp/chef
fi

cd /tmp/chef
chef-client -z -o <%= @name %>
