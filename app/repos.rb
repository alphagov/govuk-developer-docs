class Repos
  UNKNOWN = "unknown".freeze

  def self.all
    @all ||=
      YAML.load_file("data/repos.yml", aliases: true)
        .map { |repo_data| Repo.new(repo_data) }
        .sort_by(&:repo_name)
  end

  def self.public
    Repos.all.reject(&:private_repo?)
  end

  def self.active
    Repos.all.reject(&:retired?)
  end

  def self.active_apps
    Repos.active.select(&:is_app?)
  end
end
