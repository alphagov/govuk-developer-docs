class Applications
  UNKNOWN = "unknown".freeze

  def self.all
    @all ||=
      YAML.load_file("data/applications.yml")
        .map { |app_data| App.new(app_data) }
        .sort_by(&:app_name)
  end

  def self.public
    Applications.all.reject(&:private_repo?)
  end

  def self.active
    Applications.all.reject(&:retired?)
  end

  def self.grouped_by_team
    Applications.active.reject(&:private_repo?).group_by(&:team)
  end

  def self.teams
    Applications.grouped_by_team.keys.reject { |team| team == UNKNOWN }
  end

  def self.for_team(team)
    Applications.grouped_by_team.fetch(team, []).map(&:app_name)
  end

  def self.no_known_owner
    Applications.grouped_by_team[UNKNOWN].to_a.map(&:app_name)
  end
end
