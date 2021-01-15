# View model for the dashboard.
class Dashboard
  def chapters
    YAML.load_file("data/dashboard.yml").map do |chapter|
      Chapter.new(chapter)
    end
  end

  class Thing
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def name
      data.fetch("name")
    end

    def id
      data.fetch("name").parameterize
    end

    def description
      data["description"]
    end
  end

  class Chapter < Thing
    def sections
      data["sections"].map { |section| Section.new(section) }
    end
  end

  class Section < Thing
    def entries
      from_application_page + repos + sites
    end

  private

    # Pull the the applications from applications.yml into the first categories
    def from_application_page
      applications_in_this_section = Applications.all.reject(&:retired?).select do |app|
        app.type == name
      end

      applications_in_this_section.map do |app|
        App.new("name" => app.app_name, "description" => app.description)
      end
    end

    def repos
      data["repos"].to_a.map do |app_name|
        repo = GitHubRepoFetcher.instance.repo(app_name)
        Repo.new(repo)
      end
    end

    def sites
      data["sites"].to_a.map do |site_data|
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
