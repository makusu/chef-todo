#
# Cookbook Name:: code
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'git' do
    action :install
    version "1:1.9.1-1ubuntu0.1"
end

package 'curl' do
    action :install
    version "7.35.0-1ubuntu2.3"
end

execute "install composer" do
    command "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin"
end

directory "/var/www" do
    user 'www-data'
    group 'www-data'
    mode '0755'
    action :create
end

directory "/var/www/.ssh" do
    user 'www-data'
    group 'www-data'
    mode '0755'
    action :create
end

directory "/var/www/api-todo-hook" do
    user 'www-data'
    group 'www-data'
    mode '0755'
    action :create
end

cookbook_file "/var/www/api-todo-hook/index.php" do
    source "index.php"
    mode "0644"
    user 'www-data'
    group 'www-data'
end

cookbook_file "/var/www/api-todo-hook/deploy.sh" do
    source "deploy.sh"
    mode "0644"
    user 'www-data'
    group 'www-data'
end

ssh_known_hosts_entry 'github.com'

git "Checkout Todo API" do
    destination "/var/www/api-todo"
    repository "https://github.com/makusu/api-todo.git"
    revision "master"
    action :sync
    user "www-data"
    group "www-data"
end

execute "composer install" do
    command "composer.phar install"
    cwd "/var/www/api-todo"
    user "www-data"
    group "www-data"
end
