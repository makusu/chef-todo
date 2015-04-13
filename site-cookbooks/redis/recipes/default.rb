#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'redis-server' do
    action :install
    version "2:2.8.4-2"
end

service 'redis-server' do
    action [:restart, :enable]
end
