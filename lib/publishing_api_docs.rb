class PublishingApiDocs
  PAGES = {
    "api" => "API docs",
    "dependency-resolution" => "Dependency resolution",
    "link-expansion" => "Link expansion",
    "model" => "Model",
    "pact_testing" => "Contract testing with Pact",
    "publishing-application-examples" => "Examples",
    "rabbitmq" => "Message queue",
  }.freeze

  def self.pages
    PAGES.map { |k, v| Page.new(k, v) }
  end

  class Page
    attr_reader :filename, :title

    def initialize(filename, title)
      @filename = filename
      @title = title
    end

    def source_url
      "https://github.com/alphagov/publishing-api/blob/master/doc/#{filename}.md"
    end

    def raw_source
      "https://raw.githubusercontent.com/alphagov/publishing-api/master/doc/#{filename}.md"
    end
  end
end
