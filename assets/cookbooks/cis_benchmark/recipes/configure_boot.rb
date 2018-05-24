file '/boot/grub2/grub.cfg' do
  mode 0o600
  owner 'root'
  group 'root'
end

cookbook_file '/usr/lib/systemd/system/emergency.service' do
  source 'emergency.service'
  mode 0o644
  owner 'root'
  group 'root'
end

cookbook_file '/usr/lib/systemd/system/rescue.service' do
  source 'rescue.service'
  mode 0o644
  owner 'root'
  group 'root'
end
