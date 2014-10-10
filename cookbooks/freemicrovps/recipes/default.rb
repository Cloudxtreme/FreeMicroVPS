#
# Cookbook Name:: freemicrovps
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# misc host system config
###############################

# install required packages for LXC unprivileged containers
['lxc', 'systemd-services', 'uidmap', 'iptables-persistent'].each do |p|
    package p
end

# create ssh keys for root
execute "create root ssh keys" do
    command "ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''"
    action :run
end

# set cfq io scheduler
execute "set io scheduler" do
    command "sed -r -i 's/(GRUB_CMDLINE_LINUX=\")(\")/\\1elevator=cfq\\2/' /etc/default/grub"
    action :run
end
execute "update grub" do
    command "update-grub"
    action :run
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

# create lxc users and containers
###############################

counter = 0     # count number of users created (for mapped UIDs/GIDs)
node[:lxc][:unprivileged][:users].each do |name|

    # increment the counter
    counter = counter + 1

    # create the user, group, and home directory
    user name do
        home "/home/"+name
        shell "/bin/bash"
        password "$1$cVfXPj7V$ODuKyEYiA8iRRsnUoVP1L1"   # password = "changeme"
        action :create
    end

    group name do
        action :create
        members name
    end

    directory "/home/"+name do
        mode "0711"
        user name
        group name
    end

    # create ssh config dir
    directory "/home/#{name}/.ssh" do
        mode "0700"
        user name
        group name
    end

    # copy root's ssh public key into the user's .ssh dir
    execute "copy ssh public key to .ssh dir" do
        command "cp ~/.ssh/id_rsa.pub /home/#{name}/.ssh/authorized_keys"
        action :run
    end
    
    # configure unprivileged lxc containers

    # map IDs
    mapped_ids = 100000 * counter

    execute "map UIDs" do
        command "usermod --add-subuids #{mapped_ids}-#{mapped_ids + 65536} #{name}"
        action :run
    end

    execute "map GIDs" do
        command "usermod --add-subgids #{mapped_ids}-#{mapped_ids + 65536} #{name}"
        action :run
    end

    directory "/home/#{name}/.config/lxc" do
        recursive true
        mode "0700"
        user name
        group name
    end

    # configure mapped IDs
    template "/home/"+name+"/.config/lxc/default.conf" do
        source "lxc_default.conf.erb"
        mode "0600"
        owner name
        group name
        variables({
            :mapped_ids => mapped_ids
        })
    end

    # create container
    execute "create #{name} container" do
        command "sudo -i -u #{name} lxc-create -n #{name} -t download -- -d ubuntu -r trusty -a amd64"
        action :run
    end

    # start container
    execute "start #{name} container" do
        command "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-start -n #{name} -d"
        action :run
    end

    # copy the init script to the container (installs git and chef and downloads and runs the recipe)
    template "/home/#{name}/.local/share/lxc/#{name}/rootfs/root/init.sh" do
        source "init_container.sh"
        mode "0777"
        owner "root"
        group "root"
        variables({
            :name => name
        })
    end

    # set up the httpd container
    execute "set up #{name} container" do
        command "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-attach -n #{name} -- /root/init.sh"
        action :run
    end

end


# set up networking
###############################

# set up dhcp
dhcp_hosts = {"lxc"=>"10.0.3.2", "www"=>"10.0.3.3"}
template "/etc/lxc/dnsmasq.conf" do
    source "dnsmasq.conf"
    mode "0644"
    owner "root"
    group "root"
    variables({
        :dhcp_hosts => dhcp_hosts
    })
end

# set up port forwarding for http server
template "/etc/iptables/rules.v4" do
    source "iptables_rules.v4"
    mode "0644"
    owner "root"
    group "root"
    variables({
        :http_ip => dhcp_hosts["www"],
        :http_port => "80"
    })
end
