require "octokit"
require "open3"

class GitHubRepoFetcher
  # The cache is only used locally, as GitHub Pages rebuilds the site
  # with an empty cache every hour and when new commits are merged.
  #
  # Setting a high cache duration below hastens local development, as
  # you don't have to keep pulling down lots of content from GitHub.
  # If you want to work with the very latest data, run `rm -r .cache`
  # before starting the server.
  #
  # TODO: we should supply a command line option to automate the
  # cache clearing step above.
  LOCAL_CACHE_DURATION = 1.week
  REPO_DIR = "#{Bundler.root}/repo-docs/".freeze

  def self.instance
    @instance ||= new
  end

  # Fetch a repo from GitHub
  def repo(repo_name)
    all_alphagov_repos.find { |repo| repo.name == repo_name } || raise("alphagov/#{repo_name} not found")
  end

  # Fetch a README for an alphagov application and cache it.
  # Note that it is cached as pure markdown and requires further processing.
  def readme(repo_name)
    return nil if repo(repo_name).private_repo?

    CACHE.fetch("alphagov/#{repo_name} README", expires_in: LOCAL_CACHE_DURATION) do
      default_branch = repo(repo_name).default_branch
      HTTP.get("https://raw.githubusercontent.com/alphagov/#{repo_name}/#{default_branch}/README.md")
    rescue Octokit::NotFound
      nil
    end
  end

  # Fetch all markdown files under the repo's 'docs' folder
  def docs(repo_name)
    return nil if repo(repo_name).private_repo?

    repo_root = File.join(REPO_DIR, repo_name)

    unless File.exist?(repo_root)
      puts "Cloning #{repo_name} docs"
      git_commands = [
        ["git", "clone", "-n", "--depth=1", "--filter=tree:0", "https://github.com/alphagov/#{repo_name}", repo_root],
        ["git", "sparse-checkout", "set", "--no-cone", "docs", { chdir: repo_root }],
        ["git", "checkout", { chdir: repo_root }],
      ]
      git_commands.each do |command|
        _stdout_str, stderr_str, status = Open3.capture3(*command)
        raise "Repo docs clone failed with error: #{stderr_str}" unless status.success?
      end
    end

    return nil unless File.exist?("#{REPO_DIR}#{repo_name}/docs")

    recursively_fetch_files(repo_name, %w[docs])
  end

private

  def all_alphagov_repos
    @all_alphagov_repos ||= CACHE.fetch("all-repos", expires_in: LOCAL_CACHE_DURATION) do
      client.repos("alphagov")
    end
  end

  def latest_commit(repo_name, path)
    latest_commit = client.commits("alphagov/#{repo_name}", repo(repo_name).default_branch, path:).first
    {
      sha: latest_commit.sha,
      timestamp: latest_commit.commit.author.date,
    }
  end

  def recursively_fetch_files(repo_name, path_stack)
    repo_dir = Dir["#{REPO_DIR}#{repo_name}/#{path_stack.join('/')}/*"]
    top_level_files = repo_dir.select { |file_path| File.file?(file_path) && file_path.end_with?(".md") }.map do |doc_path|
      data_for_github_doc(doc_path, repo_name)
    end
    repo_dir.select { |file_path| File.directory?(file_path) }.each_with_object(top_level_files) do |dir, files|
      files.concat(recursively_fetch_files(repo_name, path_stack << File.basename(dir)))
    end
  end

  def data_for_github_doc(doc_path, repo_name)
    contents = File.read(doc_path)

    path = Pathname.new(doc_path)
    docs_path_with_extension = path.each_filename.to_a.drop_while { |f| f != "docs" }.drop(1).join("/")
    docs_path_without_extension = docs_path_with_extension.chomp(".md")
    relative = path.each_filename.to_a.drop_while { |f| f != "docs" }.join("/")

    basename_without_extension = File.basename(doc_path, ".md")
    title = ExternalDoc.title(contents) || basename_without_extension

    url = "https://github.com/alphagov/#{repo_name}/blob/main/#{relative}"
    {
      path: "/repos/#{repo_name}/#{docs_path_without_extension}.html",
      title: title.to_s.force_encoding("UTF-8"),
      markdown: contents.to_s.force_encoding("UTF-8"),
      relative_path: relative,
      source_url: url,
      latest_commit: latest_commit(repo_name, relative),
    }
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
