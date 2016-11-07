#
# Cookbook Name:: cop_mysql
# Recipe:: default
#

include_recipe 'apt'

if node['mysql']['install_server'] == true
    include_recipe 'cop_mysql::dependencies'
    include_recipe 'cop_mysql::install_server'

    if node['mysql']['change_root'] == true
        include_recipe 'cop_mysql::security'
    end

    include_recipe 'cop_mysql::tables_and_users'
end

if node['mysql']['install_client'] == true
    include_recipe 'cop_mysql::install_client'
end
