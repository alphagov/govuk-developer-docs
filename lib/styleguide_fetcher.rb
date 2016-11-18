require 'octokit'

class StyleGuideFetcher
  def fetch_guides
    client.repo("alphagov/styleguides").rels[:contents].get.data.each do |file|
      next if file['name'] == "README.md"
      markdown = HTTP.get(file[:download_url]).body.to_s

      frontmatter = Utils.frontmatter(
        layout: 'guide',
        source_url: file[:html_url],
        edit_url: file[:html_url].sub('blob', 'edit'),
        title: markdown.lines.first.gsub('#', '').strip,
      )

      # remove the own title of the page
      markdown = markdown.lines[2..-1].join.strip

      File.write("_styleguides/#{file['name']}", "#{frontmatter}\n#{Utils::DO_NOT_EDIT}\n\n#{markdown}")
    end
  end

  def client
    @_github_client ||= begin
      github_client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
      github_client.login
      github_client.auto_paginate = true
      github_client
    end
  end
end
