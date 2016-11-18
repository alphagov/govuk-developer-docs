class Doc
  attr_reader :repo, :path

  def initialize(repo, path)
    @repo, @path = repo, path
  end

  def source_url
    "https://github.com/alphagov/#{repo}/blob/master/#{path}"
  end

  def edit_url
    "https://github.com/alphagov/#{repo}/edit/master/#{path}"
  end

  def fetch
    HTTP.get(raw_url).body.to_s
  end

private

  def raw_url
    "https://raw.githubusercontent.com/alphagov/#{repo}/master/#{path}"
  end
end
