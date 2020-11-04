---
owner_slack: "#govuk-2ndline"
title: High memory for application
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert triggers when the application process uses too much memory. If this
alert triggers either with a warning or critical state then Icinga is
configured to automatically restart the application, the command that is run is
[here][restart_script].

For more info, you can also read [the page for the alert that triggers
when a machine is out of memory][mem].

[mem]: /manual/alerts/free-memory-warning-on-backend.html
[restart_script]: https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/files/usr/local/bin/event_handlers/govuk_app_high_memory.sh

## Fix memory leaks

A common cause of the alerts are memory leaks. For Rails applications you
can try diagnosing the error with [the derailed gem].

[the derailed gem]: https://github.com/schneems/derailed_benchmarks

## Restart the application

If you can't find the source of the memory leak you can
[restart the application](/manual/restart-application.html).

## Increase the alerting threshold

Each application has it's own thresholds and sometimes these can be too low
which can cause an app getting into a cycle of constant restarting. You can
change them in [hieradata_aws/common.yaml][aws_common] or
[hieradata/common.yaml][common].

```yaml
govuk::apps::the_warning::nagios_memory_warning: 2500
govuk::apps::the_warning::nagios_memory_critical: 2500
```

An example of upping the thresholds can be found [here][static_nagios_memory].

[aws_common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml
[common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
[static_nagios_memory]: https://github.com/alphagov/govuk-puppet/pull/8755
