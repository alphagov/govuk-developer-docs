---
owner_slack: "#govuk-publishing-experience-tech"
title: More items scheduled for publication than in queue for publisher
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert means that the number of editions in the publisher database
which are scheduled to be published in the future is different from
the number currently in the Sidekiq queue.

This can happen in Staging and Integration as a result of the data
sync from Production. Run Publisher's `editions:requeue_scheduled_for_publishing`
rake task to re-queue all scheduled editions in Integration and Staging.
