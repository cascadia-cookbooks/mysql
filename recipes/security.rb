#
# Cookbook Name:: cop_mysql
# Recipe:: security
#

connection_info = {
    :socket   => node['mysql']['conf']['socket'],
    :username => 'root',
    #:password => ''
}

lock = "#{node['mysql']['datadir']}/password_locked"

case node['platform_family']
when 'fedora', 'rhel', 'centos'
    ruby_block "get password" do
        block do
            log      = ::File.read("/var/log/mysql/error.log")
            password = /generated for root@localhost:.*$/.match(log).to_s.split(" ").last
            connection_info[:password] = password
            not_if { File.exist?(lock) }
        end
    end

    execute 'change password' do
        command lazy {
            "/usr/bin/mysqladmin -uroot -p'#{connection_info[:password]}' password '#{node['mysql']['root_password']}';
             touch #{lock}"
        }
        action :run
        not_if { File.exist?(lock) }
    end
when 'debian'
    mysql_database_user 'root' do
        connection connection_info
        password   node['mysql']['root_password']
        action     :create
        notifies   :touch, 'file[password_locked]', :immediately
        not_if     { File.exist?(lock) }
    end

    file "password_locked" do
        path   lock
        action :nothing
        mode   '0444'
        owner  'root'
        group  'root'
    end
end
