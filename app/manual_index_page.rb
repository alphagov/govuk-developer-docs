class ManualIndexPage
  ICINGA_ALERTS = "Icinga alerts".freeze

  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def columns
    [
      first_column,
      in_two_groups[0],
      in_two_groups[1],
    ]
  end

private

  def first_column
    {
      "Top tasks" => most_important_pages,
      "Manual" => manual_pages.select { |page| page.data.section == "Manual" },
      "Expired pages" => page_freshness.expired_pages,
      "Pages due for review this week" => page_freshness.expiring_soon,
      ICINGA_ALERTS => manual_pages.select { |page| page.data.section == ICINGA_ALERTS },
    }
  end

  def page_freshness
    PageFreshness.new(sitemap)
  end

  def in_two_groups
    slice_size = (manual_pages_grouped_by_section.size / 2.0).ceil
    manual_pages_grouped_by_section.each_slice(slice_size).to_a
  end

  def manual_pages_grouped_by_section
    manual_pages
      .reject { |page| page.data.section.in?([ICINGA_ALERTS, "Manual"]) } # these go into the 1st column
      .group_by { |page| page.data.section || "Uncategorised" }
      .sort_by(&:first)
  end

  def most_important_pages
    manual_pages.select { |page| page.data.important }
  end

  def manual_pages
    sitemap.resources
      .select { |resource| page_in_manual?(resource) }
      .sort_by { |page| page.data.title.downcase }
  end

  # Only show accessible HTML pages, not images or redirects 
  def page_in_manual?(resource)
    !resource.is_a?(Middleman::Sitemap::Extensions::RedirectResource) &&
      resource.path.start_with?('manual/') &&
      resource.path.end_with?('.html')
  end
end
