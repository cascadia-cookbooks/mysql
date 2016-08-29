default['mysql']['version'] = '5.6'

default['mysql']['packages'] = %w(
    mysql-server
)

# defaults based on 2 cpus w/4 hyperthreading cores, 2GB memory, dedicated resources.
# https://tools.percona.com/wizard for base config generation
default['mysql']['conf'] = {
    :client_port                    => '3306',
    :client_socket                  => '/var/mysql/data/mysql.sock',
    :user                           => 'mysql',
    :default_storage_engine         => 'InnoDB',
    :socket                         => '/var/mysql/data/mysql.sock',
    :pid_file                       => '/var/mysql/data/mysql.pid',
    :key_buffer_size                => '32M',
    :myisam_recover                 => 'FORCE,BACKUP',
    :max_allowed_packet             => '16M',
    :max_connect_errors             => '1000000',
    :sysdate_is_now                 => '1',
    :datadir                        => '/var/mysql/data/',
    :log_bin                        => '/var/mysql/data/mysql-bin',
    :expire_logs_days               => '14',
    :sync_binlog                    => '1',
    :tmp_table_size                 => '32M',
    :max_heap_table_size            => '32M',
    :query_cache_type               => '0',
    :query_cache_size               => '0',
    :max_connections                => '500',
    :thread_cache_size              => '50',
    :open_files_limit               => '65535',
    :table_definition_cache         => '4096',
    :table_open_cache               => '4096',
    :innodb_flush_method            => 'O_DIRECT',
    :innodb_log_files_in_group      => '2',
    :innodb_log_file_size           => '128M',
    :innodb_flush_log_at_trx_commit => '1',
    :innodb_file_per_table          => '1',
    :innodb_buffer_pool_size        => '1456M',
    :log_error                      => '/var/mysql/data/mysql-error.log',
    :log_queries_not_using_indexes  => '1',
    :slow_query_log                 => '1',
    :slow_query_log_file            => '/var/mysql/data/mysql-slow.log'
}