require 'faraday-http-cache'
require 'faraday_middleware'

module HTTP
  def self.get_yaml(url)
    YAML.load(get(url))
  end

  def self.get(url)
    uri = URI.parse(url)

    faraday = Faraday.new(url: uri) do |conn|
      conn.response :logger
      conn.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
      conn.use Octokit::Response::RaiseError
      conn.adapter Faraday.default_adapter
      conn.response :json, content_type: /\bjson$/
    end

    response = faraday.get(uri.path)

    response.body
  end
end
