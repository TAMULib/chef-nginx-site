# encoding: UTF-8
#
# Cookbook Name:: php-site
# Recipe:: default
#
# Copyright 2014, Texas A&M University Library
#
include_recipe 'nginx-site::default'

package 'php-fpm' do
  not_if { File.exist? '/usr/sbin/php-fpm' }
end

service 'php-fpm' do
  supports status: true, restart: true
  action [:start, :enable]
end

node['php']['modules'].each do |name|

  package "php-#{name}" do
    notifies :restart, 'service[php-fpm]', :delayed
  end

  if name == 'mssql'
    template '/etc/freetds.conf' do
      only_if { node.attribute?('mssql') }
      source 'freetds.conf.erb'
      mode 0644
      owner 'root'
      group 'root'
      variables(
        servers: node['mssql']
      )
      notifies :restart, 'service[php-fpm]', :delayed
    end
  end

end

file '/etc/php-fpm.d/www.conf' do
  action :delete
  notifies :restart, 'service[php-fpm]', :delayed
end

directory '/var/lib/php/session' do
  recursive true
  owner node['nginx']['user']
  group node['nginx']['user']
end

template '/etc/php-fpm.d/fpm.conf' do
  source 'fpm.conf.erb'
  variables(
    vhosts: node['vhosts'],
    nginx: node['nginx']
  )
  notifies :restart, 'service[php-fpm]', :delayed
end

template '/etc/php.ini' do
  source 'php.ini.erb'
  notifies :restart, 'service[php-fpm]', :delayed
  variables(
    php: node['php']
  )
  notifies :restart, 'service[php-fpm]', :delayed
end
