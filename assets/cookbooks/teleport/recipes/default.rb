#
# Cookbook:: teleport
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

cookbook_file '/tmp/teleport.tar.gz' do
  source 'teleport-ent-v2.3.5-linux-amd64-bin.tar.gz'
  action :create
end

execute 'install teleport' do
  command 'tar --strip 1 -xvzf /tmp/teleport.tar.gz -C /usr/local/bin teleport-ent/tctl teleport-ent/teleport teleport-ent/tsh'
end

%w[tctl teleport tsh].each do |exe|
  file "/usr/local/bin/#{exe}" do
    owner 'root'
    group 'root'
    mode '0755'
  end
end
