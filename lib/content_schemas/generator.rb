require 'erb'
require_relative './content_schema'

module Generator
  def self.generate_markdown_for_all_schemas
    template = File.read('lib/content_schemas/template.erb')
    renderer = ERB.new(template)

    schema_names = Dir.glob("#{ContentSchema::CONTENT_SCHEMA_DIR}/dist/formats/*").map { |directory| File.basename(directory) }

    schema_names.each do |schema_name|
      puts "Generating markdown file for #{schema_name}"
      content_schema = ContentSchema.new(schema_name)
      content = renderer.result(content_schema.get_binding)
      File.open("_content_schemas/#{schema_name}.md", 'w') do |f|
        f.write(content)
      end
    end
  end
end
