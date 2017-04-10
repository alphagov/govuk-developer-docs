---
title: Performance Platform
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/performance-platform.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/performance-platform.md)


# Performance Platform

Performance platform is now hosted on gov.uk infrastructure. There is
still some useful information in [the pp
manual](https://github.gds/pages/gds/pp-manual/), but we will try and
move as much as possible to the opsmanual

## Publishing Dashboards

There is a fabric task to publish dashboards, as this is not built into
the admin interface yet. To publish a dashboard, you will need the
dashboard slug -the part after `/performance/`{.sourceCode}. Once you
have this, you can run the task

``` {.sourceCode .shell}
fab $environment performanceplatform.publish_dashboard:<slug>
```

