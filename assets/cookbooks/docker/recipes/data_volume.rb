filesystem 'docker_data' do
  fstype 'xfs'
  device '/dev/xvdb'
  mount '/var/lib/docker'
  mkfs_options '-n ftype=1'
  options 'defaults,relatime,nofail,pquota,prjquota'
  action %i[create enable mount]
end
