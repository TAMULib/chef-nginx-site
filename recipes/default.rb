# encoding: UTF-8
#
# Cookbook Name:: nginx-site
# Recipe:: default
#
# Copyright 2014, Texas A&M University Library

include_recipe 'nginx::default'

# nginx_site 'default' do
#   enable false
# end
file '/etc/nginx/sites-enabled/000-default' do
  action :delete
end
file '/etc/nginx/conf.d/default.conf' do
  action :delete
end

directory '/var/run/nginx' do
  owner node['nginx']['user']
  group node['nginx']['group']
end

if node['vhosts'].is_a? Hash

  error_logs = ['error.log']

  node['vhosts'].each do |name, info|

    if info.key?('mkdir') && info['mkdir']
      if !File.exist?(info['root'])
        directory info['root'] do
          owner node['nginx']['user']
          group node['nginx']['group']
          recursive true
        end
      elsif !File.directory? info['root']
        file info['root'] do
          action :delete
        end
        directory info['root'] do
          owner node['nginx']['user']
          group node['nginx']['group']
          recursive true
        end
      end
    end

    template name do
      source 'vhost.conf.erb'
      path File.join('/etc/nginx/sites-available/', name)
      variables(
        name: name,
        info: info,
        nginx: node['nginx']
      )
      notifies :restart, 'service[nginx]', :delayed
    end
    nginx_site name do
      action :enable
    end
    error_logs.push(if info.key?('error_log')
                      info['error_log']
                    else
                      File.join(node['nginx']['log_dir'], name + '-error.log')
                    end)
  end

  service 'rsyslog' do
    action :nothing
  end

  template '/etc/rsyslog.d/25-nginx.conf' do
    source '25-nginx.conf.erb'
    variables(
      error_log: error_logs
    )
    notifies :restart, 'service[rsyslog]', :delayed
  end

end
