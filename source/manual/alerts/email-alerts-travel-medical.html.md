---
owner_slack: "#govuk-2ndline"
title: Travel Advice or Drug and Medical Device email alerts not sent
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
---

We expect that when new GOV.UK content is published, or when existing content
is updated in a significant way, emails will be sent to any subscribers to
notify them of the change.

We actively monitor this for [medical safety alerts][] and [travel advice
updates][] with the [Medical safety alerts check][medical safety check] and
[Travel advice alerts check][travel advice check], these are configured in
[email-alert-monitoring][].

These checks determine a list of content that we expect subscribers to have
been emailed. We use a Gmail account which is subscribed to all travel advice
and medical safety alerts to check whether an email has been received within a
sufficient time period, if not the checks will fail.

## Determining why the check failed

Use the "Console Output" of the Jenkins job for this check to determine the
reason the job failed.

Assuming it has failed due to not being able to find emails there should be a
list of email subjects that were expected to exist.

## Verifying whether the email was received

To verify if the Gmail account has received the email or not you can log into
the Gmail account, `govuk_email_check@digital.cabinet-office.gov.uk`, using
the credentials in the [2nd line password store][] under
`google-accounts/govuk_email_check@digital.cabinet-office.gov.uk`. Then you can
use the previously noted subjects to try identify the email(s).

This check has been susceptible to a number of false positive scenarios in the
past (there are [plans][retire alert adr] to retire this check due, in part,
to it's fragility), examples of these are:

* the email contents didn't exactly match what was searched for due to the
  content being edited, these can be resolved by updating the [acknowledged email
  list][] and re-running the Jenkins job;
* Gmail decided the email was spam;
* Gmail experienced service problems which delayed email receiving
  ([status dashboard][gmail status]).

## Troubleshooting emails that were not received

If you have verified that the email hasn't been received you should then
investigate was the email sent. Some avenues to explore are:

* determine whether Email Alert API has a backlog of work to do using the
  [Sidekiq dashboard][] and [Email Alert API Technical
  dashboard][tech dashboard] - the email may just be delayed;
* whether the change was a result of a new type of medical safety content
  sub-type, this was the previous cause of an [incident][checkbox-incident] and
  is recorded as [GOV.UK Tech Debt][checkbox tech debt];
* check whether the email was sent as a [courtesy copy][] to
  determine if Email Alert API processed the change;
* verify whether Notify sent the expected email using [the `support:view_emails`
  rake task][view_emails task];
* check the [Kibana logs][] and [Sentry][] for any errors or clues;
* if all else fails you may need to investigate the Email Alert API database
  to determine whether the content change was received and what state it is in.

## Resending travel advice emails

If you need to force the sending of a travel advice email alert, there
is a rake task in Travel Advice Publisher, which you can run using
[this Jenkins job][resend travel advice job] where the edition ID of the
travel advice content item can be found in the URL of the country's edit
page in Travel Advice Publisher and looks like `fedc13e231ccd7d63e1abf65`.

[medical safety alerts]: https://www.gov.uk/drug-device-alerts
[travel advice updates]: https://www.gov.uk/foreign-travel-advice
[medical safety check]: https://deploy.blue.production.govuk.digital/job/medical-safety-email-alert-check/
[travel advice check]: https://deploy.blue.production.govuk.digital/job/travel-advice-email-alert-check/
[email-alert-monitoring]: https://github.com/alphagov/email-alert-monitoring
[2nd line password store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline
[retire alert adr]: https://github.com/alphagov/email-alert-api/blob/master/docs/adr/adr-008-monitoring-and-alerting.md#removal-of-email-alert-monitoring
[acknowledged email list]: https://github.com/alphagov/email-alert-monitoring/blob/master/lib/email_verifier.rb#L6-L14
[gmail status]: https://www.google.co.uk/appsstatus#hl=en-GB&v=status
[Sidekiq dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=email-alert-api&var-Interval=$__auto_interval
[tech dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/email_alert_api_technical.json?refresh=1m&orgId=1
[checkbox-incident]: https://docs.google.com/document/d/1AwpXPF1c7fbsOL8KX10ko_wLok4YykabmRfkHJjRqfA/edit#
[checkbox tech debt]: https://trello.com/c/v2ees2fD/199-all-checkbox-is-misleading-for-finderemailsignups
[courtesy copy]: /manual/email-notifications-how-they-work.html#useful-resources
[view_emails task]: https://github.com/alphagov/email-alert-api/blob/master/docs/support-tasks.md#view-subscribers-recent-emails
[Kibana logs]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/goto/43fc79ee47ac49f248e0f29a174be240
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=12h
[resend travel advice job]: https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=email_alerts:trigger%5BPUT_EDITION_ID_HERE%5D
