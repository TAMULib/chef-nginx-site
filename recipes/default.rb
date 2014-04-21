#
# Cookbook Name:: nginx-site
# Recipe:: default
#
# Copyright 2014, Texas A&M University Library

include_recipe "nginx::default" 

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
  node['vhosts'].each do |name,info|
    if info.key?('mkdir') and info['mkdir'] 
      if not File.exists?(info['root'])
        directory info['root'] do
          owner node['nginx']['user']
          group node['nginx']['group']
          recursive true
        end
      elsif not File.directory? info['root']
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
      source "vhost.conf.erb"
      path File.join("/etc/nginx/sites-available/",name)
      variables(
        :name => name,
        :info => info,
        :nginx => node['nginx'],
      )
      notifies :restart, 'service[nginx]', :delayed
    end
    nginx_site name do
      action :enable
    end
  end
end
