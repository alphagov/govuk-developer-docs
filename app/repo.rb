class Repo
  attr_reader :repo_data

  def initialize(repo_data)
    @repo_data = repo_data
  end

  def api_payload
    {
      app_name: repo_name, # beware renaming the key - it's used here: https://github.com/alphagov/govuk-dependencies/blob/b3a2a29eb80aefa08098a08633b4a08b05bcc527/lib/gateways/team.rb#L15
      team:,
      dependencies_team:,
      puppet_name:,
      production_hosted_on:,
      links: {
        self: "https://docs.publishing.service.gov.uk/repos/#{repo_name}.json",
        html_url:,
        repo_url:,
        sentry_url:,
      },
    }
  end

  def aws_puppet_class
    Hosts.aws_machines.each do |puppet_class, keys|
      if keys["apps"].include?(repo_name) || keys["apps"].include?(puppet_name)
        return puppet_class
      end
    end
    "Unknown - have you configured and merged your app in govuk-puppet/hieradata_aws/common.yaml"
  end

  def production_hosted_on_eks?
    production_hosted_on == "eks"
  end

  def production_hosted_on_aws?
    production_hosted_on == "aws"
  end

  def machine_class
    repo_data["machine_class"] || aws_puppet_class
  end

  def production_hosted_on
    repo_data["production_hosted_on"]
  end

  def is_app?
    !production_hosted_on.nil?
  end

  def hosting_name
    Hosts::HOSTERS.fetch(production_hosted_on)
  end

  def html_url
    "https://docs.publishing.service.gov.uk/repos/#{repo_name}.html"
  end

  def retired?
    repo_data["retired"]
  end

  def private_repo?
    repo_data["private_repo"]
  end

  def page_title
    type = is_app? ? "Application" : "Repository"
    if retired?
      "#{type}: #{repo_name} (retired)"
    else
      "#{type}: #{repo_name}"
    end
  end

  def repo_name
    repo_data.fetch("repo_name")
  end

  def example_published_pages
    RepoData.publishing_examples[repo_name]
  end

  def example_rendered_pages
    RepoData.rendering_examples[repo_name]
  end

  def management_url
    repo_data["management_url"]
  end

  def repo_url
    repo_data["repo_url"] || "https://github.com/alphagov/#{repo_name}"
  end

  def sentry_url
    if repo_data["sentry_url"] == false
      nil
    elsif repo_data["sentry_url"]
      repo_data["sentry_url"]
    else
      "https://sentry.io/govuk/app-#{repo_name}"
    end
  end

  def argo_cd_urls
    return [] unless production_hosted_on_eks?

    argo_cd_apps.each_with_object({}) do |app_name, hash|
      hash[app_name] = "https://argo.eks.production.govuk.digital/applications/cluster-services/#{app_name}"
    end
  end

  def puppet_url
    return unless production_hosted_on_aws?

    return repo_data["puppet_url"] if repo_data["puppet_url"]

    "https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/#{puppet_name}.pp"
  end

  def deploy_url
    return if repo_data["deploy_url"] == false || [nil, "none", "heroku", "eks"].include?(production_hosted_on)

    if production_hosted_on == "paas"
      repo_data["deploy_url"]
    else
      "https://github.com/alphagov/govuk-app-deployment/blob/master/#{repo_name}/config/deploy.rb"
    end
  end

  def dashboard_url
    return if repo_data["dashboard_url"] == false

    default_url = if production_hosted_on_eks?
                    query_string = argo_cd_apps.map { |app| "var-app=#{app}" }.join("&")
                    "https://grafana.eks.production.govuk.digital/d/000000111?#{query_string}"
                  else
                    "https://grafana.production.govuk.digital/dashboard/file/#{repo_name}.json"
                  end
    repo_data["dashboard_url"] || default_url
  end

  def api_docs_url
    repo_data["api_docs_url"]
  end

  def component_guide_url
    repo_data["component_guide_url"]
  end

  def metrics_dashboard_url
    repo_data["metrics_dashboard_url"]
  end

  def type
    repo_data.fetch("type")
  end

  def team
    repo_data["team"] || Repos::UNKNOWN
  end

  def dependencies_team
    repo_data
      .fetch("dependencies_team", team)
  end

  def description
    repo_data["description"] || description_from_github
  end

  def production_url
    return if repo_data["production_url"] == false

    repo_data["production_url"] || (type.in?(["Publishing apps", "Supporting apps"]) ? "https://#{repo_name}.publishing.service.gov.uk" : nil)
  end

  def readme
    github_readme
  end

  def can_run_rake_tasks_in_jenkins?
    production_hosted_on_aws?
  end

  def rake_task_url(environment, rake_task = "")
    return unless production_hosted_on_aws?

    query_params = "?TARGET_APPLICATION=#{repo_name}&MACHINE_CLASS=#{machine_class}&RAKE_TASK=#{rake_task}"

    if environment == "integration"
      "https://deploy.#{environment}.publishing.service.gov.uk/job/run-rake-task/parambuild/#{query_params}"
    else
      "https://deploy.blue.#{environment}.govuk.digital/job/run-rake-task/parambuild/#{query_params}"
    end
  end

private

  def argo_cd_apps
    repo_data["argo_cd_apps"] || [repo_name]
  end

  def puppet_name
    repo_data["puppet_name"] || repo_name.underscore
  end

  def description_from_github
    github_repo_data["description"]
  end

  def github_repo_data
    return {} if private_repo?

    @github_repo_data ||= GitHubRepoFetcher.instance.repo(repo_name)
  end

  def github_readme
    return nil if private_repo?

    @github_readme ||= GitHubRepoFetcher.instance.readme(repo_name)
  end
end
