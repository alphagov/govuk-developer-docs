require "csv"

class ReposCSV
  attr_reader :hash

  def initialize(repos)
    @repos = repos
  end

  def to_csv
    CSV.generate do |csv|
      csv << ["Name", "Team", "Dependencies Team", "Docs URL", "Repo URL", "Hosted On"]

      @repos.each do |repo|
        csv << [
          repo.repo_name,
          repo.team,
          repo.dependencies_team,
          repo.html_url,
          repo.repo_url,
          repo.production_hosted_on,
        ]
      end
    end
  end
end
