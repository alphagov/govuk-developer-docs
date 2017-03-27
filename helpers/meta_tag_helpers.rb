module MetaTagHelpers
  def meta_tags
    {
      'description' => page_description,
      'og:description' => page_description,
      'og:image' => page_image,
      'og:site_name' => full_service_name,
      'og:title' => page_title,
      'og:type' => 'object',
      'og:url' => canonical_url,
      'twitter:card' => 'summary',
      'twitter:domain' => URI.parse(config[:tech_docs][:host]).host,
      'twitter:image' => page_image,
      'twitter:title' => browser_title,
      'twitter:url' => canonical_url,
    }
  end

  def page_image
    "#{config[:tech_docs][:host]}/images/govuk-large.png"
  end

  def browser_title
    "#{page_title} | #{full_service_name}"
  end

  def full_service_name
    config[:tech_docs][:full_service_name]
  end

  def canonical_url
    config[:tech_docs][:host] + current_page.url
  end

  def page_description
    locals[:description] || current_page.data.description || config[:tech_docs][:description]
  end

  def page_title
    locals[:title] || current_page.data.title
  end

private

  def locals
    current_page.metadata[:locals]
  end
end
