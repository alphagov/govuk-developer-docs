---
owner_slack: "#govuk-2ndline"
title: Free memory warning on backend
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert is often caused by an application slowly leaking memory, which
isn't usually an issue for apps that are deployed/restarted frequently.
Some less frequently deployed apps will continue to grow over time.

For more info, you can also read [the page for the alert that triggers
when a application uses too much memory][high-memory].

[high-memory]: /manual/alerts/high-memory-for-application.html

### Investigation of the problem

Check [Graphite][graphite-memory] to see which apps are consuming a lot of
memory, and are growing over time.

You could also try using `htop` and sorting by memory to locate high memory
usage, though this won't identify creeping memory leaks in the same way
Graphite will.

Identify if the service is being run under Unicorn or not. Unicorn worker
processes can be killed and automatically respawned if they consume too much
memory.

[graphite-memory]: https://graphite.publishing.service.gov.uk/render/?width=1133&height=630&_salt=1413553577.366&from=-24days&hideLegend=false&target=highestAverage%28backend-1_backend.processes-*.ps_rss%2C5%29

### Kill memory leaking Unicorn workers

Once you've identified a Unicorn application with a memory leak, you can
gracefully kill a Unicorn worker to reclaim some memory. Sending a `SIGQUIT` to
the worker causes it to finish serving its current request then exit, the
master will notice this and spawn a fresh worker. This Fabric task will kill
the worker using the most memory:

```sh
$ fab $environment -H backend-1.backend app.respawn_large_unicorns:APP-NAME
```

This will only kill the most bloated Unicorn worker, so you may need to run
it multiple times if the alert persists.

### Restart other memory leaking apps

For leaky applications not managed by Unicorn (for example, Whitehall's
Sidekiq worker), restart it to reset the memory usage, and increase free memory
on the host:

```sh
$ fab $environment -H whitehall-backend-1.backend app.restart:whitehall-admin-procfile-worker
```
