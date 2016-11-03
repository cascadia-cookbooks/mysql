#
# Cookbook Name:: cop_mysql
# Recipe:: tables_and_users
#

connection_info = {
    :host     => '127.0.0.1',
    :port     => '3306',
    :username => 'root',
    :password => node['mysql']['root_password']
}

node['mysql']['databases'].each do |database|
    mysql_database database do
        connection connection_info
        action     :create
    end
end

node['mysql']['users'].each do |user, data|
    mysql_database_user user do
        connection connection_info
        password   data['password']
        action     :create
    end

    mysql_database_user user do
        connection    connection_info
        privileges    data['privileges']
        host          '%'
        database_name data['database']
        action        :grant
    end
end
