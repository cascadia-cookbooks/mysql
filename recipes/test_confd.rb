#
# Cookbook Name:: cop_mysql
# Recipe:: test_confd
#

mysql_confd 'kitchen' do
    action  :create
    options ({
        'general-log' => 1,
        'read-only'   => 1
    })
end
