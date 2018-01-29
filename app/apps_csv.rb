require 'csv'

class AppsCSV
  attr_reader :hash

  def initialize(apps)
    @apps = apps
  end

  def to_csv
    CSV.generate do |csv|
      csv << ["Name", "Team", "Docs URL", "Repo URL"]

      @apps.each do |app|
        csv << [
          app.app_name,
          app.team,
          app.html_url,
          app.repo_url,
        ]
      end
    end
  end
end
