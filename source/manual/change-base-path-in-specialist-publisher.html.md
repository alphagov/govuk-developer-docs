---
owner_slack: "#govuk-developers"
title: Change a specialist document base path
parent: "/manual.html"
layout: manual_layout
section: Publishing
---

In [Specialist Publisher](https://specialist-publisher.publishing.service.gov.uk/), the base path is automatically generated based on the title when the specialist document is first created. We sometimes receive Zendesk tickets to change a base path when the title has been updated, as the publisher does not have the ability to do this.

You can use the Jenkins rake task runner to run the task:

[`base_path:edit[content_id,/new_base_path]`](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=specialist-publisher&MACHINE_CLASS=backend&RAKE_TASK=base_path:edit[content_id,/new_base_path])

> You can find the `content_id` of the document using the [govuk-toolkit](https://github.com/alphagov/govuk-browser-extension) browser extension.

**NOTE**: the rake task will only change the slug for the latest draft (creating a new draft
if necessary). For the change to be permanent, you need to publish the draft, which you can
either do in the Specialist Publisher UI or by using the CLI:

```sh
local$      gds govuk connect -e production ssh backend

production$ govuk_app_console specialist-publisher

rails$      Document.find('content_id-of-the-document').publish
```
