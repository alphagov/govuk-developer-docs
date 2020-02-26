---
owner_slack: "#govuk-developers"
title: Use Logit for GOV.UK
section: Logging
layout: manual_layout
parent: "/manual.html"
---

## How GOV.UK use Logit

GOV.UK use [Logit](https://logit.io) to provide our
[ELK Stack](https://www.elastic.co/webinars/introduction-elk-stack).

This is in line with [The GDS Way](https://gds-way.cloudapps.digital/) guidance
on [logging](https://gds-way.cloudapps.digital/standards/logging.html).

## If Logit is down

If there is a problem with Logit you should report it by following the
instructions in the Reliability Engineering manual for [reporting an incident](https://reliability-engineering.cloudapps.digital/logging.html#logit-incident-management).

## If Logit's data falls off a cliff

If there seems to be no recent data in Logit when there really should be, you can try "restarting" the logstash instance.

You can get an visual indication of logs sent by navigating to the "Settings" for an environment and then looking at the "Statistics". If no logs are coming in, then this might indicate a restart is required.

Navigate to the Logit dashboard and select the "Settings" button next to the environment that is experiencing issues. Next select "Logstash Filters" in the left hand menu. The "Restart Logstash" button is in the "Danger Zone".

When we experienced this on 04/03/2019, the Logstash logs for our Staging environment reported the following error repeatedly:

```
Exception: io.netty.util.internal.OutOfDirectMemoryError: failed to allocate 16777216 byte(s) of direct memory
```

> If you don't have Settings option, speak to your tech lead/lead developer who will hopefully be able to help.

## Accessing Logit

You can [access Logit](https://reliability-engineering.cloudapps.digital/logging.html#get-started-with-logit) by following the instructions in the Reliability Engineering manual.

Logit stores the last environment you visited in a session. If you open any
direct links externally they will take you to this stack.

### Adding your user to the right team

If you are unable to see any logs, please speak to a GOV.UK Logit administrator.
This will normally be your Tech Lead.

## Administration guide

### Adding users to GOV.UK Stacks

1. Go to "People", and click "Manage".
2. Click "Teams", then "Assign members" on the "GOV.UK" team.
3. Add the new members of the team, and click "Update team members".

### Updating Logstash configuration

At present there is no automated way to configure Logstash configuration.

1. Click the "Settings" button next to the stack you wish to configure.
2. Go to "Logstash Filters"
3. Amend the configuration
4. Click "Validate"
5. If correctly validated, click "Apply"

We store our configuration in the [govuk-saas-config](https://github.com/alphagov/govuk-saas-config)
repository. Any changes to the configuration should be stored in here, and they
should be consistent across stacks.
