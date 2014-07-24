nginx-site Cookbook
===================
Cookbook for creating nginx sites to be used in conjunction with nginx cookbook. 

Requirements
------------

#### supported OS
- RHEL/CentOS/Oracle Linux 6.4/6.5

#### cookbooks
- `nginx` - nginx cookbook, '~> 2.6'

Attributes
----------

#### nginx-site::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['vhosts']</tt></td>
    <td>Hash</td>
    <td>vhosts</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['php']</tt></td>
    <td>Hash</td>
    <td>the php configuration</td>
    <td><tt>see below</tt></td>
  </tr>
  <tr>
    <td><tt>['php']['modules']</tt></td>
    <td>Array</td>
    <td>list of php modules needs to be installed</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['php']['ini']</tt></td>
    <td>Hash</td>
    <td>the php ini configuration</td>
    <td><tt>currently Five available:<br>
	post_max_size ( default = 8M )<br>
	upload_max_filesize ( default = 8M )<br>
	timezone ( default = America/Chicago )<br>
	error_reporting ( default = E_ERROR | E_WARNING | E_PARSE )<br>
	log_errors ( default = on )	
	</tt></td>
  </tr>
  <tr>
    <td><tt>['mssql']</tt></td>
    <td>Hash</td>
    <td>the mssql server configuration (freetds)</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['mssql']</tt></td>
    <td>Hash</td>
    <td>the mssql server configuration (freetds)</td>
    <td><tt>nil</tt></td>
  </tr>  

</table>

Usage
-----
#### nginx-site::default

Include `nginx-site` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nginx-site]"
  ]
}
```

`vhosts` is a Hash where key is name of the file in '/etc/nginx/sites-available' and value is a hash with following keys:

- key - name
- 'server_name' - (required) server name
- 'root' - (required) server root
- 'default' - whether it's default site, default false
- 'rewritefile' - The name of a file with rewrite rules in it.  This file will be copied from the cookbook /files store and included in the sites-enabled configuration file.  This is used by Guides on the Side.
- 'autoindex' - whether autoindex is enabled for the root directory, default false
- 'error_log' - error log, default "#{node['nginx']['log_dir']}/name-error.log"
- 'access_log' - access log, default "#{node['nginx']['log_dir']}/name-access.log"
- 'php' - php info, use in conjuction with php-site cookbook
  - 'root' - php root, default to 'root' if not specific
- 'uwsgi' - uwsgi info, use in conjuction with uwsgi-site cookbook
  - 'static' - Hash list of static locations
    - key - url location
    - value - path of static location

#### nginx-site::default

For php site, use `nginx-site::php` instead, and set the `node['php']` attributes as described above. For example, to setup a site named `test` with mysql and mssql, with post_max_size and upload_max_filesize set to 128M, module you'd set:

```ruby
default_attributes(
  'php' => {
    'modules' => ['mysql','mssql'],
    'ini' => {
      'post_max_size' => '128M',
      'upload_max_filesize' => '128M',
    },
  },
  'vhosts' => {
    'test' => {
      'server_name' => 'test.com',
      'root' => '/usr/share/nginx/www',
      'default' => true,
      'php' => {
        'root' => '/usr/share/nginx/php',
      },
    },
  },
)
```

```ruby
name "guideonthesidedev"
description "Guide on the Side Dev Server"
run_list(
  "recipe[nginx-site::php@0.2.2]",
  "recipe[guide@0.2.0]",
)

default_attributes(
  'logstash' => {
    'disabled' => true,
  },
  'php' => {
    'modules' => [
      'ldap',
      'mysql',
      'imap',
      'xml',
    ],  
  },
  'mssql' => {
    'mssql-prod3' => {
      'host' => 'mssql-prod3.library.tamu.edu',
      'instance' => 'mssqlprod3',
      'tds version' => '7.0',
    },
    'mssql-prod4' => {
      'host' => 'mssql-prod4.library.tamu.edu',
      'instance' => 'mssqlprod4',
      'tds version' => '7.0',
    },
    'mssql-sp1' => {
      'host' => 'mssql-sp1.library.tamu.edu',
      'instance' => 'mssqlsp1',
      'tds version' => '7.0',
    },
    'mssql-sp2' => {
      'host' => 'mssql-sp2.library.tamu.edu',
      'instance' => 'mssqlsp2',
      'tds version' => '7.0',
    },
    'mssql-dev3' => {
      'host' => 'mssql-dev3.library.tamu.edu',
      'instance' => 'mssqldev3',
      'tds version' => '7.0',
    },
  },
  'vhosts' => {
    'gots' => {
      'server_name' => 'osd9.library.tamu.edu',
      'root' => '/data/gots/',
      'default' => true,
      'rewritefile' => 'gots_rewrite_rules',
      'php' => {
        'root' => '/data/gots/',
      },
    },
  },
  'log' => {
    '/var/log/nginx/error.log' => {
      'type' => 'nginxerror',
      'tag' => 'osd9.library.tamu.edu',
      'extra' => {
        'add_field' => '[ "site", "osd9.library.tamu.edu" ]',
      },
    },
  },
)

```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Richard Li
