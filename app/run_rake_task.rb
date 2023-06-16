require "padrino-helpers"

class RunRakeTask
  def self.links(application, rake_task = "")
    app_name = if application.respond_to?(:repo_name)
                 application.repo_name
               else
                 application
               end
    rake_task_name = rake_task.presence || "<rake task>".freeze
    <<~END_OF_MARKDOWN
      ```sh
      k exec deploy/#{app_name} -- rake #{rake_task_name}
      ```
    END_OF_MARKDOWN
  end
end
