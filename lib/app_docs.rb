class AppDocs
  def self.pages
    YAML.load_file('data/applications.yml').map do |app_data|
      App.new(app_data)
    end
  end

  class App
    attr_reader :app_data

    def initialize(app_data)
      @app_data = app_data
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

    def github_repo_name
      app_data.fetch("github_repo_name")
    end

    def repo_url
      app_data["repo_url"] || "https://github.com/alphagov/#{github_repo_name}"
    end

    def puppet_url
      "https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/#{puppet_name}.pp"
    end

    def deploy_url
      "https://github.com/alphagov/govuk-app-deployment/blob/master/#{github_repo_name}/config/deploy.rb"
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

  private

    def puppet_name
      app_data["puppet_name"] || app_name.underscore
    end

    def description_from_github
      repo = GitHub.client.repo(github_repo_name)
      repo["description"]
    end
  end
end
