---
owner_slack: "#govuk-2ndline"
title: More items scheduled for publication than in queue for publisher
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert means that the number of editions in the publisher database
which are scheduled to be published in the future is different from
the number currently in the Sidekiq queue.

This can happen in Staging and Integration as a result of the data
sync from Production. Run this rake task to re-queue all scheduled
editions:

```sh
$ cd /var/apps/publisher
$ sudo -u deploy govuk_setenv publisher bundle exec rake editions:requeue_scheduled_for_publishing
```

- [Run in Integration Jenkins](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=publisher&MACHINE_CLASS=backend&RAKE_TASK=editions:requeue_scheduled_for_publishing)

- [Run in Staging Jenkins](https://deploy.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=publisher&MACHINE_CLASS=backend&RAKE_TASK=editions:requeue_scheduled_for_publishing)
