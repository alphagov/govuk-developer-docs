---
title: Switch an app off
layout: manual_layout
section: Packaging
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/howto-switch-off-app.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/howto-switch-off-app.md)


# Switch an app off

In the event of a security incident an app may need to be switched off until it
can be patched.

Stop puppet from running on the relevant machines

```
fab $environment node_type:frontend puppet.disable
```

Stop the app on the relevant machines::

```
fab $environment node_type:frontend app.stop:designprinciples
```
