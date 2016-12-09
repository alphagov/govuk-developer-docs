module NavigationHelpers
  def active_page?(page_path)
    current_page.path.start_with?(page_path) || current_page.data.parent == page_path
  end
end
