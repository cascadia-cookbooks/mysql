#
# Cookbook Name:: cop_mysql
# Recipe:: install_client
#

include_recipe 'cop_mysql::dependencies'

mysql_packages = node['mysql']['client']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

file node['mysql']['conf_file'] do
    content   "!includedir #{node['mysql']['conf_import']}"
    mode      '0644'
    owner     'root'
    group     'root'
end

template "#{node['mysql']['conf_import']}/client.cnf" do
    action    :create
    source    'client-my.cnf.erb'
    mode      '0644'
    owner     'root'
    group     'root'
    variables (
        node['mysql']['conf']
    )
end
