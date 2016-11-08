resource_name :mysql_confd

property :name, String, name_property: true 
property :options, kind_of: Hash, default: {}

default_action :nothing 

service = node['mysql']['service']

action :create do
    template "#{node['mysql']['conf_import']}/#{name}.cnf" do
        variables(
            :options => options
        )
        cookbook 'cop_mysql'
        source   "confd.cnf.erb"
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
    file file do
        backup false
        action :delete
        notifies :restart, "service[#{service}]", :immediately
    end

    service service do
        action :nothing
    end
end
