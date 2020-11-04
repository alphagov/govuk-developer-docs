---
owner_slack: "#govuk-platform-health"
title: Load Test Email Alert API
parent: "/manual.html"
layout: manual_layout
section: Emails
---

You may wish to load test email-alert-api to get a realistic idea of how the system performs under high load, or if you're making changes to how emails are processed to ensure your changes have the desired effect.

Before you begin, you should post in the #2nd-line channel that you’re about to do some load testing and that as part of that you’ll be disabling puppet runs on Staging for email-alert-api.

> Rake tasks for load testing can be found [here](https://github.com/alphagov/email-alert-api/blob/master/lib/tasks/load_testing.rake).

## Testing without Notify

email-alert-api has [a DelayProvider](https://github.com/alphagov/email-alert-api/blob/master/app/providers/delay_provider.rb) to simulate the delay of actual requests to Notify, so we can focus on internal load testing, without Notify being a factor. You will need to:

- Deploy [this PR or similar](https://github.com/alphagov/govuk-puppet/pull/10412) to the Staging environment.

- Run Puppet on each of the machines.

  ```
  fab -P staging_aws class:email_alert_api puppet
  ```

- Disable Puppet to persist the temporary change.

  ```
  fab -P staging_aws class:email_alert_api 'puppet.disable:"<date> load testing"'
  ```

- Manually restart the workers to pick up the change.

  ```
  fab -P staging_aws class:email_alert_api app.restart:email-alert-api-procfile-worker
  ```

## Testing with Notify

> Let the Notify team know if you’re planning on doing a large scale test (anything more than a few thousand emails) and they can scale it up as necessary.

Normally emails from the Staging environment are [severely rate limited](https://www.notifications.service.gov.uk/using-notify/trial-mode). You can repoint the NotifyProvider to a Staging version of Notify, which is more realistic. You will need to:

- Update [the Puppet Deploy job](https://deploy.blue.staging.govuk.digital/job/Deploy_Puppet/configure) to use [a branch of govuk-secrets with the required API key](https://github.com/alphagov/govuk-secrets/pull/993). The API key is stored in [the **infra** pass store](https://github.com/alphagov/govuk-secrets/blob/master/pass/infra/.gpg-id) in govuk-secrets under `govuk-notify/test-api-key`.

- Deploy [this PR or similar](https://github.com/alphagov/govuk-puppet/pull/10413) to the Staging environment.

- Run Puppet on each of the machines.

  ```
  fab -P staging_aws class:email_alert_api puppet
  ```

- Disable Puppet to persist the temporary change.

  ```
  fab -P staging_aws class:email_alert_api 'puppet.disable:"<date> load testing"'
  ```

- Manually restart the workers to pick up the change.

  ```
  fab -P staging_aws class:email_alert_api app.restart:email-alert-api-procfile-worker
  ```

## After the test

Once you've finished the test and the queues have been cleared, re-enable puppet runs, run puppet in order to overwrite the environment variables you've set and restart the workers again.

You can manually clear a large backlog of content changes by running the [clear_emails rake task](https://github.com/alphagov/email-alert-api/blob/25fdc3be525170ad44bce5e8f6aa1529994af143/lib/tasks/load_testing.rake#L40), and then wiping all active jobs with `fab -P class:email_alert_api sdo:"pkill -9 --full sidekiq"`.

Let 2nd line and Notify know you've finished, and if you were using Notify, let them know too.
