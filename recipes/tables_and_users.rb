#
# Cookbook Name:: cop_mysql
# Recipe:: tables_and_users
#

connection_info = {
    :socket   => node['mysql']['conf']['socket'],
    :username => 'root',
    :password => node['mysql']['root_password']
}

node['mysql']['databases'].each do |database|
    mysql_database database do
        connection connection_info
        action     :create
    end
end

sensitive_info = begin
                     data_bag_item('mysql', node.chef_environment)['users']
                 rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
                     # NOTE: setting to nil will skip the condition below
                     nil
                 end

# NOTE: merge sensitive passwords with users attribute tree
if sensitive_info
    node.default['mysql']['users'] = node['mysql']['users'].merge(sensitive_info)
end

node['mysql']['users'].each do |user, data|
    mysql_database_user user do
        connection connection_info
        password   data['password']
        action     :create
    end

    data['databases'].each do |database|
        mysql_database_user user do
            connection    connection_info
            privileges    data['privileges'] || %w(all)
            host          data['host'] || '%'
            password      data['password']
            database_name database
            action        :grant
        end
    end
end
