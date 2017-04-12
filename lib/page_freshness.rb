class PageFreshness
  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def to_json
    { expired_pages: expired_pages, expiring_soon: expiring_soon }.to_json
  end

  def expired_pages
    expired = sitemap.resources.select do |page|
      page.data.review_by && Date.today > page.data.review_by
    end

    expired.map do |page|
      export(page)
    end
  end

  def expiring_soon
    soon = sitemap.resources.select do |page|
      page.data.review_by && Date.today > (page.data.review_by - 7.days)
    end

    pages = soon.map do |page|
      export(page)
    end

    pages - expired_pages
  end

  def export(page)
    {
      title: page.data.title,
      url: "https://docs.publishing.service.gov.uk#{page.url}",
      review_by: page.data.review_by,
      owner_slack: page.data.owner_slack,
    }
  end
end
