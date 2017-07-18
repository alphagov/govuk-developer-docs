class Manual
  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def pages_for_application(app_name)
    sitemap.resources
      .select { |page| page.path.start_with?('manual/') && page.path.end_with?('.html') && page.data.title }
      .select { |page| page.data.related_applications.to_a.include?(app_name) }
      .sort_by { |page| page.data.title.downcase }
  end
end
