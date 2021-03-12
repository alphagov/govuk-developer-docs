module NavigationHelpers
  def active_page?(page_path)
    (current_page.path == "index.html" && page_path == "/") ||
      "/#{current_page.path}" == page_path ||
      current_page.data.parent == page_path
  end

  def sidebar_link(name, page_path)
    link_to(page_path, class: page_path == "/#{current_page.path}" ? "toc-link--in-view" : nil) do
      content_tag(:span, name)
    end
  end
end
