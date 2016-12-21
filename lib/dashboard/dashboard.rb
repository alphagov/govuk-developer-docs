require 'yaml'
require 'active_support/core_ext/string'

require_relative './github'

# View model for the dashboard.
class Dashboard
  def chapters
    YAML.load_file("data/dashboard.yml").map do |chapter|
      Chapter.new(chapter)
    end
  end

private

  class Thing
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def name
      data.fetch('name')
    end

    def id
      data.fetch('name').parameterize
    end

    def description
      data["description"]
    end
  end

  class Chapter < Thing
    def sections
      data['sections'].map { |section| Section.new(section) }
    end
  end

  class Section < Thing
    def entries
      from_application_page + repos + sites
    end

  private

    # Pull the the applications from applications.yml into the first categories
    def from_application_page
      app_data = YAML.load_file("data/applications.yml")
      applications_in_this_section = app_data.select { |a| a['type'] == name }

      applications_in_this_section.map do |a|
        repo = GitHub.client.repo(a['github_repo_name'])
        App.new("name" => a['github_repo_name'], "description" => repo["description"])
      end
    end

    def repos
      data['repos'].to_a.map do |app_name|
        repo = GitHub.client.repo(app_name)
        Repo.new(repo)
      end
    end

    def sites
      data['sites'].to_a.map do |site_data|
        Site.new(site_data)
      end
    end
  end

  class Site < Thing
    def url
      data.fetch("url")
    end
  end

  class Repo < Thing
    def name
      data.owner.login == "alphagov" ? data.name : data.full_name
    end

    def url
      data.html_url
    end
  end

  class App < Thing
    def url
      "/apps/#{id}.html"
    end
  end
end
