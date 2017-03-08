module NavigationHelpers
  def active_page?(page_path)
    (current_page.path == 'index.html' && page_path == '/') ||
      "/" + current_page.path == page_path ||
      current_page.data.parent == page_path
  end

  def sidebar_link(name, page_path)
    link_to name, page_path,
      class: "/#{current_page.path}" == page_path ? 'toc-link--in-view' : nil
  end
end
