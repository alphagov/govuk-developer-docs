class Hosts
  HOSTERS = {
    "eks" => "AWS (EKS)",
    "aws" => "AWS (EC2)",
    "heroku" => "Heroku",
  }.freeze

  def self.aws_machines
    @common_aws ||= HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk-puppet/master/hieradata_aws/common.yaml")
    @common_aws["node_class"]
  end
end
