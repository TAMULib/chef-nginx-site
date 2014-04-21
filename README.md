nginx-site Cookbook
===================
Cookbook for creating nginx sites to be used in conjunction with nginx cookbook. 

Requirements
------------

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

key - name
- 'server_name' - (required) server name
- 'root' - (required) server root
- 'default' - whether it's default site, default false
- 'autoindex' - whether autoindex is enabled for the root directory, default false
- 'error_log' - error log, default "#{node['nginx']['log_dir']}/name-error.log"
- 'access_log' - access log, default "#{node['nginx']['log_dir']}/name-access.log"
- 'php' - php info, use in conjuction with php-site cookbook
  - 'root' - php root, default to 'root' if not specific
- 'uwsgi' - uwsgi info, use in conjuction with uwsgi-site cookbook
  - 'static' - Hash list of static locations
    - key - url location
    - value - path of static location

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
