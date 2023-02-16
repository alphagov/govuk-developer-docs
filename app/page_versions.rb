# PageVersions extension allows you to write alternative versions of a page and
# have them hidden from site navigation features (such as search and page
# lists).
#
# Page versions use a attribute in the frontmatter to specify the version. This
# attribute is set using the version_attribute option. The default_version
# option specifies what version of a page should appear in the site navigation
# features (e.g. the default page version users open). The version_order option
# specifies the order in which versions should be presented.

class PageVersions < Middleman::Extension
  expose_to_template :page_versions

  option :version_attribute
  option :default_version
  option :version_order

  def initialize(app, options_hash = {}, &block)
    super

    @attribute = options.version_attribute
    @default_version = options.default_version
    @version_order = options.version_order
  end

  # Add `index = false` tag to non-default pages so they don't appear in site
  # navigation features.
  def manipulate_resource_list(resources)
    resources.each do |resource|
      version = resource.data[@attribute]

      if !version.nil? && version != @default_version
        resource.data.index = false
      end
    end

    resources
  end

  # Helper function for templates to generate navigation to alternative page
  # versions. Alternative pages must have the same title.
  def page_versions(current_page)
    return nil if current_page.data[@attribute].nil?

    resource_versions = @app.sitemap.resources.select do |resource|
      resource.data.title == current_page.data.title
    end

    resource_versions.sort_by! do |r|
      # Match order in version_order option and put non-specifed versions last.
      @version_order.index(r.data[@attribute] || Float.INFINITY)
    end

    resource_versions.map do |version|
      {
        active: (current_page.path == version.path),
        text: version.data[@attribute],
        path: version.normalized_path,
      }
    end
  end
end

::Middleman::Extensions.register(:page_versions, PageVersions)
