require 'spec_helper'

case os[:family]
when 'ubuntu', 'debian'
    config  = '/etc/mysql/my.cnf'
    package = 'mysql-community-client'
    mode    = 777
when 'redhat'
    package = 'mysql-community-client'
    config  = '/etc/my.cnf'
    mode    = 644
end

describe 'cop_mysql::install_client' do
  describe package(package) do
    it { should be_installed }
  end

  describe file(config) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode mode }
  end
end
