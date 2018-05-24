cookbook_file '/usr/local/bin/metadata2env' do
  source 'metadata2env'
  owner 'root'
  group 'root'
  mode '0755'
end

systemd_unit 'metadata2env.service' do
  content <<-EOU.gsub(/^\s+/, '')
    [Unit]
    Description=Flushes EC2 Metadata to /etc/aws_metadata
    After=network.target

    [Service]
    Nice=5
    Type=oneshot
    ExecStartPre=-/bin/rm -f /etc/aws_metadata/*
    ExecStart=/usr/local/bin/metadata2env -tags VPC -tags Environment -tags Name

    [Install]
    WantedBy=multi-user.target

    EOU

  action %i[create enable]
end
