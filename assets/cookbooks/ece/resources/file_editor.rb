property :name, String, name_property: true
property :lines, Hash

default_action :update

action :update do
  @editor = ECE::FileEditor.new(new_resource.name)
  new_resource.lines.each do |regex, line|
    @editor.replace_or_append(regex, line)
  end
  @editor.save if @editor.dirty?
  new_resource.updated_by_last_action(@editor.changed?)
end
