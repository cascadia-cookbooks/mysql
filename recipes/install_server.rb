#
# Cookbook Name:: cop_mysql
# Recipe:: install_server
#

service = node['mysql']['service']
mysql_packages = node['mysql']['packages']

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
    notifies :restart, "service[#{service}]", :immediately
end

service service do
    action [:start, :enable]
end
