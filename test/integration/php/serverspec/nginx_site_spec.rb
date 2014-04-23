require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(80) do
  it { should be_listening }
end

describe file('/etc/nginx/sites-available/test') do
  it { should be_file }
  its(:content) { should match /server_name test/ }
  its(:content) { should match /root \/tmp/ }
  its(:content) { should match /autoindex on/}
  its(:content) { should match /listen 80 default/}
end
