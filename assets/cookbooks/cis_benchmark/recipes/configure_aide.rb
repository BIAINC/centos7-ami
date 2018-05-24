
cis_benchmark_file_editor '/etc/aide.conf' do
  lines(/^NORMAL/ => 'NORMAL = FIPSR+sha512',
        /^EVERYTHING/     => 'EVERYTHING = R+ALLXTRAHASHES+acl+xattrs+sha512',
        /^NORMAL/         => 'NORMAL = FIPSR+sha512+acl+xattrs',
        /^CONTENT\s+/     => 'CONTENT = ftype+acl+xattrs+sha512',
        /^CONTENT_EX/     => 'CONTENT_EX = ftype+p+u+g+n+acl+selinux+xattrs+sha512',
        /^DATAONLY/       => 'DATAONLY = p+n+u+g+s+acl+selinux+xattrs+sha512',
        /^LOG/            => 'LOG = p+u+g+n+acl+selinux+ftype+xattrs+sha512',
        /^FIPSR/          => 'FIPSR = p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha512',
        /^ALLXTRAHASHES/  => 'ALLXTRAHASHES = sha512',
        /^DIR/            => 'DIR = p+i+n+u+g+acl+selinux+xattrs+sha512',
        /^PERMS/          => 'PERMS = p+u+g+acl+selinux+xattrs+sha512',
        /^STATIC/         => 'STATIC = p+u+g+acl+selinux+xattrs+i+n+b+c+ftype+sha512')
end

execute 'semanage permissive -a aide_t'

execute 'aide -i && cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz' do
  not_if { File.exist?('/var/lib/aide/aide.db.gz') }
end

systemd_unit 'aide.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Check AIDE Database

  [Service]
  Nice=5
  Type=oneshot
  ExecStart=/usr/sbin/aide --check

  EOU

  action [:create]
end

systemd_unit 'aide.timer' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Trigger Aide Check

  [Timer]
  OnBootSec=15min
  OnUnitActiveSec=1d

  [Install]
  WantedBy=timers.target
  EOU

  action %i[create enable]
end
