require 'spec_helper'

version = /5.7/
service = 'mysql'
case os[:family]
when 'ubuntu', 'debian'
    master_config = '/etc/mysql/my.cnf'
    master_mode   = 777
    # NOTE: This follows through two symlinks to /etc/mysql/mysql.cnf which is set to 644
    config        = '/etc/mysql/conf.d/server.cnf'
    mode          = 644
    package       = 'mysql-server'
when 'redhat'
    case os[:release]
    when /7.*/
        service = 'mysqld'
    end
    master_config = '/etc/my.cnf'
    master_mode   = 644
    config        = '/etc/my.cnf.d/server.cnf'
    mode          = 644
    package       = 'mysql-community-server'
end

describe 'cop_mysql::install_server' do
  describe file('/usr/sbin/mysqld') do
    it { should be_executable }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '755' }
  end

  describe command('/usr/sbin/mysqld -V') do
    its(:stdout) { should match version }
  end

  describe file(master_config) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode master_mode }
  end

  describe file(config) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode mode }
  end

  describe file('/var/lib/mysql') do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe service(service) do
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening.with('tcp') }
  end
end
