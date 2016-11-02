#
# Cookbook Name:: cop_mysql
# Recipe:: dependencies
#

case node['platform_family']
when 'fedora', 'rhel', 'centos'
    package = "#{Chef::Config[:file_cache_path]}/mysql.rpm"

    remote_file package do
        source 'https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm'
        owner  'root'
        group  'root'
        mode   '0644'
        action :create
    end

    rpm_package package do
        action :install
    end
end

node['mysql']['dependencies'].each do |dep|
    package dep do
        action :install
    end
end

gem_package 'mysql2' do
    gem_binary RbConfig::CONFIG['bindir'] + '/gem'
    version    '0.3.17'
    action     :install
end
