---
owner_slack: "#govuk-developers"
title: Help with publishing high priority content
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-03-13
review_in: 6 months
---

When a department is publishing content that is high priority, it may be
necessary to intervene to ensure it goes out as smoothly as possible.

### Checking the status of a document

To check the status of a document, there is a Rake task available in the
publishing-api that will check where the content is currently available.

```bash
$ bundle exec rake data_hygiene:document_status_check[content_id,locale]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=data_hygiene:document_status_check[content_id,locale])

### How to intervene ...

#### [If documents are published and links aren't updated][links]

You might see this happening if the format is still showing as "Coming Soon"
on some pages.

[links]: documents-are-published-but-links-arent-updated.html

#### [If the cache (our Varnish or Fastly CDN) needs clearing][cache]

You may need to do this if the content is not showing on the live site quick
enough.

[cache]: cache-flush.html

#### [If guidance pages are expected to show on taxon pages but aren't][search]

The guidance pages visible on topic pages like
[/government/brexit](https://www.gov.uk/government/brexit) are populated based
on search ranking, which is only updated over night, so it may be necessary to
set it manually.

[search]: manually-setting-search-popularity-of-content.html
