
file '/etc/modprobe.d/99_disabled.conf' do
  owner 'root'
  group 'root'
  mode 0o644
  content(
    node['cis_benchmark']['disabled_modules'].collect do |_type, modules|
      modules.collect do |mod|
        "install #{mod} /bin/true"
      end
    end.flatten.sort.join("\n")
  )
end
