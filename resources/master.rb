resource_name :mysql_master

property :name, String, name_property: true 
property :id, Integer, required: true
property :log_bin, String, required: true
property :sync_binlog, Integer, required: true
property :binlog_format, String, required: true
property :options, kind_of: Hash, default: {}

default_action :nothing 

service = node['mysql']['service']

action :create do
    template "#{node['mysql']['conf_import']}/#{name}.cnf" do
        variables(
            :id            => id,
            :log_bin       => log_bin,
            :sync_binlog   => sync_binlog,
            :binlog_format => binlog_format,
            :options       => options
        )
        cookbook 'cop_mysql'
        source   "master.cnf.erb"
        owner    'root'
        group    'root'
        mode     0644
        backup   false
        action   :create
        notifies :restart, "service[#{service}]", :immediately
    end

    service service do
        action :nothing
    end
end

action :delete do
    file "#{node['mysql']['conf_import']}/#{name}.cnf" do
        backup   false
        action   :delete
        notifies :restart, "service[#{service}]", :immediately
    end

    service service do
        action :nothing
    end
end
