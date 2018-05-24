package 'unzip'

remote_file '/tmp/awscli-bundle.zip' do
  source 'https://s3.amazonaws.com/aws-cli/awscli-bundle.zip'
end

directory '/tmp/awscli'

execute 'unzip /tmp/awscli-bundle.zip -d /tmp/awscli'

execute 'python /tmp/awscli/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws' do
  umask '022'
end

file '/usr/local/aws/bin/aws' do
  mode '0755'
end
