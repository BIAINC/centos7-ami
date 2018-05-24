node.default['cis_benchmark']['disabled_modules']['filesystems']      = %w[cramfs freevxfs jffs2 hfs hfsplus squashfs udf vfat]
node.default['cis_benchmark']['disabled_modules']['protocols']        = %w[dccp sctp rds tipc]
node.default['cis_benchmark']['disabled_modules']['other']            = %w[usb-storage]

node.default['cis_benchmark']['package']['remove']['selinux']         = %w[setroubleshoot mcstrans]
node.default['cis_benchmark']['package']['remove']['service_clients'] = %w[ypbind rsh talk telnet openldap-clients]
node.default['cis_benchmark']['package']['remove']['xorg']            = %w[xorg-x11-apps xorg-x11-docs xorg-x11-drivers xorg-x11-drv-ati
                                                                           xorg-x11-drv-dummy xorg-x11-drv-evdev xorg-x11-drv-evdev-devel
                                                                           xorg-x11-drv-evdev-devel xorg-x11-drv-fbdev xorg-x11-drv-intel
                                                                           xorg-x11-drv-intel xorg-x11-drv-intel-devel xorg-x11-drv-intel-devel
                                                                           xorg-x11-drv-keyboard xorg-x11-drv-libinput xorg-x11-drv-libinput-devel
                                                                           xorg-x11-drv-libinput-devel xorg-x11-drv-mouse xorg-x11-drv-mouse-devel
                                                                           xorg-x11-drv-mouse-devel xorg-x11-drv-nouveau xorg-x11-drv-openchrome
                                                                           xorg-x11-drv-openchrome xorg-x11-drv-openchrome-devel
                                                                           xorg-x11-drv-openchrome-devel xorg-x11-drv-qxl xorg-x11-drv-synaptics
                                                                           xorg-x11-drv-synaptics-devel xorg-x11-drv-synaptics-devel xorg-x11-drv-v4l
                                                                           xorg-x11-drv-vesa xorg-x11-drv-vmmouse xorg-x11-drv-vmware xorg-x11-drv-void
                                                                           xorg-x11-drv-wacom xorg-x11-drv-wacom-devel xorg-x11-drv-wacom-devel
                                                                           xorg-x11-font-utils xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi
                                                                           xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi
                                                                           xorg-x11-fonts-ISO8859-14-100dpi xorg-x11-fonts-ISO8859-14-75dpi
                                                                           xorg-x11-fonts-ISO8859-15-100dpi xorg-x11-fonts-ISO8859-15-75dpi
                                                                           xorg-x11-fonts-ISO8859-2-100dpi xorg-x11-fonts-ISO8859-2-75dpi
                                                                           xorg-x11-fonts-ISO8859-9-100dpi xorg-x11-fonts-ISO8859-9-75dpi
                                                                           xorg-x11-fonts-Type1 xorg-x11-fonts-cyrillic xorg-x11-fonts-ethiopic
                                                                           xorg-x11-fonts-misc xorg-x11-proto-devel xorg-x11-server-Xdmx
                                                                           xorg-x11-server-Xephyr xorg-x11-server-Xnest xorg-x11-server-Xorg
                                                                           xorg-x11-server-Xspice xorg-x11-server-Xvfb xorg-x11-server-common
                                                                           xorg-x11-server-devel xorg-x11-server-devel xorg-x11-server-source
                                                                           xorg-x11-server-utils xorg-x11-util-macros xorg-x11-utils xorg-x11-xauth
                                                                           xorg-x11-xbitmaps xorg-x11-xinit xorg-x11-xinit-session xorg-x11-xkb-extras
                                                                           xorg-x11-xkb-utils xorg-x11-xkb-utils-devel xorg-x11-xkb-utils-devel
                                                                           xorg-x11-xtrans-devel]
node.default['cis_benchmark']['package']['remove']['other']          = %w[xinetd postfix]

node.default['cis_benchmark']['package']['install']['selinux']       = %w[selinux-policy-targeted]
node.default['cis_benchmark']['package']['install']['other']         = %w[audit aide openscap-scanner scap-security-guide clamav clamav-update prelink screen]

node.default['cis_benchmark']['services']['disabled']['uncommon']    = %w[avahi-daemon cups slapd nfs rpcbind named vsftpd httpd dovecot smb squid
                                                                          snmpd ypserv rsh.socket telnet.socket tftp.socket rsyncd ntalk]
