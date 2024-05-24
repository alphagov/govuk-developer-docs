require "faraday-http-cache"
require "faraday_middleware"

module HTTP
  def self.get_yaml(url)
    YAML.load(get(url), aliases: true)
  end

  def self.get(url)
    CACHE.fetch url, expires_in: 1.hour do
      get_without_cache(url)
    end
  end

  def self.get_without_cache(url)
    uri = URI.parse(url)

    headers = { "User-Agent" => "https://github.com/alphagov/govuk-developer-docs" }

    faraday = Faraday.new(url: uri, headers:) do |conn|
      conn.response :logger, nil, { headers: false }
      conn.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
      conn.use Octokit::Response::RaiseError
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end

    response = faraday.get(uri.path)

    response.body
  end
end
