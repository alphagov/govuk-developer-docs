---
owner_slack: "#govuk-developers"
title: Switch an app off temporarily
layout: manual_layout
section: Deployment
parent: "/manual.html"
---

In the event of a security incident an app may need to be switched off until it can be patched.

1. You'll need to identify on which machine class the application runs on.

1. Puppet must be disabled on the machines to prevent it automatically restarting the app:

   ```sh
   $ fab $environment node_type:frontend puppet.disable:"Reason for disabling Puppet"
   ```

1. Stop the application service on the relevant machines:

   ```sh
   $ fab $environment node_type:frontend app.stop:frontend
   ```
