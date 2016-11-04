# MySQL Cookbook
This will install the MySQL Server service via package. It will also change the 
`root` password on initial installation. It can also create MySQL users and
databases.

At this time there are no options to select a version for MySQL Server, Chef will
take care of the version depending on which OS version you are running.

## Information
### Supported Platforms
- Ubuntu 14.04 (Installs MySQL 5.6)
- Ubuntu 16.04 (Installs MySQL 5.7)
- RHEL/Centos 7 (Installs MySQL 5.7)

### Cookbook Dependencies
- apt
- database

## Cookbook Attributes
### Root Attributes
* `node['mysql']['change_root']` defaults to true, meaning that it will attempt to
change the root password after installing MySQL server. If you have already set
a root password in your database, then set this attribute to false.

* `node['mysql']['root_password']` defaults to `hMw8oVg3nz2j0TBjy6Z1/Q==`,
you need to override this attribute with your own root password.

### User / Database Attributes
* `node['mysql']['databases']` needs to be an array
* `node['mysql']['users']` needs to be a hash of named hashes

Examples are farther below.

### Tuning Attributes
See `attributes/default.rb` for default attributes and override them in your
role or environment files as needed.

## Basic Usage
Here's an example `database` role that will install MySQL.

```ruby
name 'database'
description 'installs mysql, a database, and a user!'

override_attributes(
    'mysql' => {
        'change_root' => true,
        'root_password' => 'some wild and crazy password',
        'users' => {
            'vagrant' => {
                'database' => 'test_db',
                'grants'   => %w(all),
                'password' => 'Q7uwx4vMq]492*Cuhchk'
            }
        },
        'databases' => %w{
            test_db
        }
    }
)

run_list(
    'recipe[cop_mysql]'
)
```

NOTE: You are required to include a `depends` for this cookbook inside YOUR cookbook's `metadata.rb` file.

```ruby
...
depends 'cop_mysql'
...
```

## Testing
* http://kitchen.ci
* http://serverspec.org

Testing is handled with ServerSpec, via Test Kitchen, which uses Vagrant to spin up VMs.

ServerSpec and Test Kitchen are bundled in the ChefDK package.

### Dependencies
```bash
$ brew cask install chefdk
```

### Running
Get a listing of your instances with:

```bash
$ kitchen list
```

Run Chef on an instance, in this case default-ubuntu-1404, with:

```bash
$ kitchen converge default-ubuntu-1404
```

Destroy all instances with:

```bash
$ kitchen destroy
```

Run through and test all the instances in serial by running:

```bash
$ kitchen test
```

### Errors
None so far, please open an Issue if found

## Notes
The `Berksfile.lock` file has been purposely ignored, as we don't care about
upstream dependencies. You should be setting the `.lock` file in the project
repo.
