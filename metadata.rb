name                'cop_mysql'
description         'Installs and configures MySQL 5.7.'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license             'MIT'
maintainer          'Copious, Inc.'
maintainer_email    'engineering@copiousinc.com'
version             '0.7.6'
source_url          'https://github.com/copious-cookbooks/mysql'
issues_url          'https://github.com/copious-cookbooks/mysql/issues'

supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 8'
supports 'rhel', '>= 7'
supports 'centos', '>= 7'

depends 'database'
