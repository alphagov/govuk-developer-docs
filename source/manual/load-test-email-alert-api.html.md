---
owner_slack: "#govuk-platform-health"
title: Load test Email Alert API
parent: "/manual.html"
layout: manual_layout
section: Emails
---

You may wish to load test Email Alert API to get a realistic idea of how the
system performs when it has a large quantity of emails to create and send.
This can be useful to provide data on where the system may have performance
bottlenecks.

To perform a load test you will need:

- A mechanism to artificially create a quantity of work for Email Alert API to
  do - we previously had a number of [rake tasks][] to allow this;
- An approach to simulate the delay of an actual request to Notify - we
  previously used a `Kernel.sleep(0.1)` to apply this.

When performing the test you should inform the [#govuk-2ndline][2nd-line-slack]
channel as they may see alerts during it.

[rake tasks]: https://github.com/alphagov/email-alert-api/pull/1494
[2nd-line-slack]: https://gds.slack.com/archives/CADKZN519
[clear-queues]: https://github.com/alphagov/email-alert-api/blob/17d54964063256a6769189bc5fd6d4cf61a9d40f/lib/tasks/load_testing.rake#L18-L21
