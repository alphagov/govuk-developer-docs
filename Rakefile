require "govuk_tech_docs"
require "rspec/core/rake_task"
require_relative "./app/requires"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop"
task :lint, :environment do
  sh "bundle exec rubocop --format clang"
end

task default: %i[lint spec]

namespace :cache do
  desc "Clear the cache of external content"
  task :clear do
    CACHE.clear
  end
end

namespace :assets do
  desc "Build the static site"
  task :precompile do
    sh "git clone https://github.com/alphagov/govuk-content-schemas.git /tmp/govuk-content-schemas --depth=1 && NO_CONTRACTS=true GOVUK_CONTENT_SCHEMAS_PATH=/tmp/govuk-content-schemas middleman build"
  end
end

desc "Find deployable applications that are not in this repo"
task :verify_deployable_apps do
  common_yaml = HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata/common.yaml")
  deployable_applications = common_yaml["deployable_applications"].map { |k, v| v["repository"] || k }
  our_applications = AppDocs.pages.map(&:github_repo_name)

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

  puts "Deployables is not included in applications.yml:"

  (deployable_applications - (our_applications + intentionally_missing)).uniq.each do |missing_app|
    puts missing_app
  end
end

desc "Check all puppet names are valid, will error when not"
task :check_puppet_names do
  AppDocs.pages.reject(&:retired?).each do |app|
    HTTP.get(app.puppet_url)
  end
end
