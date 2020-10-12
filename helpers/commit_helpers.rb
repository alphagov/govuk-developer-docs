module CommitHelpers
  def commit_url(current_page)
    return "https://github.com/alphagov/#{current_page.data.app_name}/commit/#{current_page.data.latest_commit[:sha]}" if current_page.data.latest_commit

    commit_sha = `git log -1 --format=oneline #{source_file(current_page)} | cut -d ' ' -f 1`.strip
    "https://github.com/alphagov/govuk-developer-docs/commit/#{commit_sha}"
  end

  def last_updated(current_page)
    # e.g. "2020-09-03 09:53:56 UTC"
    timestamp = if current_page.data.latest_commit
                  current_page.data.latest_commit[:timestamp].to_s
                else
                  `TZ=UTC git log -1 --date='format-local:%Y-%m-%d %T UTC' --format="%cd" #{source_file(current_page)}`.strip
                end

    Time.parse(timestamp).strftime("%e %b %Y").strip # e.g. "3 Sep 2020"
  end

private

  def source_file(current_page)
    "source/#{current_page.file_descriptor.relative_path}"
  end
end
