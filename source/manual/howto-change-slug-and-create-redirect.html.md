---
owner_slack: "#govuk-2ndline"
title: Change a slug and create redirect in Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-04-29
review_in: 6 months
---

### Change a slug and create redirect in Whitehall

##### Whitehall

A Rake Tasks exists in Whitehall to quickly change the slug of a Document. It also reindexes the Document with it's new slug, republishes the document to Publishing API, which automatically handles the redirect.

The task takes the Document's old slug and the Document's new slug.

```bash
$ bundle exec 'reslug:document[old_slug,new_slug]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=%27reslug:document[old_slug,new_slug]%27)


> This rake task also works for Person, Role, PolicyGroup, Organisation, WorldOrganisation and WorldLocation.
For example: `reslug:world_location[old_slug,new_slug]`
