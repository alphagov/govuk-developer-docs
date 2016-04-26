require_relative './repo'
require_relative './site'

class Section
  def initialize(data, github)
    @data = data
    @github = github
  end

  def as_json
    {
      name: data.fetch('name'),
      entries: (repos + sites).map(&:as_json)
    }
  end

private

  attr_reader :data, :github

  def repos
    data['repos'].to_a.map do |app_name|
      repo = github.repo(app_name)
      Repo.new(repo)
    end
  end

  def sites
    data['sites'].to_a.map do |site_data|
      Site.new(site_data)
    end
  end
end
