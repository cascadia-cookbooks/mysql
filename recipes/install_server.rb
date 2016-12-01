#
# Cookbook Name:: cop_mysql
# Recipe:: install_server
#

include_recipe 'apt'
include_recipe 'cop_mysql::dependencies'

service        = node['mysql']['service']
mysql_packages = node['mysql']['server']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

directory node['mysql']['log_dir'] do
    owner  node['mysql']['conf']['user']
    group  node['mysql']['conf']['user']
    action :create
end

template node['mysql']['conf_file'] do
    action    :create
    source    'server-my.cnf.erb'
    mode      '0644'
    owner     'root'
    group     'root'
    variables (
        node['mysql']['conf']
    )
    notifies :restart, "service[#{service}]", :immediately
end

service service do
    action [:start, :enable]
end

if node['mysql']['change_root'] == true
    include_recipe 'cop_mysql::security'
end

include_recipe 'cop_mysql::tables_and_users'
