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

## Troubleshooting failed checks

First inspect the console logs for the Jenkins job to confirm the reason for the
failure.

Check the mailbox that is used for the check to rule out an issue searching for
the message: `govuk_email_check@digital.cabinet-office.gov.uk`. Its credentials
can be found in the [2nd line password store][] under
`google-accounts/govuk_email_check@digital.cabinet-office.gov.uk`.

If the email has been received by the mailbox but the subject of the email
doesn't match the title of the content item, this means that the title of the
content was updated after it was first published and after the emails went out.
To stop the check from constantly failing, add the updated content item title
to the [acknowledged email list][] and then re-run the Jenkins job.

## Troubleshooting unsent emails

If the check is reporting correctly then emails are not being sent. Try the
[general troubleshooting tips for unsent emails][troubleshooting].

## Resending travel advice emails

If you need to force the sending of a travel advice email alert, there
is a rake task in Travel Advice Publisher, which you can run using
[this Jenkins job][resend travel advice job] where the edition ID of the
travel advice content item can be found in the URL of the country's edit
page in Travel Advice Publisher and looks like `fedc13e231ccd7d63e1abf65`.

[2nd line password store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline
[acknowledged email list]: https://github.com/alphagov/email-alert-monitoring/blob/master/lib/email_verifier.rb#L6-L14
[medical safety check]: https://deploy.blue.production.govuk.digital/job/medical-safety-email-alert-check/
[medical safety alerts]: https://www.gov.uk/drug-device-alerts
[email-alert-monitoring]: https://github.com/alphagov/email-alert-monitoring
[resend travel advice job]: https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=email_alerts:trigger%5BPUT_EDITION_ID_HERE%5D
[travel advice check]: https://deploy.blue.production.govuk.digital/job/travel-advice-email-alert-check/
[travel advice updates]: https://www.gov.uk/foreign-travel-advice
[troubleshooting]: /manual/email-troubleshooting.html
