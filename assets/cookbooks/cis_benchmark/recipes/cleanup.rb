execute 'yum -y clean all'

file '/home/centos/.ssh/authorized_keys' do
  action :delete
end
