---
owner_slack: "#govuk-2ndline"
title: How to use Logit for GOV.UK
section: Logging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-01-03
review_in: 6 months
---

## How GOV.UK use Logit

GOV.UK use [Logit](https://logit.io) to provide our
[ELK Stack](https://www.elastic.co/webinars/introduction-elk-stack).

This is in line with [The GDS Way](https://gds-way.cloudapps.digital/) guidance
on [logging](https://gds-way.cloudapps.digital/standards/logging.html).

## If Logit is down

If there is a problem with Logit you should report it by following the
instructions in the Reliability Engineering manual for [reporting an incident](https://reliability-engineering.cloudapps.digital/logging.html#logit-incident-management).

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
