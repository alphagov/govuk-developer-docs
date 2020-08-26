require "octokit"

class GitHubRepoFetcher
  include Singleton

  # Fetch a repo from GitHub
  def repo(app_name)
    all_alphagov_repos.find { |repo| repo.name == app_name } || raise("alphagov/#{app_name} not found")
  end

  # Fetch a README for an alphagov application and cache it.
  # Note that it is cached as pure markdown and requires further processing.
  def readme(app_name)
    CACHE.fetch("alphagov/#{app_name} README", expires_in: 1.hour) do
      default_branch = repo(app_name).default_branch
      HTTP.get("https://raw.githubusercontent.com/alphagov/#{app_name}/#{default_branch}/README.md")
    rescue Octokit::NotFound
      nil
    end
  end

  # Fetch all markdown files under the repo's 'docs' folder
  def docs(app_name)
    CACHE.fetch("alphagov/#{app_name} docs", expires_in: 1.hour) do
      docs = client.contents("alphagov/#{app_name}", path: "docs")
      docs.select { |doc| doc.name.end_with?(".md") }.map do |doc|
        contents = HTTP.get(doc.download_url)
        filename = doc.name.match(/(.+)\..+$/)[1]
        title = ExternalDoc.title(contents) || filename
        {
          path: "/apis/#{app_name}/#{filename}.html",
          title: title,
          markdown: contents,
          source_url: doc.html_url,
        }
      end
    rescue Octokit::NotFound
      nil
    end
  end

private

  def all_alphagov_repos
    @all_alphagov_repos ||= CACHE.fetch("all-repos", expires_in: 1.hour) do
      client.repos("alphagov")
    end
  end

  def client
    @client ||= begin
      stack = Faraday::RackBuilder.new do |builder|
        builder.response :logger
        builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
        builder.use Octokit::Response::RaiseError
        builder.use Faraday::Request::Retry, exceptions: Faraday::Request::Retry::DEFAULT_EXCEPTIONS + [Octokit::ServerError]
        builder.adapter Faraday.default_adapter
      end

      Octokit.middleware = stack
      Octokit.default_media_type = "application/vnd.github.mercy-preview+json"

      github_client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
      github_client.auto_paginate = true
      github_client
    end
  end
end
