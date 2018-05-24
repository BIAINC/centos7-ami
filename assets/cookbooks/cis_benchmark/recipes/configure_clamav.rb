execute '/usr/bin/freshclam' do
  user 'clamupdate'
end

execute 'chown -R clamupdate:virusgroup /var/lib/clamav'
execute 'semanage permissive -a antivirus_t'

systemd_unit 'clamupdate.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=ClamAV Update
  Before=clamscan.service

  [Service]
  User=clamupdate
  Nice=5
  Type=oneshot
  ExecStart=/usr/bin/freshclam

  [Install]
  WantedBy=multi-user.target

  EOU

  action %i[create enable]
end

systemd_unit 'clamscan.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=ClamAV Scan

  [Service]
  Nice=5
  Type=oneshot
  ExecStart=/usr/bin/clamscan --stdout -ri / --exclude-dir=/sys/


  EOU

  action [:create]
end

systemd_unit 'clamscan.timer' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Trigger ClamAV Update

  [Timer]
  OnBootSec=15min
  OnUnitActiveSec=1d

  [Install]
  WantedBy=timers.target
  EOU

  action %i[create enable]
end
