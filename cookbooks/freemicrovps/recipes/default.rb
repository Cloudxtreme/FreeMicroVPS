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
    not_if "ls ~/.ssh/id_rsa"
    action :run
end

# set cfq io scheduler
bash "set io scheduler" do
    code "sed -r -i 's/(GRUB_CMDLINE_LINUX=\")(\")/\\1elevator=cfq\\2/' /etc/default/grub && update-grub"
    not_if "grep elevator=cfq /etc/default/grub"
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

# set up networking
###############################

# set up dhcp
dhcp_hosts = {"lxc"=>"10.0.3.100", "www"=>"10.0.3.101"}
template "/etc/lxc/dnsmasq.conf" do
    source "dnsmasq.conf"
    mode "0644"
    owner "root"
    group "root"
    variables({
        :dhcp_hosts => dhcp_hosts
    })
end

template "/etc/default/lxc-net" do
    source "lxc-net"
    mode "0644"
    owner "root"
    group "root"
end

# set up port forwarding for http server
bash "enable port 80 DNAT" do
    code <<-EOF
        iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 80 -j DNAT --to-destination #{dhcp_hosts["www"]} && 
        iptables-save > /etc/iptables/rules.v4
    EOF
    not_if "iptables -t nat -n -L | grep -E 'DNAT.*#{dhcp_hosts["www"].sub('\.','\\.')}'"
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
        not_if { ::File.exists?("/home/#{name}/.ssh/authorized_keys") }
        action :run
    end
    
    # configure unprivileged lxc containers

    # map IDs
    mapped_ids = 100000 * counter

    execute "map UIDs" do
        command "usermod --add-subuids #{mapped_ids}-#{mapped_ids + 65536} #{name}"
        not_if "grep #{name} /etc/subuid"
        action :run
    end

    execute "map GIDs" do
        command "usermod --add-subgids #{mapped_ids}-#{mapped_ids + 65536} #{name}"
        not_if "grep #{name} /etc/subgid"
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
        not_if "sudo -i -u #{name} lxc-ls | grep #{name}"
        action :run
    end

    # start container
    execute "start #{name} container" do
        command "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-start -n #{name} -d"
        only_if "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-ls --stopped | grep #{name}"
        action :run
    end

    # unfreeze container (may be needed if chef is used to update server config and container is frozen)
    execute "unfreeze #{name} container" do
        command "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-freeze -n #{name} -d"
        only_if "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-ls --frozen | grep #{name}"
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

    # set up the httpd container (install chef, download cookbooks, run chef)
    execute "set up #{name} container" do
        command "ssh -oStrictHostKeyChecking=no #{name}@localhost lxc-attach -n #{name} -- /root/init.sh"
        timeout 6000
        action :run
    end

end

