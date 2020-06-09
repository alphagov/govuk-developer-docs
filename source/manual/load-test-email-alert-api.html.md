---
owner_slack: "#govuk-platform-health"
title: Load Test Email Alert API
parent: "/manual.html"
layout: manual_layout
section: Emails
last_reviewed_on: 2020-01-13
review_in: 12 months
---

You may wish to load test email-alert-api to get a realistic idea of how the system performs under high load, or if your're making changes to how emails are processed to ensure your changes have the desired effect.

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

- Manualy restart the workers to pick up the change.
  ```
  fab -P staging_aws class:email_alert_api app.restart:email-alert-api-procfile-worker
  ```

## Testing with Notify

You can load test email-alert-api with the staging version of Notify so that it won’t put unnecessary load on their production version. Let them know if you’re planning on doing a large scale test (anything more than a few thousand emails) and they can scale it up as necessary.

### Setting up for the test

1. Post on #2nd-line channel that you’re about to do some load testing and that as part of that you’ll be disabling puppet runs on staging for email-alert-api.
2. Use a fabric script to disable puppet runs for email-alert-api so it won't overwrite or remove the environment variables you need to set to run the test.
3. If you're running the test against Notify's staging environment, you need to set a few environment variables. The API key is stored in the pass store in govuk-secrets under `govuk-notify/test-api-key`

| Key                      | Value                                | Reason                                                                         |
|--------------------------|--------------------------------------|--------------------------------------------------------------------------------|
| GOVUK_NOTIFY_BASE_URL    | https://api.staging-notify.works/    | We need to send requests to the correct endpoint                               |
| GOVUK_NOTIFY_API_KEY     | Key from govuk-secrets               | The production key will not be correct for staging                             |
| GOVUK_NOTIFY_TEMPLATE_ID | 76d21ce7-54c3-4fb7-8830-ba3b79287985 | Requests will fail if it cannot find the template, this exists only on staging |

4. You need to set the following environment variable key value pairs whether or not you're sending emails to Notify staging:

| Key                    | Value                           | Reason                                                            |
|------------------------|---------------------------------|-------------------------------------------------------------------|
| EMAIL_ADDRESS_OVERRIDE | success@simulator.amazonses.com | Sends all emails to Amazon SES, preventing it going to real users |


5. Use fabric to restart the workers so they'll pick up the new environment variables by running `fab aws_staging node_type:email_alert_api app.restart:email-alert-api-procfile-worker`
6. Now you're ready to start, open a rails console on an email-alert-api machine on staging. How you perform the test may depend on what you want to test, in the past we've duplicated content changes from a few hours or a day.


### During the test
You can keep an eye on the [Grafana dashboard](https://grafana.staging.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1&from=now-1h&to=now) to see how it's performing. If it's a large test, a lot of logs can be produced in a short amount of time so use the [machine dashboard](https://grafana.blue.staging.govuk.digital/dashboard/file/machine.json) filtered by email-alert-api machines to check disk space usage.


### After the test
Once you've finished the test and the queues have been cleared, re-enable puppet runs, run puppet in order to overwrite the environment variables you've set, restart the workers again and let 2nd line and Notify know you've finished.
