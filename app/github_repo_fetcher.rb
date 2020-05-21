require "octokit"

class GitHubRepoFetcher
  # Fetch a repo from GitHub.
  #
  # If the app_name is just a repo name we'll assume that it's in the alphagov
  # org. Because 99% of the repos will be from that org, we can download and
  # cache all alphagov-repos and save on API calls.
  def repo(app_name)
    if app_name =~ %r{/}
      # Not on alphagov, make a separate call to the API. Cache it for
      # development speed.
      @@cache ||= {}
      @@cache[app_name] ||= client.repo(app_name)
    else
      all_alphagov_repos.find { |repo| repo.name == app_name } || raise("alphagov/#{app_name} not found")
    end
  end

  # Fetch a README for an alphagov application and cache it.
  # Note that it is cached as pure markdown and requires further processing.
  def readme(app_name)
    CACHE.fetch("alphagov/#{app_name} README", expires_in: 1.hour) do
      Base64.decode64(client.readme("alphagov/#{app_name}").content)
    rescue Octokit::NotFound
      nil
    end
  end

  def self.client
    @client ||= GitHubRepoFetcher.new
  end

private

  def all_alphagov_repos
    @@all_alphagov_repos ||= CACHE.fetch("all-repos", expires_in: 1.hour) do
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
