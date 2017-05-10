---
owner_slack: "#2ndline"
title: Email Alerts
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-04-03
review_in: 6 months
---

GOV.UK sends out emails when certain publications are published. We have
set up a check to verify that emails are sent for certain publication
types (the drug and medical device alerts and travel advice updates).

If the check fails inspect the [console
logs](https://deploy.publishing.service.gov.uk/job/email-alert-check)
for the job. This will tell you which emails are missing. You can find
more information about the [architecture on the
Wiki](https://gov-uk.atlassian.net/wiki/display/GOVUK/Email+notifications+and+atom+feeds).

[DetailedTravel Advice Issue
Guidance](https://github.gds/pages/gds/opsmanual/2nd-line/applications/travel-advice-publisher.html)

If you need to force the sending of a travel advice email alert, there
is a rake task in the travel advice publisher, which you can run using
[this Jenkins
job](https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE=backend-1.backend&RAKE_TASK=email_alerts:trigger%5BPUT_EDITION_ID_HERE%5D),
where the edition ID of the travel advice content item can be found in
the URL of the country's edit page in the travel advice publisher and
looks like "fedc13e231ccd7d63e1abf65".

