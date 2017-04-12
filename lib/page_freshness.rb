class PageFreshness
  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def expired_pages
    expired = sitemap.resources.select do |page|
      page.data.review_by && Date.today > page.data.review_by
    end

    expired.map do |page|
      { title: page.data.title, url: page.url, expired_at: page.data.review_by }
    end
  end

  def expiring_soon
    soon = sitemap.resources.select do |page|
      page.data.review_by && Date.today > (page.data.review_by - 7.days)
    end

    pages = soon.map do |page|
      { title: page.data.title, url: page.url, expired_at: page.data.review_by }
    end

    pages - expired_pages
  end
end
