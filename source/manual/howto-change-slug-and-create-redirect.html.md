---
owner_slack: "#govuk-developers"
title: Change a slug and create redirect in Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-01
review_in: 6 months
---

### Change a slug and create redirect in Whitehall

#### Whitehall

A Rake Tasks exists in Whitehall to quickly change the slug of a Document. It also reindexes the Document with its new slug, republishes the document to Publishing API, which automatically handles the redirect.

The task takes the Document's old slug and the Document's new slug.

```bash
$ bundle exec 'reslug:document[old_slug,new_slug]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=%27reslug:document[old_slug,new_slug]%27)


> This rake task also works for Person, Role, PolicyGroup, Organisation, WorldOrganisation and WorldLocation.
For example: `reslug:world_location[old_slug,new_slug]`

#### Issues

If you run the task and find the redirect has worked, but the new location returns a 404, it's likely because the republish command is languishing in the low-priority queue ([check queue volumes in Grafana](https://grafana.publishing.service.gov.uk/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=publishing-api&var-Queues=All&from=now-30m&to=now). Whitehall appears to put the redirect in the high priority queue, so there can be a delay between the redirect being applied and the content being republished.

This should resolve itself over time, but if you need to process the content change more quickly, run a rake task to put it in the high priority queue:

* TARGET_APPLICATION: `publishing-api`
* MACHINE_CLASS: `publishing_api`
* RAKE_TASK: `represent_downstream:high_priority:content_id[CONTENT_ID]` (for example, `represent_downstream:high_priority:content_id[5d63bf56-7631-11e4-a3cb-005056011aef]`)
