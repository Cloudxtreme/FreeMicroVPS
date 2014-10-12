#
# Cookbook Name:: www
# Recipe:: default
#
# Copyright 2014, br1ckd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

["lighttpd", "git"].each do |p|
    package p
end

file "/var/www/index.lighttpd.html" do
    action :delete
end

# get the website files
bash "get website files" do
    code "git clone https://github.com/br1cked/FreeMicroVPS.git -b dynamic_http /var/www"
    not_if "ls /var/www/.git"
    action :run
end
