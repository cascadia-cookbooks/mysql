#
# Cookbook Name:: cop_mysql
# Recipe:: default
#

include_recipe 'apt'
include_recipe 'cop_mysql::dependencies'
include_recipe 'cop_mysql::install'
include_recipe 'cop_mysql::tables_and_users'
