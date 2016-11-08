#
# Cookbook Name:: cop_mysql
# Recipe:: test_slave
#

mysql_slave 'kitchen' do
    id      2
    action  :create
    options ({
        'read-only'         => 1,
        'log-slave-updates' => 1
    })
end
