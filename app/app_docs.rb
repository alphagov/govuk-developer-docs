class AppDocs
  def self.new_by_type(app_data)
    klass = case app_data["type"]
            when "data.gov.uk apps"
              DataGovUkApp
            when "Licensing apps"
              LicensingApp
            else
              App
            end
    klass.new(app_data)
  end

  def self.pages
    @pages ||= YAML.load_file('data/applications.yml').map do |app_data|
      new_by_type(app_data)
    end
  end

  def self.app_data
    @publishing_app_data ||= AppData.new
  end

  def self.topics_on_github
    pages.reject(&:retired?).reject(&:private_repo?).flat_map(&:topics).sort.uniq
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
      'Unknown - have you configured and merged your app in govuk-puppet/hieradata_aws/common.yaml'
    end

    def carrenza_machine
      AppDocs.carrenza_machines.each do |puppet_class, keys|
        if keys["apps"].include?(app_name)
          return puppet_class
        end
      end
      'Unknown - have you configured and merged your app in govuk-puppet/hieradata/common.yaml'
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

    def metrics_dashboard_url
      app_data["metrics_dashboard_url"]
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

    def pending_hosting?
      false
    end

    def has_rake_tasks?
      true
    end

    def in_paas?
      false
    end

    def in_aws?
      true
    end

    def in_ukcloud?
      false
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
  end

  class DataGovUkApp < App
    def carrenza_machine
      # noop
    end

    def sentry_url
      return "https://sentry.io/govuk/find-data" if app_name == "datagovuk_find"
      return "https://sentry.io/govuk/publish-data" if app_name == "datagovuk_publish"
      ""
    end

    def puppet_url
      # noop
    end

    def deploy_url
      # noop
    end

    def dashboard_url
      "https://grafana-paas.cloudapps.digital/d/xonj40imk/data-gov-uk?refresh=1m&orgId=1"
    end

    def pending_hosting?
      github_repo_name == "ckanext-datagovuk"
    end

    def has_rake_tasks?
      false
    end

    def in_paas?
      true
    end

    def in_aws?
      false
    end
  end

  class LicensingApp < App
    def carrenza_machine
      # noop
    end

    def sentry_url
      # noop
    end

    def puppet_url
      # noop
    end

    def deploy_url
      # noop
    end

    def dashboard_url
      # noop
    end

    def has_rake_tasks?
      false
    end

    def in_ukcloud?
      true
    end

    def in_aws?
      false
    end
  end
end
