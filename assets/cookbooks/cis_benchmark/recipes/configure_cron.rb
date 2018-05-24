
%w[crontab].each do |name|
  file "/etc/#{name}" do
    mode 0o644
    owner 'root'
    group 'root'
  end
end

%w[cron.hourly cron.daily cron.weekly cron.monthly cron.d].each do |name|
  directory "/etc/#{name}" do
    mode 0o644
    owner 'root'
    group 'root'
    action :create
  end
end

%w[cron at].each do |name|
  file "/etc/#{name}.deny" do
    action :delete
  end

  template "/etc/#{name}.allow" do
    source 'allow.erb'
    mode 0o600
    owner 'root'
    group 'root'
    variables allowed: node['cis_benchmark']['cron']['allowed']
  end
end
