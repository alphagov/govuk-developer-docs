---
owner_slack: "#govuk-2ndline"
title: Manage email subscribers (change email, unsubscribe, move lists)
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-05-03
review_in: 6 months
---
Users can manage email subscribers via the [administration
interface on GOV.UK](https://www.gov.uk/email/manage). Support tickets coming through to 2ndline where
the user is unaware of this, or needs guidance can be assigned to "2nd
Line--User Support Escalation".

*Note: this applies only to emails sent by GOV.UK. [Drug safety updates](https://www.gov.uk/drug-safety-update) are sent manually by MHRA, who manage their own service using Govdelivery. We do not have access to this.*

If it is not possible for changes to be managed by the user, it is
possible for changes to be made manually. The following rake tasks
should be run using the Jenkins `Run rake task` job for ease-of-use:

## Change a subscriber's email address

[⚙ Run rake task on production][change]

[change]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=manage:change_email_address[from@example.org,to@example.org]

## Unsubscribe a subscriber from all emails

[⚙ Run rake task on production][unsub]

[unsub]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=manage:unsubscribe_single[email@example.org]

## Unsubscribe a list of subscribers from all emails in bulk

> **Note**
> The CSV file should contain email addresses in the first column. All other data will be ignored.

```shell
$ bundle exec rake manage:unsubscribe_bulk_from_csv[<path to CSV file>]
```

## Move all subscribers from one list to another

This is useful for changes such as departmental name changes, where new lists are created but subscribers should continue to receive emails.

[⚙ Run rake task on production][move]

[move]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=manage:move_all_subscribers[<slug-of-old-list>,<slug-of-new-list>]
