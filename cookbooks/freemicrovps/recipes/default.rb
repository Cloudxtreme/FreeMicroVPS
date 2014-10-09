#
# Cookbook Name:: freemicrovps
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install required packages for LXC unprivileged containers
['lxc', 'systemd-services', 'uidmap'].each do |p|
    package p
end

# create lxc users
counter = 1     # count number of users created (for mapped UIDs/GIDs)
node[:lxc][:unprivileged][:users].each do |u|

    # create the user, group, and home directory
    user u do
        home "/home/"+u
        action :create
    end

    group u do
        action :create
        members u
    end

    directory "/home/"+u do
        mode "0700"
        user u
        group u
    end

    # configure unprivileged lxc containers

    # map IDs
    node.default[:mapped_ids] = 100000 * counter

    execute "map UIDs" do
        command "usermod --add-subuids #{node.default[:mapped_ids]}-#{node.default[:mapped_ids] + 65536} #{u}"
        action :run
    end

    execute "map GIDs" do
        command "usermod --add-subgids #{node.default[:mapped_ids]}-#{node.default[:mapped_ids] + 65536} #{u}"
        action :run
    end

    directory "/home/#{u}/.config/lxc" do
        recursive true
        mode "0700"
        user u
        group u
    end

    # configure mapped IDs
    template "/home/"+u+"/.config/lxc/default.conf" do
        source "lxc_default.conf.erb"
        mode "0600"
        owner u
        group u
    end

    # increment the counter
    counter = counter + 1
end

# set limit on number of veth devices created by each lxc user
template "/etc/lxc/lxc-usernet" do
    source "lxc-usernet.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({
        :lxc_users => node[:lxc][:unprivileged][:users]
    })
end

