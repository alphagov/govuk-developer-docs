require 'yaml'
require 'active_support/core_ext/string'

require_relative './github'

class Content
  def as_json
    YAML.load_file("_config/dashboard.yml").map do |chapter|
      Chapter.new(chapter).as_json
    end
  end

private

  class Thing
    attr_reader :data

    def initialize(data)
      @data = data
    end
  end

  class Chapter < Thing
    def as_json
      {
        name: data.fetch('name'),
        id: data.fetch('name').parameterize,
        sections: data['sections'].map { |section| Section.new(section).as_json }
      }
    end
  end

  class Section < Thing
    def as_json
      {
        name: data.fetch('name'),
        id: data.fetch('name').parameterize,
        entries: (repos + sites).map(&:as_json)
      }
    end

  private

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
    def as_json
      {
        name: data.fetch("name"),
        url: data.fetch("url"),
        description: data["description"]
      }
    end
  end

  class Repo < Thing
    def as_json
      {
        name: data.owner.login == "alphagov" ? data.name : data.full_name,
        url: data.html_url,
        description: data.description,
      }
    end
  end
end
