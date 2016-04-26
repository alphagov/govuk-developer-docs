require 'json'

desc "Regenerate the static data for the site"
task :build_data do
  require_relative './lib/content'
  content = Content.new.as_json
  File.open('_data/content.json', 'w') do |f|
    f.write(JSON.dump(content))
  end
end
