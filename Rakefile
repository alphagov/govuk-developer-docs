require "govuk_tech_docs"
require "rspec/core/rake_task"
require_relative "./app/requires"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop"
task :lint, :environment do
  sh "bundle exec rubocop --format clang"
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
    sh "rm -rf /tmp/govuk-content-schemas; git clone https://github.com/alphagov/govuk-content-schemas.git /tmp/govuk-content-schemas --depth=1 && NO_CONTRACTS=true GOVUK_CONTENT_SCHEMAS_PATH=/tmp/govuk-content-schemas middleman build"
  end
end

desc "Find deployable applications that are not in this repo"
task :verify_deployable_apps do
  common_yaml = suppress_output do
    HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata/common.yaml")
  end
  deployable_applications = common_yaml["deployable_applications"].map { |k, v| v["repository"] || k }
  our_applications = Applications.apps.map(&:github_repo_name)

  intentionally_missing =
    %w[
      backdrop
      spotlight
      stagecraft
      performanceplatform-admin
      performanceplatform-big-screen-view

      EFG

      govuk-cdn-logs-monitor
      govuk-content-schemas
      govuk_crawler_worker
      smokey

      kibana-gds
      sidekiq-monitoring
    ]

  missing_apps = (deployable_applications - (our_applications + intentionally_missing)).uniq
  if missing_apps.count.zero?
    puts "No deployable apps missing from applications.yml ✅"
  else
    errors = missing_apps.map { |missing_app| "\n\t #{missing_app}" }
    abort("The following deployable apps are missing from applications.yml: #{errors.join('')}")
  end
end

desc "Check all puppet names are valid, will error when not"
task :check_puppet_names do
  puts "Checking Puppet manifests..."
  invalid_puppet_names = []
  Applications.apps.reject(&:retired?).each do |app|
    suppress_output { HTTP.get(app.puppet_url) unless app.puppet_url.nil? }
  rescue Octokit::NotFound
    invalid_puppet_names << app.puppet_url
  end
  if invalid_puppet_names.count.zero?
    puts "All AWS/Carrenza apps have a valid puppet manifest ✅"
  else
    errors = invalid_puppet_names.map { |url| "\n\t #{url}" }
    abort("Expected the following puppet manifests to exist: #{errors.join('')}")
  end
end

desc "Clear out and rebuild the build/ folder"
task build: %i[cache:clear assets:precompile]

task default: %i[verify_deployable_apps lint lint_markdown spec check_puppet_names build]

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
