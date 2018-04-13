---
owner_slack: "#2ndline"
title: Manage email subscribers using email-alert-api rake tasks
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-13
review_in: 6 months
---

The following rake tasks should be run using the Jenkins `Run rake task` job for ease-of-use, in which case the `bundle exec rake` prefix should be omitted.

## Change a subscriber's email address

```shell
$ bundle exec rake manage:change_email_address[<old email address>, <new_email_address>]
```

## Unsubscribe a subscriber from all emails

```shell
$ bundle exec rake manage:unsubscribe_single[<email address>]
```

## Unsubscribe a list of subscribers from all emails in bulk

> **Note**
> The CSV file should contain email addresses in the first column. All other data will be ignored.

```shell
$ bundle exec rake manage:unsubscribe_bulk_from_csv[<path to CSV file>]
```

## Move all subscribers from one list to another

This is useful for changes such as departmental name changes, where new lists are created but subscribers should continue to receive emails.

```shell
$ bundle exec rake manage:move_all_subscribers[<slug of old list>, <slug of new list>]
```
