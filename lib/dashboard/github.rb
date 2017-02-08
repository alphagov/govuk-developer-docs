require 'octokit'

class GitHub
  # Fetch a repo from GitHub.
  #
  # If the app_name is just a repo name we'll assume that it's in the alphagov
  # org. Because 99% of the repos will be from that org, we can download and
  # cache all alphagov-repos and save on API calls.
  def repo(app_name)
    if app_name.match("/")
      # Not on alpghagov, make a separate call to the API. Cache it for
      # development speed.
      @@cache ||= {}
      @@cache[app_name] ||= client.repo(app_name)
    else
      all_alphagov_repos.find { |repo| repo.name == app_name } || raise("alphagov/#{app_name} not found")
    end
  end

  def self.client
    @client ||= GitHub.new
  end

private

  def all_alphagov_repos
    @@all_alphagov_repos ||= client.repos("alphagov")
  end

  def client
    @_github_client ||= begin
      stack = Faraday::RackBuilder.new do |builder|
        builder.response :logger
        builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end

      Octokit.middleware = stack

      github_client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
      github_client.auto_paginate = true
      github_client
    end
  end
end
