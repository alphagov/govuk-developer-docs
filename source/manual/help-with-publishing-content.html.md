---
owner_slack: "#govuk-developers"
title: Help with publishing content
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-03-13
review_in: 6 months
---

When a department is publishing content that is high priority, it may be
necessary to intervene to ensure it goes out as smoothly as possible.

### [If documents aren't live after being published][live]

If a publisher is complaining that a document isn't live on GOV.UK after
publishing it.

[live]: documents-arent-live-after-publishing.html

### [If documents are published but links aren't updated][links]

You might see this happening if the format is still showing as "Coming Soon"
on some pages.

[links]: documents-are-published-but-links-arent-updated.html

### [If the cache (our Varnish or Fastly CDN) needs clearing][cache]

You may need to do this if the content is not showing on the live site quick
enough.

[cache]: cache-flush.html

### [If guidance pages are expected to show on taxon pages but aren't][search]

The guidance pages visible on topic pages like
[/government/brexit](https://www.gov.uk/government/brexit) are populated based
on search ranking, which is only updated over night, so it may be necessary to
set it manually.

[search]: manually-setting-search-popularity-of-content.html

### If emails haven't been sent for a published document

If it looks as though emails haven't been sent out for a publication, there
should be [an alert about unprocessed content changes and there is guidance on
how to solve this](alerts/email-alert-api-app-healthcheck-not-ok.html#unprocessed-content-changes-content_changes).

If there are no alerts, it would suggest that the content change never made it
to the Email Alert API. In which case, you should [check that Email Alert
Service is correctly consuming from RabbitMQ](alerts/rabbitmq-no-consumers-consuming.html).
If all looks fine, it may be necessary to [manually create a `ContentChange` in
Email Alert API](https://github.com/alphagov/email-alert-api/blob/1aee9703bf303d43ba4ecb5f6fd771b757d52daf/app/services/notification_handler_service.rb#L24-L43).

We have an alert that checks that email alerts for Travel Advice and Medical
Safety Alerts go out correctly. Although an alert won't be triggered for other
kinds of documents, the [guidance will still apply](alerts/email-alerts.html).

### [If scheduled publications haven't gone out][scheduled]

If a scheduled publication hasn't gone out, you should start by following the
instructions for [if documents aren't live after being published][live]. If it
looks as though the content was never published from Whitehall, there is a
Rake task available which will publish overdue documents.

```bash
$ bundle exec rake publishing:overdue:publish
```

[Run this job in production Jenkins ⚠️](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:publish)

[scheduled]: alerts/whitehall-scheduled-publishing.html

### [If a document needs force publishing and bypassing queues]

If there are a lot of items in the high priority queue, the usual process of moving an urgent item to that queue won't have the desired effect. Bypassing queues should only be done in extreme cases where content has to be published asap (travel advice).

* SSH into the publishing_api machine
* Open an app console for the Publishing API
* Find the appropriate document/edition
* Run the workers [here](https://github.com/alphagov/publishing-api/blob/793fb5888694117e9a7ee0c23d174d40d3a3d07d/app/commands/v2/represent_downstream.rb#L20-L53) synchronously depending on whether you want to update live or draft

For example:

```
DownstreamLiveWorker.new.perform(
  content_id: content_id,
  locale: locale,
  message_queue_event_type: "links",
  update_dependencies: false,
)
```