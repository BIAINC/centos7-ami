node['cis_benchmark']['package']['remove'].each do |_type, packages|
  packages.each do |name|
    package name do
      action :remove
    end
  end
end

node['cis_benchmark']['package']['install'].each do |_type, packages|
  packages.each do |name|
    package name do
      action :install
    end
  end
end
