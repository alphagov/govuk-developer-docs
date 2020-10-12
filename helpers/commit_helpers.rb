module CommitHelpers
  def commit_url(current_page)
    commit_sha = `git log -1 --format=oneline #{source_file(current_page)} | cut -d ' ' -f 1`.strip
    "https://github.com/alphagov/govuk-developer-docs/commit/#{commit_sha}"
  end

  def last_updated(current_page)
    `TZ=UTC git log -1 --date='format-local:%Y-%m-%d %T UTC' --format="%cd" #{source_file(current_page)}`.strip
  end

private

  def source_file(current_page)
    "source/#{current_page.file_descriptor.relative_path}"
  end
end
