---
owner_slack: "#2ndline"
title: How to use Logit for GOV.UK
section: Logging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-12-21
review_in: 6 months
---

## How GOV.UK use Logit

GOV.UK use [Logit](https://logit.io) to provide our
[ELK Stack](https://www.elastic.co/webinars/introduction-elk-stack).

This is in line with [The GDS Way](https://gds-way.cloudapps.digital/) guidance
on [logging](https://gds-way.cloudapps.digital/standards/logging.html).

## Accessing Logit

You can access Logit by visiting
[kibana.publishing.service.gov.uk](https://kibana.publishing.service.gov.uk).
You will be prompted to log in with your GDS Google account if you're not
already logged in.

You can access logs for integration and staging too:

[kibana.integration.publishing.service.gov.uk](https://kibana.integration.publishing.service.gov.uk)

[kibana.staging.publishing.service.gov.uk](https://kibana.staging.publishing.service.gov.uk)

Logit stores the last environment you visited in a session. If you open any
direct links externally they will take you to this stack.

### Adding your user to the right team

If you are unable to see any logs, please speak to a GOV.UK Logit administrator.
This will normally be your Tech Lead, or a member of the Infrastructure team.

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
