require "govuk_tech_docs"
require "rspec/core/rake_task"
require_relative "./app/requires"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop"
task :lint, :environment do
  sh "bundle exec rubocop"
end

desc "Run Markdownlint"
task :lint_markdown, :environment do
  sh "bundle exec mdl --ignore-front-matter --show-aliases source"
end

namespace :cache do
  desc "Clear the cache of external content"
  task :clear do
    CACHE.clear
  end
end

namespace :assets do
  desc "Build the static site"
  task :precompile do
    sh "rm -rf /tmp/govuk-content-schemas; git clone https://github.com/alphagov/publishing-api.git /tmp/govuk-content-schemas --depth=1 && NO_CONTRACTS=true GOVUK_CONTENT_SCHEMAS_PATH=/tmp/govuk-content-schemas/content_schemas middleman build"
  end
end

desc "Clear out and rebuild the build/ folder"
task build: %i[cache:clear assets:precompile]

task default: %i[lint lint_markdown spec build]

# https://gist.github.com/moertel/11091573
def suppress_output
  original_stderr = $stderr.clone
  original_stdout = $stdout.clone
  $stderr.reopen(File.new("/dev/null", "w"))
  $stdout.reopen(File.new("/dev/null", "w"))
  yield
ensure
  $stdout.reopen(original_stdout)
  $stderr.reopen(original_stderr)
end
