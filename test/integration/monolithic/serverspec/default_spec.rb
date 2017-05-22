require 'spec_helper'

version = /5.7/
service = 'mysql'

case os[:family]
when 'ubuntu', 'debian'
  master_config  = '/etc/mysql/my.cnf'
  master_mode    = 777
  client_config  = '/etc/mysql/conf.d/client.cnf'
  client_mode    = 644
  client_package = 'mysql-community-client'
  server_config  = '/etc/mysql/conf.d/server.cnf'
  server_mode    = 644
  server_package = 'mysql-community-server'
when 'redhat'
  case os[:release]
  when /7.*/
    service      = 'mysqld'
  end
  master_config  = '/etc/my.cnf'
  master_mode    = 644
  client_config  = '/etc/my.cnf.d/client.cnf'
  client_mode    = 644
  client_package = 'mysql-community-client'
  server_config  = '/etc/my.cnf.d/server.cnf'
  server_mode    = 644
  server_package = 'mysql-community-server'
end

# Master config
describe 'cop_mysql::master_config' do
  describe file(master_config) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode master_mode }
  end
end

# Client tests
describe 'cop_mysql::install_client' do
  describe package(client_package) do
    it { should be_installed }
  end

  describe file(client_config) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root'}
    it { should be_mode client_mode }
  end
end

# Server tests
describe 'cop_mysql::install_server' do
  describe package(server_package) do
    it { should be_installed }
  end

  describe file('/usr/sbin/mysqld') do
    it { should be_executable }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '755' }
  end

  describe command('/usr/sbin/mysqld -V') do
    its(:stdout) { should match version }
  end

  describe file(server_config) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode server_mode }
  end

  describe file('/var/lib/mysql') do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe service(service) do
    it { should be_running }
  end

  describe file('/var/run/mysqld/mysqld.sock') do
    it { should exist }
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe port(3306) do
    it { should be_listening.with('tcp') }
  end
end
