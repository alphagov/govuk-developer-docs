require "git"

module CommitHelpers
  def commit_url(current_page)
    if current_page.data.latest_commit
      "https://github.com/alphagov/#{current_page.data.app_name}/commit/#{current_page.data.latest_commit[:sha]}"
    elsif local_commit(current_page)
      "https://github.com/alphagov/govuk-developer-docs/commit/#{local_commit(current_page).sha}"
    else
      "#"
    end
  end

  def last_updated(current_page)
    # e.g. "2020-09-03 09:53:56 UTC"
    if current_page.data.latest_commit
      Time.parse(current_page.data.latest_commit[:timestamp].to_s)
    elsif local_commit(current_page)
      Time.parse(local_commit(current_page).author_date.to_s)
    else
      Time.now
    end
  end

  def format_timestamp(timestamp)
    timestamp.strftime("%e %b %Y").strip # e.g. "3 Sep 2020"
  end

private

  def source_file(current_page)
    "source/#{current_page.file_descriptor.relative_path}"
  end

  def local_commit(current_page)
    Git.open(".").log.path(source_file(current_page)).first
  end
end
