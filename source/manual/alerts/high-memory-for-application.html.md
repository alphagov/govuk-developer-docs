---
owner_slack: "#2ndline"
title: High memory for application
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-05-17
review_in: 6 months
---

This alert triggers when the application process uses too much memory.

For more info, you can also read [the page for the alert that triggers
when a machine is out of memory][mem].

[mem]: /manual/alerts/free-memory-warning-on-backend.html

## Fix memory leaks

A common cause of the alerts are memory leaks. For Rails applications you
can try diagnosing the error with [the derailed gem][derailed].

[derailed]: https://github.com/schneems/derailed_benchmarks

## Restart the application

If you can't find the source of the memory leak you can [restart the application](/manual/restart-application.html).

## Increase the alerting threshold

Sometimes the alerting thresholds are too low. You can change them in
[common.yml][common]

```yml
govuk::apps::the_warning::nagios_memory_warning: 2500
govuk::apps::the_warning::nagios_memory_critical: 2500
```

[common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
