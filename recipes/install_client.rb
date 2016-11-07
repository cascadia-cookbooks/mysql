#
# Cookbook Name:: cop_mysql
# Recipe:: install_client
#

mysql_packages = node['mysql']['client']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

template node['mysql']['conf_file'] do
    action    :create
    source    'my.cnf.erb'
    mode      '0644'
    owner     'root'
    group     'root'
    variables (
        node['mysql']['conf']
    )
end
