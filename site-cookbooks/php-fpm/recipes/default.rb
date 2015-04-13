#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'php5' do
    action :install
    version "5.5.9+dfsg-1ubuntu4.7"
end

package 'php5-fpm' do
    action :install
    version "5.5.9+dfsg-1ubuntu4.7"
end

package 'php5-redis' do
    action :install
    version "2.2.4-1build2"
end

service 'php5-fpm' do
    action [:restart, :enable]
end
