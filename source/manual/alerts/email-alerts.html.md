---
owner_slack: "#email"
title: Email alerts not sent
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-01-04
review_in: 1 month
---

GOV.UK sends out emails when certain publications are published. There is [a check](https://github.com/alphagov/email-alert-monitoring) to verify that emails are sent for [drug and medical device alerts](https://www.gov.uk/drug-device-alerts)
and [travel advice updates](https://www.gov.uk/foreign-travel-advice).

If the check fails:

- Inspect the console logs for the [travel advice email alert](https://deploy.publishing.service.gov.uk/job/travel-advice-email-alert-check/) and the [email alert monitoring](https://deploy.publishing.service.gov.uk/job/email-alert-check/) jobs. These will tell you which emails are missing.
- Check the monitoring inbox to rule out false alerts. Emails are sent to a
monitoring inbox at `googleapi@digital.cabinet-office.gov.uk`. Credentials for
the account can be found in the [2nd line password store](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/google-accounts). **In order to login you will need to use one of the backup codes.** (Remove the one you used after), The test is
diacritic-sensitive so you may see false alerts where `São Tomé and Principe`
fails to match `Sao Tome and Principe`.
- Search for `@tags:"govdelivery"` in [Kibana](https://kibana.publishing.service.gov.uk).

## Resending travel advice emails

If you need to force the sending of a travel advice email alert, there
is a rake task in the travel advice publisher, which you can run using
[this Jenkins
job](https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE=backend-1.backend&RAKE_TASK=email_alerts:trigger%5BPUT_EDITION_ID_HERE%5D),
where the edition ID of the travel advice content item can be found in
the URL of the country's edit page in the travel advice publisher and
looks like `fedc13e231ccd7d63e1abf65`.
