#
# Cookbook Name:: cop_mysql
# Recipe:: test_master
#

mysql_master 'kitchen' do
    id            1
    log_bin       'mysql-bin'
    sync_binlog   1
    binlog_format 'mixed'
    action        :create
    options       ({
        'read-only'        => 0,
        'binlog-ignore-db' => 'mysql'
    })
end
