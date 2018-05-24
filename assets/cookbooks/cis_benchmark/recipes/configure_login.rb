template '/etc/pam.d/password-auth' do
  source 'password-auth.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables node['cis_benchmark']['login']['pam']
end

template '/etc/pam.d/system-auth' do
  source 'system-auth.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables node['cis_benchmark']['login']['pam']
end

cis_benchmark_file_editor '/etc/login.defs' do
  lines(
    /^PASS_MAX_DAYS/ => "PASS_MAX_DAYS #{node['cis_benchmark']['login']['max_password_age']}",
    /^PASS_MIN_DAYS/ => "PASS_MIN_DAYS #{node['cis_benchmark']['login']['min_password_age']}",
    /^PASS_WARN_AGE/ => "PASS_WARN_AGE #{node['cis_benchmark']['login']['pass_warn_age']}",
    /^INACTIVE/      => "INACTIVE #{node['cis_benchmark']['login']['inactive']}",
    /^CREATE_HOME/   => 'CREATE_HOME yes',
    /^FAIL_DELAY/    => 'FAIL_DELAY 4',
    /^PASS_MIN_LEN/  => "PASS_MIN_LEN #{node['cis_benchmark']['login']['pass_min_length']}"
  )
end

cis_benchmark_file_editor '/etc/default/useradd' do
  lines(
    /^INACTIVE/ => 'INACTIVE=0'
  )
end

%w[profile bashrc csh.cshrc].each do |name|
  cis_benchmark_file_editor "/etc/#{name}" do
    lines(
      /umask\s+\d+/ => 'umask 077',
      /^TMOUT/ => 'TMOUT=600'
    )
  end
end

file '/etc/securetty' do
  mode 0o600
  owner 'root'
  group 'root'
  content ''
end

pwq = node.default['cis_benchmark']['login']['pwquality']
cis_benchmark_file_editor '/etc/security/pwquality.conf' do
  lines(/^minlen/ => "minlen = #{pwq['minlen']}",
        /^lcredit/  => "lcredit = #{pwq['lcredit']}",
        /^ucredit/  => "ucredit = #{pwq['ucredit']}",
        /^dcredit/  => "dcredit = #{pwq['dcredit']}",
        /^ocredit/  => "ocredit = #{pwq['ocredit']}",
        /^difok/    => "difok = #{pwq['difok']}",
        /^minclass/ => "minclass = #{pwq['minclass']}")
end
