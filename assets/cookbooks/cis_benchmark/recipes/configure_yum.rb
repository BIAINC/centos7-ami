Dir['/etc/yum.repos.d/*'].each do |config|
  cis_benchmark_file_editor config do
    lines(
      /^gpgcheck/ => 'gpgcheck=1'
    )
  end
end

cis_benchmark_file_editor '/etc/yum.conf' do
  lines(
    /^clean_requirements_on_remove/ => 'clean_requirements_on_remove=1',
    /^localpkg_gpgcheck/ => 'localpkg_gpgcheck=1',
    /^gpgcheck/ => 'gpgcheck=1'
  )
end
