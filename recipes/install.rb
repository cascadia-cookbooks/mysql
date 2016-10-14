# install packages
mysql_packages = node['mysql']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

# start / enable service
service 'mysql' do
    action :nothing
    supports :start => true, :stop => true, :restart => true, :reload => false, :status => true
end

# add config file and restart / reload
template '/etc/mysql/my.cnf' do
    action    :create
    source    'my.cnf.erb'
    mode      '0440'
    owner     'root'
    group     'root'
    variables (
        node['mysql']['conf']
    )
    notifies :restart, 'service[mysql]', :immediately
end
