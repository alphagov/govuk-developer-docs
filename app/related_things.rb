class RelatedThings
  attr_reader :manual, :current_page

  def initialize(manual, current_page)
    @manual = manual
    @current_page = current_page
  end

  def related_applications
    @related_applications ||= current_page.data.related_applications.to_a.map do |app_name|
      [app_name, "/apps/#{app_name}.html"]
    end
  end

  def any_related_pages?
    (related_learning_pages + related_task_pages).any?
  end

  def related_learning_pages
    manual.other_pages_from_section(current_page).select do |page|
      page.data.type == "learn"
    end
  end

  def related_task_pages
    manual.other_pages_from_section(current_page).select do |page|
      page.data.type.nil?
    end
  end
end
