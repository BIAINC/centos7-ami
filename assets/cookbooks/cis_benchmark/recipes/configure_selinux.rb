template '/etc/selinux/config' do
  source 'selinux_config.erb'
  mode 0o600
  owner 'root'
  group 'root'
  variables mode: node['cis_benchmark']['selinux']['mode'], type: node['cis_benchmark']['selinux']['type']
end

execute 'restorecon -R /'
