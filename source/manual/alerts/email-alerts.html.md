---
owner_slack: "#govuk-2ndline"
title: Travel Advice or Drug and Medical Device email alerts not sent
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-12-03
review_in: 6 months
---

There is [a check][email-check] to verify that emails are sent for
[drug and medical device alerts][] and [travel advice updates][]. These checks
are run via Jenkins: [Drug and medical device alerts check][drug-alerts-check]
and [Travel advice alerts check][travel-advice-check].

## Troubleshooting failed checks

First inspect the console logs for the Jenkins job to confirm the reason for the
failure. The email check looks in two different mailboxes and the failure message
should describe which mailbox is seeing an issue.

* Check the mailbox that is used for the check to rule out an issue searching
  for the message: `govuk_email_check@digital.cabinet-office.gov.uk`
  This email address is subscribed to travel advice alerts and drug and medical
  device alerts. Its credentials can be found in the [2nd line password store][]
  under `google-accounts/govuk_email_check@digital.cabinet-office.gov.uk`.

* [Check the courtesy copy inbox][]. Its presence here doesn't mean that the
  email was sent to users, just that Email Alert API processed the content change.

If the email has been received by the mailbox but the subject of the email
doesn't match the title of the content item, this means that the title of the
content was updated after it was first published and after the emails went out.
To stop the check from constantly failing, add the updated content item title
to the [acknowledged email list][] and then re-run the Jenkins job.

## Troubleshooting unsent emails

If the check is reporting correctly then emails are not being sent. Try the
[general troubleshooting tips for unsent emails][].

## Resending travel advice emails

If you need to force the sending of a travel advice email alert, there
is a rake task in Travel Advice Publisher, which you can run using
[this Jenkins job][resend-travel-advice-job] where the edition ID of the
travel advice content item can be found in the URL of the country's edit
page in Travel Advice Publisher and looks like `fedc13e231ccd7d63e1abf65`.

[2nd line password store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline
[acknowledged email list]: https://github.com/alphagov/email-alert-monitoring/blob/master/lib/email_verifier.rb#L6-L14
[check the courtesy copy inbox]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#check-the-courtesy-copy-inbox
[drug-alerts-check]: https://deploy.blue.production.govuk.digital/job/email-alert-check/
[drug and medical device alerts]: https://www.gov.uk/drug-device-alerts
[email-check]: https://github.com/alphagov/email-alert-monitoring
[general troubleshooting tips for unsent emails]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#general-troubleshooting-tips
[resend-travel-advice-job]: https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=email_alerts:trigger%5BPUT_EDITION_ID_HERE%5D
[travel-advice-check]: https://deploy.blue.production.govuk.digital/job/travel-advice-email-alert-check/
[travel advice updates]: https://www.gov.uk/foreign-travel-advice
