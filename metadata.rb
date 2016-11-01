name                'cop_mysql'
description         'Installs and configures MySQL 5.6.'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license             'MIT'
maintainer          'Copious, Inc.'
maintainer_email    'engineering@copiousinc.com'
version             '0.1.0'
source_url          'https://github.com/copious-cookbooks/mysql'
issues_url          'https://github.com/copious-cookbooks/mysql/issues'

supports 'rhel'
supports 'centos'
supports 'ubuntu', '>= 14.04'

depends 'apt'
depends 'database'
