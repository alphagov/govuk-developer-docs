---
owner_slack: "#govuk-notifications"
title: Receive emails from Email Alert API in Integration and Staging
section: Emails
layout: manual_layout
parent: "/manual.html"
---

In order to test receiving real emails from Email Alert API we have configured
Google groups for the integration and staging environments. Emails
sent to addresses other than those of these groups will be
[written to a logfile][logging-emails].

## In Integration

For testing in Integration there is the [Email Alert API Integration Google
group][integration-group]. It has an email address of
`email-alert-api-integration@digital.cabinet-office.gov.uk` and you can use this
address to sign up for mailing lists that you wish to test.

## In Staging

In Staging there is the [Email Alert API Staging Google
group][staging-group] and it has an email address of
`email-alert-api-staging@digital.cabinet-office.gov.uk`.

## How to use

To use these Google groups you need to interact with the Email Alert system
using the group email as your email address. For example, if you wanted to test
receiving the content change alerts for travel advice, you can
[sign-up to receive travel advice][travel-advice] with the group email address.
Your next step would be to check the Google group for
an email to confirm the subscription. Once confirmed, you can then publish
a change in [Travel Advice Publisher][] to generate the content change
alert email.

If you are testing over multiple days, bear in mind that each night the
databases in Integration and Staging are reset due to the [data sync][].
This will mean that any test subscriptions you've created will be lost and
you'll need to recreate them.

[logging-emails]: https://github.com/alphagov/email-alert-api/blob/006afa2ee6c35631b83b16519f8af2c6c2ea5c59/app/services/send_email_service/send_pseudo_email.rb#L10-L20
[integration-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/email-alert-api-integration
[travel-advice]: https://www.integration.publishing.service.gov.uk/foreign-travel-advice/thailand/email-signup
[Travel Advice Publisher]: https://travel-advice-publisher.integration.publishing.service.gov.uk/admin/countries/thailand
[staging-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/email-alert-api-staging
[data sync]: /manual/govuk-env-sync.html
