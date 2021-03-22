require "padrino-helpers"

class RunJenkinsJob
  def self.links(jenkins_job)
    links = [
      ["Run #{jenkins_job} on Integration", jenkins_job_url("integration", jenkins_job)],
      ["Run #{jenkins_job} on Staging", jenkins_job_url("staging", jenkins_job)],
      ["⚠️ Run #{jenkins_job} on Production ⚠️", jenkins_job_url("production", jenkins_job)],
    ]

    html_lis = links
      .map { |body, url| "<li><a href=\"#{url}\" class=\"govuk-link\">#{body}</a></li>" }
      .join("\n")

    <<~ERB
      <ul>
        #{html_lis}
      </ul>
    ERB
  end

  def self.terse_links(jenkins_job)
    integration_link = "<a
      href=\"#{jenkins_job_url('integration', jenkins_job)}\"
      class=\"govuk-link\"
      aria-label=\"Run #{jenkins_job} on Integration\">Integration</a>"
    staging_link = "<a
      href=\"#{jenkins_job_url('staging', jenkins_job)}\"
      class=\"govuk-link\"
      aria-label=\"Run #{jenkins_job} on Staging\">Staging</a>"
    production_link = "<a
      href=\"#{jenkins_job_url('production', jenkins_job)}\"
      class=\"govuk-link\"
      aria-label=\"Run #{jenkins_job} on Production\">⚠️ Production ⚠️</a>"

    "<span aria-hidden='true'>Run #{jenkins_job} on</span> #{integration_link}, #{staging_link} or #{production_link}"
  end

  def self.jenkins_job_url(environment, jenkins_job)
    case environment
    when "integration"
      "https://deploy.integration.publishing.service.gov.uk/job/#{jenkins_job}"
    when "staging"
      "https://deploy.blue.staging.govuk.digital/job/#{jenkins_job}"
    when "production"
      "https://deploy.blue.production.govuk.digital/job/#{jenkins_job}"
    end
  end
end
