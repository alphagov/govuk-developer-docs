---
owner_slack: "#govuk-2ndline"
title: Manage email subscribers (change email, unsubscribe, move lists)
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-05-03
review_in: 6 months
---

The following rake tasks should be run using the Jenkins `Run rake task` job for ease-of-use:

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
