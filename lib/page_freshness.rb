class PageFreshness
  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def to_json
    { expired_pages: export(expired_pages), expiring_soon: export(expiring_soon) }.to_json
  end

  def expired_pages
    sitemap.resources.select do |page|
      page.data.review_by && Date.today > page.data.review_by
    end
  end

  def expiring_soon
    soon = sitemap.resources.select do |page|
      page.data.review_by && Date.today > (page.data.review_by - 7.days)
    end

    soon - expired_pages
  end

  def export(pages)
    pages.map do |page|
      {
        title: page.data.title,
        url: "https://docs.publishing.service.gov.uk#{page.url}",
        review_by: page.data.review_by,
        owner_slack: page.data.owner_slack,
      }
    end
  end
end
