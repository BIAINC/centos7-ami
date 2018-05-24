cookbook_file '/usr/share/xml/scap/ssg/content/tailoring-xccdf.xml' do
  source 'tailoring-xccdf.xml'
  owner 'root'
  group 'root'
  mode 0o644
end

systemd_unit 'openscap.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Openscap Assesment

  [Service]
  Nice=5
  Type=oneshot
  ExecStart=/usr/bin/oscap xccdf eval --profile C2S_TD --fetch-remote-resources --cpe  /usr/share/xml/scap/ssg/content/ssg-rhel7-cpe-dictionary.xml /usr/share/xml/scap/ssg/content/tailoring-xccdf.xml

  [Install]
  WantedBy=multi-user.target
  EOU

  action %i[create enable]
end

systemd_unit 'openscap.timer' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Trigger ClamAV Update

  [Timer]
  OnBootSec=15min
  OnUnitActiveSec=1d

  [Install]
  WantedBy=timers.target

  EOU

  action %i[create enable start]
end
