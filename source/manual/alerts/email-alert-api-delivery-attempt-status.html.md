---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: High number of delivery attempts'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-05
review_in: 6 months
---

## Internal failures (`internal_failure`)

This means that we’ve failed to make a request to Notify within the last hour
due to a problem in our code. The reason for this failure should be visible in
Sentry.

## Technical failures (`technical_failure`)

This means that we’ve received a technical failure status code back from Notify
or a request to send an email via Notify failed within the last hour. This
means that there may be a problem with our system or that Notify is unable to
send emails.

In non-production environments, this failure may also mean that we’re
attempting to send emails to people who are not members of the Notify team for
the relevant environment.

In this case, ensure the contents of the
`govuk::apps::email_alert_api::email_address_override_whitelist` key in
[hieradata][] and [hieradata_aws][] matches the members of the
staging/integration Notify teams.

You can login to the Notify account by going to the
[GOV.UK Notify Admin Interface][notify]. The login credentials are in the
[2nd line password store][password-store] under
`govuk-notify/2nd-line-support`.

[notify]: https://www.notifications.service.gov.uk
[hieradata]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
[hieradata_aws]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml
[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
