---
owner_slack: "#govuk-2ndline"
title: Receive emails from Email Alert API in integration and staging
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-26
review_in: 6 months
---

In `integration` and `staging` Email Alert API defaults to sending emails
to a single test address: `success@simulator.amazonses.com`. This is used to
simulate a successful email sending.

You can however override this for specific email addresses for testing
purposes.

In [Notify][]:

1. Log in using the 2nd-line-support account which is stored in [govuk-secrets][]
  under `govuk-notify/2nd-line-support`. You should receive an email via 2nd Line
   Support containing a link to sign in to Notify.
2. Choose the service in the appropriate environment and navigate to "Team members".
  The members with the permission `Manage settings, team and usage` will be able to
  add you to this team.

In [govuk-puppet][]:

1. Add your email address to the override whitelist. This is set as an
   environment variable via hieradata under the key of
   `govuk::apps::email_alert_api::email_address_override_whitelist`.

Once these changes have been deployed and the environment variable
`EMAIL_ADDRESS_OVERRIDE_WHITELIST` is populated with your address you can test
that you can receive emails by running the [deliver:to_test_email[name@example.com]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=deliver:to_test_email[name@example.com]) [rake task].

[Notify]: https://www.notifications.service.gov.uk
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[rake task]: https://github.com/alphagov/email-alert-api/blob/master/lib/tasks/deliver.rake#L19
