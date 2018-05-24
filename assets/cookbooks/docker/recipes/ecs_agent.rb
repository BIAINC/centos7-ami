

%w[/var/log/ecs /etc/ecs /var/lib/ecs/data].each do |d|
  directory d do
    recursive true
  end
end

file '/etc/ecs/ecs.config' do
  action :touch
end

systemd_unit 'ecs_agent.service' do
  content <<-EOU.gsub(/^\s+/, '')
    [Unit]
    Description=AWS ECS Agent
    After=docker.target

    [Service]
    Restart=on-failure
    ExecStartPre=/usr/sbin/sysctl -w net.ipv4.conf.all.route_localnet=1
    ExecStartPre=/usr/sbin/iptables -t nat -A PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679
    ExecStartPre=/usr/sbin/iptables -t nat -A OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679
    ExecStartPre=-/usr/bin/docker rm ecs-agent
    ExecStart=/usr/bin/docker run --name ecs-agent --volume=/var/run/docker.sock:/var/run/docker.sock --volume=/var/log/ecs:/log --volume=/var/lib/ecs/data:/data --net=host --env-file=/etc/ecs/ecs.config --env=ECS_LOGFILE=/log/ecs-agent.log --env=ECS_DATADIR=/data/ --env=ECS_ENABLE_TASK_IAM_ROLE=true --env=ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true amazon/amazon-ecs-agent:latest
    ExecStopPost=/usr/sbin/iptables -t nat -D PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679
    ExecStopPost=/usr/sbin/iptables -t nat -D OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679
    ExecStopPost=/usr/bin/docker rm ecs-agent

    [Install]
    WantedBy=multi-user.target

    EOU

  action %i[create enable]
end
