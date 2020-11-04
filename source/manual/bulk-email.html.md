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

First you'll need to get access to the subject and the body of the email. The
format for the subject is plain text and for the body it is
[a limited subset of markdown][notify-markdown].

Note that the final email won't include any subscription information, so that
should be included in the body of the email itself. An example could be:

```md
You’re getting this email because you subscribed to updates from Travel Advice on GOV.UK.

[View, unsubscribe or change the frequency of your subscriptions](https://www.gov.uk/email/manage)
```

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

Once you've got the content and the subscriber lists for the email, you can use
staging to send out a test email. First make sure that you have subscribed to
one of the subscriber lists and then use [the Send bulk emails job in
staging][send-bulk-staging] to send the email.

**Make sure you are [able to receive emails in staging][staging-emails].**

[send-bulk-staging]: https://deploy.blue.staging.govuk.digital/job/send-bulk-email/
[staging-emails]: /manual/receiving-emails-from-email-alert-api-in-integration-and-staging.html

## 4. Send the real email

If the test email works and looks good, it's time to send the real email! You
can copy the parameters used in staging and [run the same job in
production][send-bulk-production].

[send-bulk-production]: https://deploy.blue.production.govuk.digital/job/send-bulk-email/

## 5. Monitor the queues

It may be useful to [monitor the Sidekiq queues of email-alert-api][sidekiq] to
look at the progress of the email and estimate how long it will take. Note that
the emails from the bulk task end up on the `default` queue meaning that they
are the lowest priority of email.

At the time of writing, an email to all travel advice subscribers (~560,000
subscribers) takes around 4-5 hours to send to everyone.

[sidekiq]: /manual/sidekiq.html
