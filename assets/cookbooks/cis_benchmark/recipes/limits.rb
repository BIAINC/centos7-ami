cis_benchmark_file_editor '/etc/security/limits.conf' do
  lines(/^\*\s+hard\s+core\s+0/ => '*     hard   core    0')
end
