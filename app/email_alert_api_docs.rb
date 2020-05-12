class EmailAlertApiDocs
  PAGES = {
    "analytics" => "Analytics",
    "api" => "Available endpoints",
    "fields" => "Field Reference",
    "matching-content-to-subscriber-lists" => "Matching content to subscriber lists",
    "tasks" => "Tasks",
    "transition-from-govdelivery-to-notify" => "Transition from Govdelivery to Notify",
    "troubleshooting" => "Troubleshooting",
  }.freeze

  def self.pages
    PAGES.map { |filename, title| Page.new(filename, title) }
  end

  class Page
    attr_reader :filename, :title

    def initialize(filename, title)
      @filename = filename
      @title = title
    end

    def path
      "doc/#{filename}.md"
    end

    def repository
      "alphagov/email-alert-api"
    end
  end
end
