resource_name :mysql_slave

property :name, String, name_property: true 
property :id, Integer, required: true
property :database, String, required: false 
property :options, kind_of: Hash, default: {}

default_action :nothing

service = node['mysql']['service']

action :create do
    template "#{node['mysql']['conf_import']}/#{name}.cnf" do
        variables(
            :id       => id,
            :database => database,
            :options  => options
        )
        cookbook 'cop_mysql'
        source   "slave.cnf.erb"
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
