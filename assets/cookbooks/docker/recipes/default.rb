#
# Cookbook:: docker
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

yum_repository 'docker-ce-stable' do
  description 'Docker CE Stable - $basearch'
  baseurl 'https://download.docker.com/linux/centos/7/$basearch/stable'
  gpgkey 'https://download.docker.com/linux/centos/gpg'
  gpgcheck true
  action :create
end

package 'yum-plugin-versionlock'

%w[yum-utils device-mapper-persistent-data lvm2].each do |p|
  package p
end

package 'docker-ce' do
  action %i[install lock]
end

service 'docker' do
  action [:enable]
end
