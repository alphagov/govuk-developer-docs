---
owner_slack: "#govuk-2ndline"
title: Receive emails from Email Alert API in integration and staging
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-04
review_in: 6 months
---

In integration and staging Email Alert API defaults to sending emails
to a single test address: `success@simulator.amazonses.com`. This is used to
simulate a successful email sending.

You can however override this for specific email addresses for testing
purposes. There are two steps to this:

1. Invite yourself as a team member to the Notify team for the appropriate
   environment. You can log into Notify with the courtesy-copies account
   which is stored in [govuk-secrets][] under
   `govuk-notify/govuk-email-courtesy-copies`.
2. Add your email address to the override whitelist. This is set as an
   environment variable via [govuk-puppet][]. It is configured via hieradata
   under the key of
   `govuk::apps::email_alert_api::email_address_override_whitelist`.

Once these changes have been deployed and the environment variable
`EMAIL_ADDRESS_OVERRIDE_WHITELIST` is populated with your address you can test
that you can receive emails by running the
[`deliver:to_test_email[name@example.com]`][rake-task] rake task.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[rake-task]: https://github.com/alphagov/email-alert-api/blob/master/lib/tasks/deliver.rake#L19
