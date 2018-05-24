class FileEditor
  def initialize(file)
    @editor = Chef::Util::FileEdit.new(file)
  end

  def replace_or_append(regex, line)
    @editor.search_file_replace_line(regex, line.to_s)
    @editor.insert_line_if_no_match(regex, line.to_s)
  end

  def save
    @editor.write_file
  end

  def changed?
    @editor.file_edited?
  end

  def dirty?
    @editor.unwritten_changes?
  end
end
