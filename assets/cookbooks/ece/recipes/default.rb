#
# Cookbook:: ece
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

yum_repository 'docker' do
  description 'Docker Repository - $basearch'
  baseurl 'https://yum.dockerproject.org/repo/main/centos/7/'
  gpgkey 'https://yum.dockerproject.org/gpg'
  gpgcheck true
  action :create
end

package 'yum-plugin-versionlock'

%w[yum-utils device-mapper-persistent-data lvm2].each do |p|
  package p
end

package 'docker-engine' do
  version '1.11.2-1.el7.centos'
  action %i[install lock]
end

service 'docker' do
  action [:enable]
end


ece_file_editor '/etc/sysctl.conf' do
  lines('vm.max_map_count' => 'vm.max_map_count=262144',
        'net.ipv4.ip_forward' => 'net.ipv4.ip_forward=1',
        'net.ipv4.tcp_max_syn_backlog' => 'net.ipv4.tcp_max_syn_backlog=65536',
        'net.core.somaxconn' => 'net.core.somaxconn=32768',
        'net.core.netdev_max_backlog' => 'net.core.netdev_max_backlog=32768',
        'fs.may_detach_mounts' => 'fs.may_detach_mounts=1')
end

ece_file_editor '/etc/security/limits.conf' do
  lines(/^elastic\s+soft\s+nofile/ => 'elastic          soft    nofile         1024000',
        /^elastic\s+hard\s+nofile/ => 'elastic          hard    nofile         1024000',
        /^elastic\s+soft\s+memlock/ => 'elastic          soft    memlock        unlimited',
        /^elastic\s+hard\s+memlock/ => 'elastic          hard    memlock        unlimited',
        /^root\s+soft\s+nofile/ => 'root             soft    nofile         1024000',
        /^root\s+hard\s+nofile/ => 'root             hard    nofile         1024000',
        /^root\s+soft\s+memlock/ => 'root             soft    memlock        unlimited')
end

ece_file_editor '/etc/default/grub' do
  lines('GRUB_CMDLINE_LINUX=' => 'GRUB_CMDLINE_LINUX="crashkernel=auto console=ttyS0,115200 console=tty0 net.ifnames=0 biosdevname=0 audit=1 fips=1 nousb cgroup_enable=memory swapaccount=1 cgroup.memory=nokmem"')
end

execute 'grub2-mkconfig -o /etc/grub2.cfg'
execute 'grub2-set-default 0'

group 'elastic'

user 'elastic' do
  group 'elastic'
  manage_home true
end

group 'docker' do
  action :modify
  members %w[elastic]
  append true
end

directory '/etc/systemd/system/docker.service.d' do
  recursive true
  owner 'root'
  group 'root'
end

cookbook_file '/etc/systemd/system/docker.service.d/docker.conf' do
  source 'docker.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service 'docker' do
  action [:enable]
end


