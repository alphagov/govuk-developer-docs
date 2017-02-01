class DocumentTypes
  def self.pages
    @@pages ||= begin
      facet_query.dig("facets", "content_store_document_type", "options").map { |o|
        Page.new(o.dig("value", "slug"), o.dig("documents"))
      }.sort_by(&:name)
    end
  end

  def self.coverage_percentage
    ((pages.sum(&:total_count) / facet_query.fetch("total").to_f) * 100).round(1)
  end

  def self.facet_query
    @@facet_query ||= begin
      json = Faraday.get('https://www.gov.uk/api/search.json?facet_content_store_document_type=200&count=0').body
      JSON.parse(json)
    end
  end

  class Page
    attr_reader :name, :count

    def initialize(name, count)
      @name = name
      @count = count
    end

    def total_count
      count
    end

    def examples
      search.dig("results")
    end

    def search_url
      "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{name}&count=10"
    end

  private

    def search
      @search ||= begin
        json = Faraday.get(search_url).body
        JSON.parse(json)
      end
    end
  end
end
