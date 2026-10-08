require "octokit"

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

    CACHE.fetch("alphagov/#{repo_name} docs", expires_in: LOCAL_CACHE_DURATION) do
      recursively_fetch_files(repo_name, "docs")
    rescue Octokit::NotFound
      nil
    end
  end

  # Fetch and parse the rake tasks in the repo's 'lib/tasks' folder
  def rake_tasks(repo_name)
    return nil if repo(repo_name).private_repo? || repo(repo_name).archived?

    CACHE.fetch("alphagov/#{repo_name} rake tasks", expires_in: LOCAL_CACHE_DURATION) do
      recursively_list_rake_files(repo_name, "lib/tasks").flat_map do |rake_file|
        rake_tasks_from(rake_file)
      end
    rescue Octokit::NotFound
      nil
    end
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

  def recursively_fetch_files(repo_name, path)
    docs = client.contents("alphagov/#{repo_name}", path:)
    top_level_files = docs.select { |doc| doc.path.end_with?(".md") }.map do |doc|
      data_for_github_doc(doc, repo_name)
    end
    docs.select { |doc| doc.type == "dir" }.each_with_object(top_level_files) do |dir, files|
      files.concat(recursively_fetch_files(repo_name, dir.path))
    end
  end

  def data_for_github_doc(doc, repo_name)
    contents = HTTP.get(doc.download_url)
    docs_path = doc.path.sub("docs/", "").match(/(.+)\..+$/)[1]
    filename = docs_path.split("/")[-1]
    title = ExternalDoc.title(contents) || filename
    {
      path: "/repos/#{repo_name}/#{docs_path}.html",
      title: title.to_s.force_encoding("UTF-8"),
      markdown: contents.to_s.force_encoding("UTF-8"),
      relative_path: doc.path,
      source_url: doc.html_url,
      latest_commit: latest_commit(repo_name, doc.path),
    }
  end

  # Works the same way as `recursively_fetch_files`, but collects `.rake`
  # files and leaves turning them into tasks to `rake_tasks_from`.
  def recursively_list_rake_files(repo_name, directory_path)
    directory_entries = client.contents("alphagov/#{repo_name}", path: directory_path)
    rake_files = directory_entries.select { |entry| entry.path.end_with?(".rake") }
    subdirectories = directory_entries.select { |entry| entry.type == "dir" }
    subdirectories.each_with_object(rake_files) do |subdirectory, all_rake_files|
      all_rake_files.concat(recursively_list_rake_files(repo_name, subdirectory.path))
    end
  end

  def rake_tasks_from(rake_file)
    rake_file_source = HTTP.get(rake_file.download_url).to_s.force_encoding("UTF-8")
    RakeTaskParser.parse(rake_file_source).map do |rake_task|
      {
        name: rake_task.name,
        command: rake_task.command,
        description: rake_task.description,
        source_path: rake_file.path,
        source_url: "#{rake_file.html_url}#L#{rake_task.line_number}",
      }
    end
  end

  def client
    @client ||= begin
      stack = Faraday::RackBuilder.new do |builder|
        builder.response :logger, nil, { headers: false }
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
