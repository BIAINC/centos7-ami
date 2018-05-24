template '/etc/motd' do
  source 'motd.erb'
  mode 0o644
  owner 'root'
  group 'root'
  variables org_name: node['cis_benchmark']['motd']['org_name']
end

%w[issue issue.net].each do |name|
  file "/etc/#{name}" do
    content node['cis_benckmark']['motd']['issue_message']
    mode 0o644
    owner 'root'
    group 'root'
  end
end
