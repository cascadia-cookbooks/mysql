require 'spec_helper'

case os[:family]
when 'ubuntu', 'debian'
    config = '/etc/mysql/my.cnf'
    case os[:release]
    when /16.04/
        package = 'mysql-client-5.7'
        mode    = 777
    when /14.04/
        package = 'mysql-client-5.6'
        mode    = 644
    end
when 'redhat'
    package = 'mysql-community-client'
    config  = '/etc/my.cnf'
    mode    = 644
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

  describe service('mysql') do
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening.with('tcp') }
  end
end
