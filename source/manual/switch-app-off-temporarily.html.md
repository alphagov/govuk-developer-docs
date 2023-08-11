---
owner_slack: "#govuk-developers"
title: Switch an app off temporarily
layout: manual_layout
section: Deployment
parent: "/manual.html"
---

# Switch an app off temporarily

In the event of a security incident an app may need to be switched off until it can be patched.

Before you begin you will need to identify:

- which machine class the application runs on
- how many machines of that class there are

See the [SSH into machines docs for more information](/manual/howto-ssh-to-machines.html#usage)

1. SSH into the first machine:

   ```bash
   gds govuk connect -e production ssh <machine_class>:<box_number>
   ```

2. Disable puppet on the machine to prevent it automatically restarting the app (provide a better reason if you can):

   ```
      sudo govuk_puppet --test --disable "Disabling puppet to prevent app restarting (by $USER)"
   ```

3. Stop the application service on the relevant machine

   ```
      sudo <app_name> stop
   ```

4. Repeat for other machines in the class until all have been disabled.
