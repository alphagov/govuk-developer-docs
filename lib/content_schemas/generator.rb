require 'erb'
require_relative './content_schema'

module Generator
  def self.generate_markdown_for_all_schemas
    template = File.read('lib/content_schemas/template.erb')
    renderer = ERB.new(template)

    formats = Dir.glob("#{ContentSchema::CONTENT_SCHEMA_DIR}/dist/formats/*").map { |directory| File.basename(directory) }

    formats.each do |format|
      content_schema = ContentSchema.new(format)
      content = renderer.result(content_schema.get_binding)
      File.open("_content_schemas/#{format}.md", 'w') do |f|
        f.write(content)
      end
    end
  end
end
