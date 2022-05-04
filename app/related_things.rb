class RelatedThings
  attr_reader :manual, :current_page

  def initialize(manual, current_page)
    @manual = manual
    @current_page = current_page
  end

  def related_repos
    @related_repos ||= current_page.data.related_repos.to_a.map do |repo_name|
      [repo_name, "/repos/#{repo_name}.html"]
    end
  end

  def any_related_pages?
    (related_learning_pages + related_task_pages + related_alerts).any?
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

  def related_alerts
    manual.other_alerts_from_subsection(current_page)
  end
end
