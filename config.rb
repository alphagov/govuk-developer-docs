require "govuk_tech_docs"
require_relative "./app/requires"

GovukTechDocs.configure(self)

set :markdown,
    renderer: DeveloperDocsRenderer.new(
      with_toc_data: true,
      api: true,
      context: self,
    ),
    fenced_code_blocks: true,
    tables: true,
    no_intra_emphasis: true,
    hard_wrap: false

configure :development do
  # Disable Google Analytics in development
  config[:tech_docs][:ga_tracking_id] = nil
end

# Configure the sitemap for Google
set :url_root, config[:tech_docs][:host]
activate :search_engine_sitemap,
         default_change_frequency: "weekly"

# Load all the `dist/` directories from direct dependencies specified in package.json
package = JSON.parse(File.read("package.json"))
package.fetch("dependencies", []).each_key do |dep|
  sprockets.append_path File.join(__dir__, "node_modules", dep, "dist")
end

helpers do
  def dashboard
    Dashboard.new
  end

  def manual
    Manual.new(sitemap)
  end

  def related_things
    @related_things ||= RelatedThings.new(manual, current_page)
  end

  def section_url
    StringToId.convert(current_page.data.section)
  end

  def page_title
    (defined?(locals) && locals[:title]) || [current_page.data.title, current_page.data.section].compact.join(" - ")
  end

  def sanitize(contents)
    ActionController::Base.helpers.sanitize(contents)
  end
end

ignore "templates/*"

unless ENV["SKIP_PROXY_PAGES"] == "true"
  ProxyPages.resources.each do |resource|
    proxy resource[:path], resource[:template], resource[:frontmatter]
  end
end

# Configuration for Analytics pages
ignore "analytics/templates/*"

page "analytics/*", layout: :analytics_layout

data.analytics.events.each do |event|
  event_name = event["name"].downcase.gsub(" ", "_")
  proxy "analytics/event_#{event_name}.html", "analytics/templates/event.html", locals: { event: }
end

data.analytics.attributes.each do |attribute|
  attribute_name = attribute["name"].downcase.gsub(" ", "_")
  proxy "analytics/attribute_#{attribute_name}.html", "analytics/templates/attribute.html", locals: { attribute:, variant: nil }

  next unless attribute.variants

  attribute.variants.each do |variant|
    variant_name = variant["event_name"].downcase.gsub(" ", "_")
    proxy "analytics/attribute_#{attribute_name}/variant_#{variant_name}.html", "analytics/templates/attribute.html", locals: { attribute:, variant: }
  end
end

data.analytics.trackers.each do |tracker|
  tracker_name = tracker["name"].downcase.gsub(" ", "_")
  proxy "analytics/tracker_#{tracker_name}.html", "analytics/templates/tracker.html", locals: { tracker: }
end
