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

### Checking the status of a document

To check the status of a document, there is a Rake task available in the
Publishing API that will check where the content is currently available.

```bash
$ bundle exec rake data_hygiene:document_status_check[content_id,locale]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=data_hygiene:document_status_check[content_id,locale])

### How to intervene ...

#### If documents aren't in the Publishing API

This likely means that the publishing app itself failed to send the document
correctly to the Publishing API. These fix here varies per publishing app, but
you can start by trying to republish the document from within the user
interface. If that doesn't work, there are some other things you can try:

##### Whitehall

```bash
$ bundle exec rake publishing_api:republish_document[slug]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_document[slug])

##### Publisher

```bash
$ bundle exec rake publishing_api:republish_edition[slug]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish_edition[slug])

##### Travel Advice Publisher

```bash
$ bundle exec rake publishing_api:republish_edition[country_slug]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish_edition[country_slug])

##### Specialist Publisher

The datastore for Specialist Publisher is the Publishing API directly.
Therefore if the content isn't in the Publishing API, it means the content will
also not be in Specialist Publisher and need redrafting.

#### If documents aren't in the Content Store

There is a Rake task available in the Publishing API that will represent the
content item to the Content Store.

```bash
$ bundle exec rake represent_downstream:high_priority:content_id[content_id]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=represent_downstream:high_priority:content_id[content_id])

Note that if you run this task to fix missing routes, it may not work correctly
as the Content Store keeps a cache of what it thinks the routes are.

#### If routes aren't in the Router

There is a Rake task available in the Content Store that will register the
routes for a Content Item directly.

```bash
$ bundle exec rake routes:register[base_path]
```

[Run this job in production Jenkins](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-store&MACHINE_CLASS=content_store&RAKE_TASK=routes:register[base_path])

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
