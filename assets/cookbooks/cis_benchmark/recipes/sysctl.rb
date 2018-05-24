enabled_values = Hash[
  node['cis_benchmark']['sysctl']['enabled'].flat_map do |_type, list|
    list.map do |item|
      [/^#{item}/, "#{item}=1"]
    end
  end
]

disabled_values = Hash[
  node['cis_benchmark']['sysctl']['disabled'].flat_map do |_type, list|
    list.map do |item|
      [/^#{item}/, "#{item}=0"]
    end
  end
]

custom_values = Hash[
  node['cis_benchmark']['sysctl']['custom'].collect do |key, value|
    [/^#{key}/, "#{key}=#{value}"]
  end
]

merged_values = enabled_values.merge(disabled_values).merge(custom_values)

cis_benchmark_file_editor '/etc/sysctl.conf' do
  lines merged_values
end
