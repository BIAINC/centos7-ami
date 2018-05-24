
node.default['cis_benchmark']['audit']['config'] = {
  'local_events' => 'yes',
  'write_logs' => 'yes',
  'log_file' => '/var/log/audit/audit.log',
  'log_group' => 'root', 'log_format' => 'RAW',
  'flush' => 'data',
  'freq' => '50',
  'max_log_file' => '50',
  'num_logs' => '18',
  'priority_boost' => '4',
  'disp_qos' => 'lossy',
  'dispatcher' => '/sbin/audispd',
  'name_format' => 'NONE',
  'max_log_file_action' => 'rotate',
  'space_left' => '75',
  'space_left_action' => 'syslog',
  'action_mail_acct' => 'root',
  'admin_space_left' => '50',
  'admin_space_left_action' => 'halt',
  'disk_full_action' => 'SUSPEND',
  'disk_error_action' => 'SUSPEND',
  'use_libwrap' => 'yes',
  'tcp_listen_queue' => '5',
  'tcp_max_per_addr' => '1',
  'tcp_client_max_idle' => '0',
  'enable_krb5' => 'no',
  'krb5_principal' => 'auditd',
  'distribute_network' => 'no'
}

rules = node.default['cis_benchmark']['audit']['rules']

rules['time_change'] = [
  '-w /etc/localtime -p wa -k audit_time_rules',
  '-a always,exit -F arch=b32 -S settimeofday -F key=audit_time_rules',
  '-a always,exit -F arch=b64 -S settimeofday -F key=audit_time_rules',
  '-a always,exit -F arch=b32 -S adjtimex -F key=audit_time_rules',
  '-a always,exit -F arch=b64 -S adjtimex -F key=audit_time_rules',
  '-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -F key=time-change',
  '-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -F key=time-change'
]

rules['user_management'] = [
  '-w /etc/group -p wa -k identity',
  '-w /etc/passwd -p wa -k identity',
  '-w /etc/gshadow -p wa -k identity',
  '-w /etc/shadow -p wa -k identity',
  '-w /etc/security/opasswd -p wa -k identity'
]

rules['network_environment'] = [
  '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale',
  '-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale',
  '-w /etc/issue -p wa -k system-locale',
  '-w /etc/issue.net -p wa -k system-locale',
  '-w /etc/hosts -p wa -k system-locale',
  '-w /etc/sysconfig/network -p wa -k system-locale'
]

rules['manditory_access_controls'] = [
  '-w /etc/selinux/ -p wa -k MAC-policy'
]

rules['login_logout_events'] = [
  '-w /var/log/lastlog -p wa -k logins',
  '-w /var/run/faillock/ -p wa -k logins',
  '-w /var/log/tallylog -p wa -k logins'
]

rules['session_information'] = [
  '-w /var/run/utmp -p wa -k session',
  '-w /var/log/wtmp -p wa -k session',
  '-w /var/log/btmp -p wa -k session'
]

rules['dac_modification'] = [
  '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  '-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  '-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  '-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  '-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod'
]

rules['unauthorized_file_access'] = [
  '-a always,exit -F arch=b32 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -F key=access',
  '-a always,exit -F arch=b32 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -F key=access',
  '-a always,exit -F arch=b64 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -F key=access',
  '-a always,exit -F arch=b64 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -F key=access'
]

rules['privileged_commands'] = [
  '-a always,exit -F path=/usr/lib/polkit-1/polkit-agent-helper-1 -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/wall -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/chage -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/gpasswd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/newgrp -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/chfn -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/chsh -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/mount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/umount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/write -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/crontab -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/ssh-agent -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/pkexec -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/bin/screen -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/sbin/pam_timestamp_check -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/sbin/unix_chkpwd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/sbin/netreport -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/sbin/usernetctl -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/lib64/dbus-1/dbus-daemon-launch-helper -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/libexec/utempter/utempter -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged',
  '-a always,exit -F path=/usr/libexec/openssh/ssh-keysign -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged'
]

rules['mounts'] = [
  '-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts',
  '-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts'
]

rules['file_deletion'] = [
  '-a always,exit -F arch=b32 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete',
  '-a always,exit -F arch=b64 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete'
]

rules['sudoers'] = [
  '-w /etc/sudoers -p wa -k scope',
  '-w /etc/sudoers.d -p wa -k scope'
]

rules['module_loading'] = [
  '-a always,exit -F arch=b64 -S init_module -S delete_module -k modules',
  '-w /usr/sbin/insmod -p x -k modules',
  '-w /usr/sbin/rmmod -p x -k modules',
  '-w /usr/sbin/modprobe -p x -k modules'
]
