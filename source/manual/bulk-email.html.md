---
owner_slack: "#govuk-notifications"
title: Send a bulk email
section: Emails
layout: manual_layout
parent: "/manual.html"
related_applications: [email-alert-api]
---

Sometimes it may be necessary to send a bulk email to many subscribers at once.
There is [a Rake task in email-alert-api][rake-task] to peform this task and
it's [available as a job in Jenkins][send-bulk-production].

[rake-task]: https://github.com/alphagov/email-alert-api/blob/3a3eaaa59e71e03427021ba730c626ecdf107ccd/lib/tasks/bulk.rake#L2-L9

## 1. Prepare the content

The format for the body text is [a limited subset of markdown][notify-markdown]. A footer will be automatically appended to the specified body text. The footer will have links to unsubscribe and manage subscriptions. We should always provide users with these options, to help avoid our emails being marked as spam.

Any occurrence of `%LISTURL%` in the body text will be substituted with the URL of the subscriber list, or an empty string if it has none. This is useful when sending the same email across many lists, where the content of the email needs to link to the specific page on GOV.UK associated with the list. You should check the lists you want to send a bulk email for, to see if they have a URL populated (it's a recent addition).

[notify-markdown]: https://www.notifications.service.gov.uk/using-notify/guidance/edit-and-format-messages

## 2. Get the subscriber lists

Next you'll need to get the IDs of all the subscriber lists to send the email
out to. This will require querying the email-alert-api `SubscriberList` model.

For example, to get the IDs of all the subscriber lists for travel advice, you
could use the following query:

```rb
> SubscriberList.where("links->'countries' IS NOT NULL").pluck(:id)
```

## 3. Send a test email

Use [the Send bulk emails job in Staging][send-bulk-staging] to send the email.

**Make sure you know [how to receive emails in Staging][staging-emails].**

[send-bulk-staging]: https://deploy.blue.staging.govuk.digital/job/send-bulk-email/
[staging-emails]: /manual/receiving-emails-from-email-alert-api-in-integration-and-staging.html

## 4. Send the real email

Use [the Send bulk emails job in Production][send-bulk-production] to send the email.

[send-bulk-production]: https://deploy.blue.production.govuk.digital/job/send-bulk-email/
