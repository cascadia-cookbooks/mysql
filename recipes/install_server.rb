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
    case node['platform_family']
    when 'debian'
        case node['platform_version']
        when '14.04'
            provider Chef::Provider::Service::Upstart
        when '16.04'
            provider Chef::Provider::Service::Systemd
        end
    end
    action [:start, :enable]
end
