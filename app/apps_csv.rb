require "csv"

class AppsCSV
  attr_reader :hash

  def initialize(apps)
    @apps = apps
  end

  def to_csv
    CSV.generate do |csv|
      csv << ["Name", "Team", "Dependencies Team", "Docs URL", "Repo URL", "Hosted On"]

      @apps.each do |app|
        csv << [
          app.app_name,
          app.team,
          app.dependencies_team,
          app.html_url,
          app.repo_url,
          app.production_hosted_on,
        ]
      end
    end
  end
end
