#
# Cookbook Name:: cop_mysql
# Recipe:: install_server
#

include_recipe 'cop_mysql::dependencies'

service        = node['mysql']['service']
mysql_packages = node['mysql']['server']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

directory node['mysql']['log_dir'] do
    mode   0755
    owner  node['mysql']['conf']['user']
    group  node['mysql']['conf']['user']
    action :create
end

directory node['mysql']['conf_import'] do
    mode   0755
    owner  'root'
    group  'root'
    action :create
end

file node['mysql']['conf_file'] do
    content   "!includedir #{node['mysql']['conf_import']}/"
    mode      '0644'
    owner     'root'
    group     'root'
end

template "#{node['mysql']['conf_import']}/server.cnf" do
    action    :create
    source    'server-my.cnf.erb'
    mode      '0644'
    owner     'root'
    group     'root'
    backup    5
    variables (
        node['mysql']['conf']
    )
    notifies :restart, "service[#{service}]", :immediately
end

service service do
    action [:start, :enable]
    retries 1
    # NOTE: Retry has been added to prevent a timing issue on Centos 7 systemd
end

if node['mysql']['change_root'] == true
    include_recipe 'cop_mysql::security'
end

include_recipe 'cop_mysql::tables_and_users'
