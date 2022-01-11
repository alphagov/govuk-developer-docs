class Hosts
  HOSTERS = {
    "aws" => "AWS",
    "paas" => "GOV.UK PaaS",
    "heroku" => "Heroku",
  }.freeze

  def self.hosters_descending(applications)
    ordered_keys = HOSTERS.keys.sort do |a, b|
      [on_host(applications, b).count, a] <=> [on_host(applications, a).count, b]
    end
    ordered_keys.map { |key| [key, { label: HOSTERS[key], apps: on_host(applications, key) }] }.to_h
  end

  def self.on_host(applications, host)
    applications.select { |app| app.production_hosted_on == host }
  end

  def self.aws_machines
    @common_aws ||= HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata_aws/common.yaml")
    @common_aws["node_class"]
  end
end
