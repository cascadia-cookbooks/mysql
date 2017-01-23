require 'spec_helper'

case os[:family]
when 'ubuntu', 'debian'
    master_config  = '/etc/mysql/my.cnf'
    master_mode    = 777
    config         = '/etc/mysql/conf.d/client.cnf'
    mode           = 644
    package        = 'mysql-community-client'
when 'redhat'
    master_config  = '/etc/my.cnf'
    master_mode    = 644
    config         = '/etc/my.cnf.d/client.cnf'
    mode           = 644
    package        = 'mysql-community-client'
end

describe 'cop_mysql::install_client' do
  describe package(package) do
    it { should be_installed }
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
end
