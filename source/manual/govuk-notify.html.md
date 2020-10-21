---
owner_slack: "#govuk-developers"
title: How we use GOV.UK Notify
section: Emails
type: learn
layout: manual_layout
parent: "/manual.html"
---

[GOV.UK Notify][notify] is a Government-as-a-Platform service that allows
clients of their API to send emails, text messages and letters. We use GOV.UK
Notify to send emails to users - both members of the public and publishers.
Historically, we've also used Amazon SES directly to send emails, but that's
being phased out in favour of GOV.UK Notify.

[notify]: https://www.notifications.service.gov.uk/

We have three main services on GOV.UK Notify (nine in total as we have a service
for each environment):

- **GOV.UK Emails**

  This service is used by Email Alert API only. It's used to send public-facing
  email updates about pieces of content on GOV.UK. It's our biggest sender of
  emails generating millions of emails per day.

  The [Email Alert API Product dashboard] shows usage over time.

  **Note:** currently (as of 04/08/2020) GOV.UK Notify has a maximum rate limit
  of 350 requests per second and a daily limit of 30 million emails per day
  (Notify's daily allowance with Amazon SES) meaning we should adhere to these
  limits when using Notify to deliver emails for our applications. The rate
  limit of 350 requests per second is set in email-alert-api and can be found in the
  [SendEmailWorker][SendEmailWorker]. If you wish to double check these figures
  you could ask in their slack channel #govuk-notify.

- **GOV.UK Publishing**

  This service is used by our publishing applications. It's used to send
  publisher-facing emails. The type of email can vary a lot, but a typical
  example might be to receive an email when a scheduled document on GOV.UK has
  been automatically published.

- **GOV.UK**

  This service is for any public-facing application that does not use the Email Alert Api
  to send emails.

  Currently it is used by [Feedback](https://github.com/alphagov/feedback) to email a survey link
  to users who click a survey banner or use the `Is this page useful?` feature.

[SendEmailWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/send_email_worker.rb#L4

## Accessing the dashboard

**[👉 Sign in to the GOV.UK Notify dashboard](https://www.notifications.service.gov.uk/sign-in)**

You can either use your own credentials (if you have them) or you can use the
credentials in [govuk-secrets][] (found in the `govuk-notify/2nd-line-support`
entry).

[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## Receiving emails from GOV.UK Notify

GOV.UK Notify services have two modes: live and [trial][trial-mode]. Our
production services are all in live mode; most other services are in trial
mode. In this mode emails will only be sent to members of the service or email
address in the allow-list, any request to send an email to another email
address will fail.

[trial-mode]: https://www.notifications.service.gov.uk/using-notify/trial-mode

To receive emails in integration and staging through GOV.UK Notify, you should
add yourself to the service:

1. Choose the service in the appropriate environment and navigate to
   "Team members".

2. The members with the permission `Manage settings, team and usage` will be
   able to add you to this team.

**Note:** some of our applications, notably Email Alert API, has an extra level
of protection and [there is an extra step][email-alert-api-receive-emails]
before you can receive emails through Email Alert API.

[email-alert-api-receive-emails]: /manual/receiving-emails-from-email-alert-api-in-integration-and-staging.html
[Email Alert API Product dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/email_alert_api_product.json?refresh=1m&orgId=1

The GOV.UK Publishing services are a special case: for these services,
integration and staging also run in production mode. This is because
[Signon](../apps/signon.html) needs to be able to send emails to all users,
even in integration and production. However, most of the apps using this
service use a team-only API key with the same restriction; only Signon has a
live key.
