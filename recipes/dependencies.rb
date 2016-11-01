#
# Cookbook Name:: cop_mysql
# Recipe:: dependencies
#

node['mysql']['dependencies'].each do |dep|
    package dep do
        action :install
    end
end

package 'libmysqlclient-dev' do
    action :install
end

gem_package 'mysql2' do
    gem_binary RbConfig::CONFIG['bindir'] + '/gem'
    version    '0.3.17'
    action     :install
end
