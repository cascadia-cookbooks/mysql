#
# Cookbook Name:: cop_mysql
# Recipe:: install_server
#

mysql_packages = node['mysql']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

template '/etc/mysql/my.cnf' do
    action    :create
    source    'my.cnf.erb'
    mode      '0644'
    owner     'root'
    group     'root'
    variables (
        node['mysql']['conf']
    )
    notifies :restart, 'service[mysql]', :immediately
end

service 'mysql' do
    action [:start, :enable]
end
