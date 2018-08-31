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
      PageReview.new(page).expired?
    end
  end

  def all_pages
    sitemap.resources.map { |page| PageReview.new(page) }.select(&:reviewable?)
  end

  def expiring_soon
    soon = sitemap.resources.select do |page|
      PageReview.new(page).expiring_soon?
    end

    soon - expired_pages
  end

  def export(pages)
    pages.map do |page|
      {
        title: [page.data.title, page.data.section].join(' - '),
        url: "https://docs.publishing.service.gov.uk#{page.url}",
        review_by: PageReview.new(page).review_by,
        owner_slack: page.data.owner_slack,
      }
    end
  end
end
