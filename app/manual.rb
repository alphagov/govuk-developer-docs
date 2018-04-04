class Manual
  ICINGA_ALERTS = "Icinga alerts".freeze

  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def manual_pages_grouped_by_section
    grouped = manual_pages
      .group_by { |page| page.data.section || "Uncategorised" }
      .sort_by(&:first)

    [["Common tasks", most_important_pages]] + grouped
  end

  def pages_for_application(app_name)
    manual_pages.select { |page| page.data.related_applications.to_a.include?(app_name) }
  end

  def other_pages_from_section(other_page)
    manual_pages.select { |page| page.data.section == other_page.data.section } - [other_page]
  end

private

  def most_important_pages
    manual_pages.select { |page| page.data.important }
  end

  def manual_pages
    sitemap.resources
      .reject { |page| page.data.section == ICINGA_ALERTS }
      .select { |page| page.path.start_with?('manual/') && page.path.end_with?('.html') && page.data.title }
      .sort_by { |page| page.data.title.downcase }
  end
end
