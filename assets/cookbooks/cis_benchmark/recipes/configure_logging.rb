directory '/var/lib/journald-cloudwatch-logs' do
  recursive true
  owner 'root'
  group 'root'
  mode 0o640
end

cookbook_file '/usr/local/bin/journald-cloudwatch-logs' do
  source 'journald-cloudwatch-logs'
  owner 'root'
  group 'root'
  mode 0o755
end

cookbook_file '/etc/journald-cloudwatch-logs.conf' do
  source 'journald-cloudwatch-logs.conf'
  owner 'root'
  group 'root'
  mode 0o644
end

systemd_unit 'journald-cloudwatch-logs.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=journald-cloudwatch-logs
  Wants=basic.target
  After=basic.target network.target

  [Service]
  ExecStart=/usr/local/bin/journald-cloudwatch-logs /etc/journald-cloudwatch-logs.conf
  KillMode=process
  Restart=on-failure
  RestartSec=42s

  [Install]
  WantedBy=multi-user.target
  EOU

  action %i[create enable]
end
