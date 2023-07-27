---
owner_slack: "#govuk-publishing-platform"
title: Debug published documents with incorrect links
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

This can happen when the Publishing API is still working through all of the
pages that may have changed due to dependency resolution. You can find out if
this is a problem [by monitoring Publishing API sidekiq queue][sidekiq-queue]
and seeing if the `downstream_low` queue is high.

To get things processed faster you can run the following Rake task on the
Publishing API `represent_downstream:high_priority:content_id['some-content-id some-other-content-id']`,
which will re-represent them downstream via the high priority queue.

[sidekiq-queue]: /manual/sidekiq.html#sidekiq-web-aka-sidekiq-monitoring