node.default['cis_benchmark']['services']['disabled']['other']       = %w[autofs]

node.default['cis_benchmark']['services']['enabled']['system']       = %w[auditd crond sshd]
node.default['cis_benchmark']['services']['enabled']['other']        = %w[]

node.default['cis_benchmark']['sysctl']['enabled']['hosts_and_routers'] = %w[net.ipv4.conf.all.log_martians net.ipv4.conf.default.log_martians net.ipv4.icmp_echo_ignore_broadcasts
                                                                             net.ipv4.icmp_ignore_bogus_error_responses net.ipv4.tcp_syncookies net.ipv4.conf.all.rp_filter
                                                                             net.ipv4.conf.default.rp_filter net.ipv6.conf.default.accept_ra net.ipv6.conf.all.accept_ra]
node.default['cis_benchmark']['sysctl']['enabled']['other']          = %w[kernel.dmesg_restrict]

node.default['cis_benchmark']['sysctl']['disabled']['hosts']         = %w[net.ipv4.conf.default.send_redirects net.ipv4.conf.all.send_redirects net.ipv4.ip_forward]

node.default['cis_benchmark']['sysctl']['disabled']['hosts_and_routers'] = %w[net.ipv4.conf.all.accept_source_route net.ipv4.conf.all.accept_redirects net.ipv4.conf.all.secure_redirects
                                                                              net.ipv4.conf.default.secure_redirects net.ipv4.conf.lo.secure_redirects
                                                                              net.ipv4.conf.default.accept_redirects net.ipv4.conf.default.accept_redirects net.ipv6.conf.all.accept_redirects
                                                                              net.ipv6.conf.default.accept_redirects net.ipv6.conf.all.forwarding net.ipv6.conf.default.forwarding]
node.default['cis_benchmark']['sysctl']['disabled']['other']          = %w[fs.suid_dumpable]

node.default['cis_benchmark']['sysctl']['custom']                     = {
  'kernel.randomize_va_space' => 2
}

node.default['cis_benchmark']['cron']['allowed']                      = %w[root]

node.default['cis_benchmark']['ntp']['servers']                       = %w[169.254.169.123]

node.default['cis_benckmark']['motd']['issue_message']                = "Authorized uses only. All Activity may be monitored and reported.\n"
node.default['cis_benchmark']['motd']['org_name']                     = 'TotalDiscovery'

node.default['cis_benchmark']['selinux']['mode']                      = 'permissive'
node.default['cis_benchmark']['selinux']['type']                      = 'targeted'

node.default['cis_benchmark']['ssh']['config'] = {
  protocol: 2,
  ciphers: 'aes128-ctr,aes192-ctr,aes256-ctr',
  macs: 'hmac-sha2-512,hmac-sha2-256',
  allowed_groups: 'wheel',
  log_level: 'INFO',
  x11_forwarding: 'yes',
  max_auth_tries: 4,
  ignore_rhosts: 'yes',
  host_based_authentication: 'no',
  permit_root_login: 'no',
  permit_empty_passwords: 'no',
  permit_user_environment: 'no',
  client_alive_interval: 300,
  client_alive_count_max: 0,
  login_grace_time: 60
}
node.default['cis_benchmark']['login']['pam']['lockout_threshold']         = 5
node.default['cis_benchmark']['login']['pam']['unlock_time']               = 900
node.default['cis_benchmark']['login']['pam']['remember_passwords']        = 24
node.default['cis_benchmark']['login']['max_password_age']                 = 60
node.default['cis_benchmark']['login']['min_password_age']                 = 7
node.default['cis_benchmark']['login']['pass_warn_age']                    = 7
node.default['cis_benchmark']['login']['pass_min_length'] = 7
node.default['cis_benchmark']['login']['inactive']                         = 30
node.default['cis_benchmark']['login']['pwquality']['minlen']              = 15
node.default['cis_benchmark']['login']['pwquality']['lcredit']             = -1
node.default['cis_benchmark']['login']['pwquality']['ucredit']             = -1
node.default['cis_benchmark']['login']['pwquality']['dcredit']             = -1
node.default['cis_benchmark']['login']['pwquality']['ocredit']             = -2
node.default['cis_benchmark']['login']['pwquality']['difok']               = 8
node.default['cis_benchmark']['login']['pwquality']['minclass']            = 4
