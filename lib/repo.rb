class Repo
  def initialize(repo)
    @repo = repo
  end

  def as_json
    {
      name: repo.owner.login == "alphagov" ? repo.name : repo.full_name,
      url: repo.html_url,
      description: repo.description,
    }
  end

private

  attr_reader :repo
end
