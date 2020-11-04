---
owner_slack: "#govuk-developers"
title: Help with publishing content
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

When a department is publishing content that is high priority, it may be
necessary to help them to ensure it goes out as smoothly as possible.

- [Read what to do][live] if a publisher is complaining that a document
  isn't live on GOV.UK after publishing it.

[live]: documents-arent-live-after-publishing.html

- You might see [documents being published but links not
  updating][links] if the format is still showing as "Coming Soon" on
  some pages.

[links]: documents-are-published-but-links-arent-updated.html

- You may need to [clear the Varnish or Fastly caches][cache] if the
  content is not showing on the live site quick enough.

[cache]: purge-cache.html

- If it looks as though emails haven't been sent out for a publication, there
  should be [an alert about unprocessed content changes and there is guidance on
  how to solve this](alerts/email-alert-api-unprocessed-content-changes.html).

  If there are no alerts, it would suggest that the content change never made it
  to the Email Alert API. In which case, you should [check that Email Alert
  Service is correctly consuming from RabbitMQ](alerts/rabbitmq-no-consumers-listening.html).
  If all looks fine, it may be necessary to [manually create a `ContentChange` in
  Email Alert API](https://github.com/alphagov/email-alert-api/blob/1aee9703bf303d43ba4ecb5f6fd771b757d52daf/app/services/notification_handler_service.rb#L24-L43).

  We have an alert that checks that email alerts for Travel Advice and Medical
  Safety Alerts go out correctly. Although an alert won't be triggered for other
  kinds of documents, the [guidance will still apply](alerts/email-alerts-travel-medical.html).

- If [a scheduled publication hasn't gone live](alerts/whitehall-scheduled-publishing.html),
  start here: [if documents aren't live after being published][live].
  If it looks as though the content was never published from
  Whitehall, there is a Rake task available which will publish overdue
  documents. In Production, run [this Rake
  task](https://deploy.blue.production.govuk.digital//job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:publish).

  ```bash
  $ bundle exec rake publishing:overdue:publish
  ```
