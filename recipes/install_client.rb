#
# Cookbook Name:: cop_mysql
# Recipe:: install_client
#

include_recipe 'cop_mysql::dependencies'

package node['mysql']['client']['packages'] do
    action :install
end

file node['mysql']['conf_file'] do
    content   "!includedir #{node['mysql']['conf_import']}/"
    mode      '0644'
    owner     'root'
    group     'root'
end

directory node['mysql']['conf_import'] do
    mode   0755
    owner  'root'
    group  'root'
    action :create
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
