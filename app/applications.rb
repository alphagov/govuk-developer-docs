class Applications
  HOSTERS = {
    "aws" => "AWS",
    "paas" => "GOV.UK PaaS",
    "heroku" => "Heroku",
  }.freeze

  def self.all
    @all ||= begin
      apps = Dir["data/repos/*.yml"].map do |filepath|
        YAML.load_file(filepath)["repos"].map { |app_data| App.new(app_data) }
      end
      apps.flatten
    end
  end

  def self.public
    Applications.all.reject(&:private_repo?)
  end

  def self.active
    Applications.all.reject(&:retired?).sort_by(&:app_name)
  end

  def self.hosters_descending
    ordered_keys = HOSTERS.keys.sort do |a, b|
      [on_host(b).count, a] <=> [on_host(a).count, b]
    end
    ordered_keys.map { |key| [key, HOSTERS[key]] }.to_h
  end

  def self.on_host(host)
    Applications.all
      .select { |app| app.production_hosted_on == host }
      .sort_by(&:app_name)
  end

  def self.app_data
    @app_data ||= AppData.new
  end

  def self.aws_machines
    @common_aws ||= HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata_aws/common.yaml")
    @common_aws["node_class"]
  end
end
