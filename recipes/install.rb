# install packages
mysql_packages = node.default['mysql']['packages']

mysql_packages.each do |pkg|
    package pkg do
        action :install
    end
end

# add config file
template '/etc/mysql/my.cnf' do
    action    :create
    source    'my.cnf.erb'
    mode      '0440'
    owner     'root'
    group     'root'
    variables (
        node.default['mysql']['conf']
    )
end

# restart service
service 'mysql' do
    action  :restart
end