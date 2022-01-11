class Repos
  UNKNOWN = "unknown".freeze

  def self.all
    @all ||=
      YAML.load_file("data/repos.yml")
        .map { |app_data| App.new(app_data) }
        .sort_by(&:app_name)
  end

  def self.public
    Repos.all.reject(&:private_repo?)
  end

  def self.active_apps
    Repos.all.reject(&:retired?).reject { |app| app.production_hosted_on.nil? }
  end

  def self.grouped_by_team
    Repos.active_apps.reject(&:private_repo?).group_by(&:team)
  end

  def self.teams
    Repos.grouped_by_team.keys.reject { |team| team == UNKNOWN }
  end

  def self.for_team(team)
    Repos.grouped_by_team.fetch(team, []).map(&:app_name)
  end

  def self.no_known_owner
    Repos.for_team(UNKNOWN)
  end
end
