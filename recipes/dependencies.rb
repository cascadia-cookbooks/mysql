#
# Cookbook Name:: cop_mysql
# Recipe:: dependencies
#

case node['platform_family']
when 'debian'

    # NOTE: support for https in apt repos
    package 'apt-transport-https' do
        action :install
    end

    apt_repository 'mysql' do
        uri "https://repo.mysql.com/apt/#{node['platform']}/"
        distribution "#{node['lsb']['codename']}"
        key "https://repo.mysql.com/RPM-GPG-KEY-mysql"
        components ['mysql-5.7']
    end

when 'rhel'

    yum_repository 'mysql' do
        description "MySQL 5.7 Community Repository"
        baseurl "https://repo.mysql.com/yum/mysql-5.7-community/el/#{node['platform_version'].to_i}/$basearch/"
        enabled true
        gpgcheck true
        gpgkey "https://repo.mysql.com/RPM-GPG-KEY-mysql"
        action :create
    end

end

package node['mysql']['dependencies'] do
    action :install
end

gem_package 'mysql2' do
    gem_binary RbConfig::CONFIG['bindir'] + '/gem'
    version    '0.3.17'
    action     :install
end
