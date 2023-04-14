---
owner_slack: "#govuk-publishing-platform"
title: If documents aren't live after being published
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

If a document isn't live on GOV.UK after a publisher has published the document
it may mean that it's got stuck somewhere.

## Checking the status of a document

To check the status of a document, there is a Rake task available in the
Publishing API that will check where the content is currently available.

```bash
$ bundle exec rake data_hygiene:document_status_check[content_id,locale]
```

## If documents aren't in the Publishing API

This likely means that the publishing app itself failed to send the document
correctly to the Publishing API. These fix here varies per publishing app, but
you can start by trying to republish the document from within the user
interface. If that doesn't work, there are some other things you can try:

### Whitehall

```bash
$ bundle exec rake publishing_api:republish_document[slug]
```

### Publisher

```bash
$ bundle exec rake publishing_api:republish_edition[slug]
```

### Travel Advice Publisher

```bash
$ bundle exec rake publishing_api:republish_edition[country_slug]
```

### Specialist Publisher

The datastore for Specialist Publisher is the Publishing API directly.
Therefore if the content isn't in the Publishing API, it means the content will
also not be in Specialist Publisher and need redrafting.

## If documents aren't in the Content Store

There is a Rake task available in the Publishing API that will represent the
content item to the Content Store.

```bash
$ bundle exec rake represent_downstream:high_priority:content_id[content_id]
```

> WARNING: this task might publish draft content to the live content store. Use with caution.
> See [this 'ongoing issues' card for more details](https://trello.com/c/bfAEuv4S/1576-consider-improving-documentation-on-the-consequences-of-running-representdownstream-rake-task-on-publishing-api).

Note that if you run this task to fix missing routes, it may not work correctly
as the Content Store keeps a cache of what it thinks the routes are.

## If routes aren't in the Router

There is a Rake task available in the Content Store that will register the
routes for a Content Item directly.

```bash
$ bundle exec rake routes:register[base_path]
```

## If the document isn't live after all this

If the document appears to be correct in all these places, it may just be
necessary to [clear the cache](purge-cache.html) for that document. 404 pages
will be cached, although with a shorter expiration time, so if a publisher
tries to view the page before it's live, they may end up caching the 404 page.
