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
    Repos.all.reject(&:retired?).uniq(&:repo_name)
  end

  def self.active_gems
    Repos.all.reject(&:retired?).select(&:is_gem?).uniq(&:repo_name)
  end

  def self.active_public
    Repos.active.reject(&:private_repo?)
  end

  def self.active_apps
    Repos.all.reject(&:retired?).select(&:is_app?)
  end
end
