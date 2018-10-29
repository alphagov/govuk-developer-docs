---
owner_slack: "#govuk-2ndline"
title: Email alerts not sent
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-29
review_in: 6 months
---

There is [a check][email-check] to verify that emails are sent for
[drug and medical device alerts][] and [travel advice updates][]. These checks
are run via Jenkins: [Drug and medical device alerts check][drug-alerts-check]
and [Travel advice alerts check][travel-advice-check].

If a check fails:

* You can inspect the console logs for the Jenkins job to confirm the reason
  for the failure.
* You can check the mailbox that is used for the check to rule out an issue
  searching for the message. We have an email address
  `govuk_email_check@digital.cabinet-office.gov.uk` which is subscribed to
  travel advice alerts and drug and medical device alerts. The credentials
  for this account is in the [2nd line password store][] under
  `google-accounts/govuk_email_check@digital.cabinet-office.gov.uk`.
* You can check whether the email was sent to the
  [courtesy copies google group][] - presence here doesn't mean that the email
  was sent to users, just that Email Alert API processed the content change.
* You can investigate further whether the email was sent by accessing the
  Email Alert API console.
  * `ContentChange.where(content_id: "<items-content-id>")` to look up the
     content changes Email Alert API has received for a particular content-id
  * Given a particular content change you can monitor whether this should have
    been sent to people by querying
    `SubscriptionContent.where(content_change: <your_content_change>)`
    to look up the email data directly
  * You can look up emails sending or sent to a particular address with
    `Email.where(address: "<address>")`
  * You can find [unprocessed content changes][unprocessed-content-changes] and
    check whether the content change for the failed alert is in the list of [affected content changes][affected-content-changes]
  * If you find the content change has not been processed, check the [number of
    subscription contents][number-subs-contents] built for the content change a few times (the number should increase)
  * If the number of subscription contents is not increasing, it is possible the
    sidekiq job has terminated ungracefully. You can [resend the content
    change][resend-content-change]. This will ignore any that have already gone
    out so it is safe to execute

## Resending travel advice emails

If you need to force the sending of a travel advice email alert, there
is a rake task in Travel Advice Publisher, which you can run using
[this Jenkins job][resend-travel-advice-job] where the edition ID of the
travel advice content item can be found in the URL of the country's edit
page in Travel Advice Publisher and looks like `fedc13e231ccd7d63e1abf65`.

[email-check]: https://github.com/alphagov/email-alert-monitoring
[drug and medical device alerts]: https://www.gov.uk/drug-device-alerts
[travel advice updates]: https://www.gov.uk/foreign-travel-advice
[drug-alerts-check]: https://deploy.publishing.service.gov.uk/job/email-alert-check/
[travel-advice-check]: https://deploy.publishing.service.gov.uk/job/travel-advice-email-alert-check/
[2nd line password store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline
[courtesy copies google group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
[resend-travel-advice-job]: https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=email_alerts:trigger%5BPUT_EDITION_ID_HERE%5D
[affected-content-changes]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#check-which-content-changes-are-affected
[number-subs-contents]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#check-number-of-subscription-contents-built-for-a-content-change-you-would-expect-this-number-to-keep-going-up
[resend-content-change]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#resend-the-emails-for-a-content-change-ignore-ones-that-have-already-gone-out
[unprocessed-content-changes]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#unprocessed-content-changes-content_changes
