template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  mode 0o600
  owner 'root'
  group 'root'
  variables node['cis_benchmark']['ssh']['config']
end
