template '/etc/audit/auditd.conf' do
  source 'auditd.conf.erb'
  mode 0o640
  owner 'root'
  group 'root'
  variables config: node['cis_benchmark']['audit']['config']
end

node['cis_benchmark']['audit']['rules'].each do |name, config|
  template "/etc/audit/rules.d/100_#{name}.rules" do
    source 'audit.rules.erb'
    mode 0o600
    owner 'root'
    group 'root'
    variables config: config
  end
end

template '/etc/audit/rules.d/200_finalize.rules' do
  source 'audit.rules.erb'
  mode 0o600
  owner 'root'
  group 'root'
  variables config: ['-f 2', '-e 2']
end
