require "git"

module CommitHelpers
  def commit_url(current_page)
    return "https://github.com/alphagov/#{current_page.data.app_name}/commit/#{current_page.data.latest_commit[:sha]}" if current_page.data.latest_commit

    commit_sha = Git.open(".").log.path(source_file(current_page)).first.sha
    "https://github.com/alphagov/govuk-developer-docs/commit/#{commit_sha}"
  end

  def last_updated(current_page)
    timestamp = if current_page.data.latest_commit
                  current_page.data.latest_commit[:timestamp].to_s
                elsif current_page.data.last_reviewed_on
                  current_page.data.last_reviewed_on.strftime("%Y-%m-%d")
                else
                  Git.open(".").log.path(source_file(current_page)).first.date.to_s
                end

    Time.parse(timestamp).strftime("%e %b %Y").strip # e.g. "3 Sep 2020"
  end

private

  def source_file(current_page)
    "source/#{current_page.file_descriptor.relative_path}"
  end
end
