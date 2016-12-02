require 'spec_helper'

mode = 644

case os[:family]
when 'ubuntu', 'debian'
    case os[:release]
    when /16.04/
        mode = 777
    when /14.04/
    end
when 'redhat'
    case os[:release]
    when ''
    end
end

describe 'cop_mysql::install_client' do
  describe file('/etc/mysql/my.cnf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode mode }
  end
end
