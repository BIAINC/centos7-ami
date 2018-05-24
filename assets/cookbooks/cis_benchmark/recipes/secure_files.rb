%w[/etc/shadow /etc/gshadow].each do |name|
  file name do
    owner 'root'
    group 'root'
    mode 0o000
  end
end

%w[/etc/passwd /etc/group].each do |name|
  file name do
    owner 'root'
    group 'root'
    mode 0o644
  end
end

%w[/etc/passwd- /etc/shadow- /etc/group- /etc/gshadow-].each do |name|
  file name do
    owner 'root'
    group 'root'
    mode 0o600
  end
end
