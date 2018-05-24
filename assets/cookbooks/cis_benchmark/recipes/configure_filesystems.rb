require 'find'

Find.find('/') do |entry|
  next if entry == '.' || entry == '..'
  next unless File.directory?(entry)
  stat = File.stat(entry)
  next unless stat.world_writable? && !stat.sticky?
  ruby_block "Apply sticky bit to #{entry}" do
    block do
      FileUtils.chmod('a+t', entry)
    end
    action :run
  end
end
