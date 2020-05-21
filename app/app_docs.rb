class AppDocs
  HOSTERS = {
    "aws" => "AWS",
    "paas" => "GOV.UK PaaS",
    "carrenza" => "Carrenza",
    "ukcloud" => "UK Cloud",
    "heroku" => "Heroku",
    "none" => "None",
  }.freeze

  def self.pages
    @pages ||= YAML.load_file("data/applications.yml").map do |app_data|
      App.new(app_data)
    end
  end

  def self.hosters_descending
    ordered_keys = HOSTERS.keys.sort do |a, b|
      [apps_on_host(b).count, a] <=> [apps_on_host(a).count, b]
    end
    ordered_keys.map { |key| [key, HOSTERS[key]] }.to_h
  end

  def self.apps_on_host(host)
    AppDocs.pages
      .select { |app| app.production_hosted_on == host }
      .sort_by(&:app_name)
  end

  def self.app_data
    @app_data ||= AppData.new
  end

  def self.aws_machines
    @common_aws ||= HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata_aws/common.yaml")
    @common_aws["node_class"]
  end

  def self.carrenza_machines
    @common ||= HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata/common.yaml")
    @common["node_class"]
  end

  class App
    attr_reader :app_data

    def initialize(app_data)
      @app_data = app_data
    end

    def api_payload
      {
        app_name: app_name,
        team: team,
        dependencies_team: dependencies_team,
        puppet_name: puppet_name,
        production_hosted_on: production_hosted_on,
        links: {
          self: "https://docs.publishing.service.gov.uk/apps/#{app_name}.json",
          html_url: html_url,
          repo_url: repo_url,
          sentry_url: sentry_url,
        },
      }
    end

    def aws_puppet_class
      AppDocs.aws_machines.each do |puppet_class, keys|
        if keys["apps"].include?(app_name) || keys["apps"].include?(puppet_name)
          return puppet_class
        end
      end
      "Unknown - have you configured and merged your app in govuk-puppet/hieradata_aws/common.yaml"
    end

    def carrenza_machine
      AppDocs.carrenza_machines.each do |puppet_class, keys|
        if keys["apps"].include?(app_name) || keys["apps"].include?(puppet_name)
          return puppet_class
        end
      end
      "Unknown - have you configured and merged your app in govuk-puppet/hieradata/common.yaml"
    end

    def production_hosted_on_aws?
      production_hosted_on == "aws"
    end

    def machine_class
      app_data["machine_class"] || (production_hosted_on_aws? ? aws_puppet_class : carrenza_machine)
    end

    def production_hosted_on
      app_data["production_hosted_on"]
    end

    def hosting_name
      AppDocs::HOSTERS.fetch(production_hosted_on)
    end

    def html_url
      "https://docs.publishing.service.gov.uk/apps/#{app_name}.html"
    end

    def retired?
      app_data["retired"]
    end

    def private_repo?
      app_data["private_repo"]
    end

    def page_title
      if retired?
        "Application: #{app_name} (retired)"
      else
        "Application: #{app_name}"
      end
    end

    def app_name
      app_data["app_name"] || github_repo_name
    end

    def example_published_pages
      AppDocs.app_data.publishing_examples[app_name]
    end

    def example_rendered_pages
      AppDocs.app_data.rendering_examples[app_name]
    end

    def github_repo_name
      app_data.fetch("github_repo_name")
    end

    def management_url
      app_data["management_url"]
    end

    def repo_url
      app_data["repo_url"] || "https://github.com/alphagov/#{github_repo_name}"
    end

    def sentry_url
      if app_data["sentry_url"] == false
        nil
      elsif app_data["sentry_url"]
        app_data["sentry_url"]
      else
        "https://sentry.io/govuk/app-#{app_name}"
      end
    end

    def puppet_url
      return unless production_hosted_on.in?(%w[aws carrenza])

      "https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/#{puppet_name}.pp"
    end

    def deploy_url
      return if app_data["deploy_url"] == false || production_hosted_on == "heroku"

      if production_hosted_on == "paas"
        app_data["deploy_url"]
      else
        "https://github.com/alphagov/govuk-app-deployment/blob/master/#{github_repo_name}/config/deploy.rb"
      end
    end

    def dashboard_url
      return if app_data["dashboard_url"] == false

      app_data["dashboard_url"] || (
        if production_hosted_on_aws?
          "https://grafana.production.govuk.digital/dashboard/file/#{app_name}.json"
        else
          "https://grafana.publishing.service.gov.uk/dashboard/file/#{app_name}.json"
        end
      )
    end

    def publishing_e2e_tests_url
      if ["Frontend apps", "Publishing apps"].include?(type)
        "https://github.com/alphagov/publishing-e2e-tests/search?q=%22#{app_name.underscore}%3A+true%22+path%3A%2Fspec%2F"
      end
    end

    def api_docs_url
      app_data["api_docs_url"]
    end

    def component_guide_url
      app_data["component_guide_url"]
    end

    def metrics_dashboard_url
      app_data["metrics_dashboard_url"]
    end

    def type
      app_data.fetch("type")
    end

    def team
      app_data["team"]
    end

    def dependencies_team
      app_data
        .fetch("dependencies_team", team)
    end

    def description
      app_data["description"] || description_from_github
    end

    def production_url
      app_data["production_url"] || (type.in?(["Publishing app", "Admin app"]) ? "https://#{app_name}.publishing.service.gov.uk" : nil)
    end

    def readme
      github_readme
    end

    def can_run_rake_tasks_in_jenkins?
      production_hosted_on.in?(%w[aws carrenza])
    end

    def rake_task_url(environment, rake_task = "")
      query_params = "?TARGET_APPLICATION=#{app_name}&MACHINE_CLASS=#{machine_class}&RAKE_TASK=#{rake_task}"

      case production_hosted_on
      when "aws"
        if environment == "integration"
          "https://deploy.#{environment}.publishing.service.gov.uk/job/run-rake-task/parambuild/#{query_params}"
        else
          "https://deploy.blue.#{environment}.govuk.digital/job/run-rake-task/parambuild/#{query_params}"
        end
      when "carrenza"
        environment_prefix = environment == "production" ? "" : ".#{environment}"
        "https://deploy#{environment_prefix}.publishing.service.gov.uk/job/run-rake-task/parambuild/#{query_params}"
      end
    end

  private

    def puppet_name
      app_data["puppet_name"] || app_name.underscore
    end

    def description_from_github
      github_repo_data["description"]
    end

    def github_repo_data
      return {} if private_repo?

      @github_repo_data ||= GitHubRepoFetcher.client.repo(github_repo_name)
    end

    def github_readme
      return nil if private_repo?

      @github_readme ||= GitHubRepoFetcher.client.readme(github_repo_name)
    end
  end
end
