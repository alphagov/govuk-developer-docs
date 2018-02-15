class AppDocs
  def self.pages
    @pages ||= YAML.load_file('data/applications.yml').map do |app_data|
      App.new(app_data)
    end
  end

  def self.app_data
    @publishing_app_data ||= AppData.new
  end

  def self.topics_on_github
    pages.reject(&:retired?).flat_map(&:topics).sort.uniq
  end

  def self.aws_machines
    @common ||= HTTP.get_yaml('https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata_aws/common.yaml')
    @common["node_class"]
  end

  def self.carrenza_machines
    @common ||= HTTP.get_yaml('https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata/common.yaml')
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
        puppet_name: puppet_name,
        links: {
          self: "https://docs.publishing.service.gov.uk/apps/#{app_name}.json",
          html_url: html_url,
          repo_url: repo_url,
          sentry_url: sentry_url,
        }
      }
    end

    def aws_puppet_class
      AppDocs.aws_machines.each do |puppet_class, keys|
        if keys["apps"].include?(app_name)
          return puppet_class
        end
      end
    end

    def carrenza_machine
      AppDocs.carrenza_machines.each do |puppet_class, keys|
        if keys["apps"].include?(app_name)
          return puppet_class
        end
      end
    end

    def html_url
      "https://docs.publishing.service.gov.uk/apps/#{app_name}.html"
    end

    def retired?
      app_data["retired"]
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

    def repo_url
      app_data["repo_url"] || "https://github.com/alphagov/#{github_repo_name}"
    end

    def sentry_url
      "https://sentry.io/govuk/app-#{app_name}"
    end

    def puppet_url
      "https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/#{puppet_name}.pp"
    end

    def deploy_url
      "https://github.com/alphagov/govuk-app-deployment/blob/master/#{github_repo_name}/config/deploy.rb"
    end

    def dashboard_url
      "https://grafana.publishing.service.gov.uk/dashboard/file/deployment_#{puppet_name}.json"
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

    def type
      app_data.fetch("type")
    end

    def team
      app_data["team"]
    end

    def description
      app_data["description"] || description_from_github
    end

    def production_url
      app_data["production_url"] || (type.in?(["Publishing app", "Admin app"]) ? "https://#{app_name}.publishing.service.gov.uk" : nil)
    end

    def topics
      github_repo_data["topics"]
    end

  private

    def puppet_name
      app_data["puppet_name"] || app_name.underscore
    end

    def description_from_github
      github_repo_data["description"]
    end

    def github_repo_data
      @github_repo_data ||= GitHubRepoFetcher.client.repo(github_repo_name)
    end
  end
end
