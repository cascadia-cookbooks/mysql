#
# Cookbook Name:: cop_mysql
# Recipe:: dependencies
#

cache = Chef::Config[:file_cache_path]

remote_file 'download mysql gpg key' do
    path   "#{cache}/mysql.asc"
    source 'https://repo.mysql.com/RPM-GPG-KEY-mysql'
    owner  'root'
    group  'root'
    mode   0644
    action :create_if_missing
end

case node['platform_family']
when 'debian'
    # NOTE: support for https in apt repos
    package 'apt-transport-https' do
        action :install
    end

    execute 'import mysql gpg' do
        command "apt-key add #{cache}/mysql.asc"
        # NOTE: mysql public key id: 5072e1f5
        not_if  'apt-key list | grep 5072e1f5'
        action  :run
    end

    file 'install mysql repo' do
        path    node['mysql']['repo_path']
        content "deb https://repo.mysql.com/apt/#{node['platform']}/ #{node['lsb']['codename']} mysql-5.7"
        user   'root'
        group  'root'
        mode   0644
        action :create
        notifies :run, 'execute[update apt]', :immediately
    end

    execute 'update apt' do
        command 'apt-get update'
        action  :nothing
    end
when 'rhel'
    execute 'import mysql gpg' do
        command "rpm --import #{cache}/mysql.asc"
        # NOTE: mysql public key id: 5072e1f5
        not_if  'rpm -qa gpg-pubkey* | grep 5072e1f5'
        action  :run
    end

    file 'install mysql repo' do
        path    node['mysql']['repo_path']
        content "[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=https://repo.mysql.com/yum/mysql-5.7-community/el/#{node['platform_version'].to_i}/$basearch/
enabled=1
gpgcheck=1"
        user   'root'
        group  'root'
        mode   0644
        action :create
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
