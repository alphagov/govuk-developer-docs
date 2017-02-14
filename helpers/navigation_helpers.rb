module NavigationHelpers
  def active_page?(page_path)
    ("/" + current_page.path) == page_path || current_page.data.parent == page_path
  end
end
