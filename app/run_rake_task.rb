require "padrino-helpers"

class RunRakeTask
  def self.links(application, rake_task = "")
    application = find_application(application) if application.is_a? String

    rake_task_name = rake_task.presence || "a Rake task"

    links = [
      ["Run #{rake_task_name} on Integration", application.rake_task_url("integration", rake_task)],
      ["Run #{rake_task_name} on Staging", application.rake_task_url("staging", rake_task)],
      ["⚠️ Run #{rake_task_name} on Production ⚠️", application.rake_task_url("production", rake_task)],
    ]

    html_lis = links
      .map { |body, url| "<li><a href=\"#{url}\">#{body}</a></li>" }
      .join("\n")

    <<~ERB
      <ul>
        #{html_lis}
      </ul>
    ERB
  end

  def self.find_application(name)
    Applications.all.select { |app| app.app_name == name }.first
  end
end
