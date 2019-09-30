class PublishingApiDocs
  PAGES = {
    "api" => "API docs",
    "dependency-resolution" => "Dependency resolution",
    "link-expansion" => "Link expansion",
    "model" => "Model",
    "pact_testing" => "Contract testing with Pact",
    "publishing-application-examples" => "Examples",
    "rabbitmq" => "Message queue",
    "admin-tasks" => "Admin tasks",
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

    def path
      "/doc/#{filename}.md"
    end

    def repository
      "alphagov/publishing-api"
    end
  end
end
