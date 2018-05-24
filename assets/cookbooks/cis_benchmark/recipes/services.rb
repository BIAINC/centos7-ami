

node['cis_benchmark']['services']['disabled'].each do |_type, services|
  services.each do |name|
    service name do
      action %i[stop disable]
      only_if "systemctl is-enabled #{name}"
    end
  end
end
node['cis_benchmark']['services']['enabled'].each do |_type, services|
  services.each do |name|
    service name do
      action [:enable]
      not_if 'systemctl is-enabled #{name}'
    end
  end
end
