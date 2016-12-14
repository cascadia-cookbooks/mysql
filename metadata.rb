name                'cop_mysql'
description         'Installs and configures MySQL 5.6.'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license             'MIT'
maintainer          'Copious, Inc.'
maintainer_email    'engineering@copiousinc.com'
version             '0.6.2'
source_url          'https://github.com/copious-cookbooks/mysql'
issues_url          'https://github.com/copious-cookbooks/mysql/issues'

supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 6'
supports 'rhel', '>= 6'
supports 'centos', '>= 6'

depends 'database'
