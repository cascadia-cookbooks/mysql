default['mysql']['change_root']   = true
default['mysql']['databases']     = { }
default['mysql']['users']         = { }
default['mysql']['log_dir']       = '/var/log/mysql/'
default['mysql']['root_password'] = 'hMw8oVg3nz2j0TBjy6Z1/Q=='

# https://tools.percona.com/wizard for base config generation
default['mysql']['conf'] = {
    :client_port                    => 3306,
    :client_socket                  => '/var/run/mysqld/mysqld.sock',
    :nice                           => 0,
    :user                           => 'mysql',
    :default_storage_engine         => 'InnoDB',
    :socket                         => '/var/run/mysqld/mysqld.sock',
    :pid_file                       => '/var/run/mysqld/mysqld.pid',
    :port                           => 3306,
    :bind_address                   => '0.0.0.0',
    :key_buffer_size                => '32M',
    :myisam_recover                 => 'FORCE,BACKUP',
    :max_allowed_packet             => '16M',
    :max_connect_errors             => '1000000',
    :sysdate_is_now                 => 1,
    :datadir                        => '/var/lib/mysql',
    :symbolic_links                 => 0,
    :expire_logs_days               => 1,
    :tmp_table_size                 => '32M',
    :max_heap_table_size            => '32M',
    :query_cache_type               => 0,
    :query_cache_size               => 0,
    :max_connections                => 100,
    :thread_cache_size              => 50,
    :open_files_limit               => 65535,
    :table_definition_cache         => 4096,
    :table_open_cache               => 4096,
    :innodb_flush_method            => 'O_DIRECT',
    :innodb_log_files_in_group      => 2,
    :innodb_log_file_size           => '128M',
    :innodb_flush_log_at_trx_commit => 1,
    :innodb_file_per_table          => 1,
    :innodb_thread_concurrency      => 0,
    :innodb_buffer_pool_size        => '256M',
    :general_log                    => 'OFF',
    :general_log_file               => '/var/log/mysql/mysql.log',
    :log_error                      => '/var/log/mysql/error.log',
    :log_queries_not_using_indexes  => 1,
    :slow_query_log                 => 1,
    :slow_query_log_file            => '/var/log/mysql/mysql-slow.log'
}

case node['platform_family']
when 'debian'
    default['mysql']['service']      = 'mysql'
    default['mysql']['conf_file']    = '/etc/mysql/my.cnf'
    default['mysql']['conf_import']  = '/etc/mysql/conf.d/'
    default['mysql']['dependencies'] = %w(autoconf binutils-doc bison build-essential flex gettext ncurses-dev libmysqlclient-dev)

    case node['platform_version']
    when '14.04'
        default['mysql']['client']['packages'] = %w(mysql-common-5.6 mysql-client-core-5.6 mysql-client-5.6)
        default['mysql']['server']['packages'] = %w(mysql-common-5.6 mysql-server-5.6)
    when '16.04'
        default['mysql']['client']['packages'] = %w(mysql-common-5.7 mysql-client-core-5.7 mysql-client-5.7)
        default['mysql']['server']['packages'] = %w(mysql-common-5.7 mysql-server-5.7)
    end
when 'fedora', 'rhel', 'centos'
    default['mysql']['service']      = 'mysqld'
    default['mysql']['conf_file']    = '/etc/my.cnf'
    default['mysql']['conf_import']  = '/etc/my.cnf.d/'
    default['mysql']['dependencies'] = %w(autoconf bison flex gcc gcc-c++ gettext kernel-devel make m4 ncurses-devel patch mysql-community-devel)
    default['mysql']['dependencies'] = %w(gcc44 gcc44-c++) if node['platform_version'].to_i < 6

    case node['platform_version']
    when /7.2./
        default['mysql']['client']['packages'] = %w(mysql-community-client)
        default['mysql']['server']['packages'] = %w(mysql-community-server)
    end
end
