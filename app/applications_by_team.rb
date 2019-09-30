class ApplicationsByTeam
  UNKNOWN = "unknown".freeze

  def self.teams
    applications.keys.reject { |team| team == UNKNOWN }
  end

  def self.[](team)
    for_team(team)
  end

  def self.for_team(team)
    applications.fetch(team, []).map(&:app_name)
  end

  def self.no_known_owner
    applications[UNKNOWN].to_a.map(&:app_name)
  end

  def self.applications
    @applications ||=
      YAML.load_file("data/applications.yml")
        .map { |app_data| App.new(app_data) }
        .reject(&:retired?)
        .sort_by(&:app_name)
        .group_by(&:team)
  end

  class App
    attr_reader :app_data

    def initialize(app_data)
      @app_data = app_data
    end

    def retired?
      app_data.fetch("retired", false)
    end

    def app_name
      app_data.fetch("github_repo_name", UNKNOWN)
    end

    def team
      app_data.fetch("team", UNKNOWN)
    end
  end
end
