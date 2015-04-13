#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service 'apache2' do
    action [:stop, :disable]
end

package 'nginx' do
    action :install
    version "1.4.6-1ubuntu3.2"
end

cookbook_file "/etc/nginx/sites-available/api-todo.maxmeidendasuki.com" do
    source "api-todo.maxmeidendasuki.com"
    mode "0644"
end

link "/etc/nginx/sites-enabled/api-todo.maxmeidendasuki.com" do
    to "/etc/nginx/sites-available/api-todo.maxmeidendasuki.com"
end

cookbook_file "/etc/nginx/sites-available/api-todo-hook.maxmeidendasuki.com" do
    source "api-todo-hook.maxmeidendasuki.com"
    mode "0644"
end

link "/etc/nginx/sites-enabled/api-todo-hook.maxmeidendasuki.com" do
    to "/etc/nginx/sites-available/api-todo-hook.maxmeidendasuki.com"
end

service 'nginx' do
    action [:restart, :enable]
end
