---
owner_slack: "#2ndline"
title: How to use Logit for GOV.UK
section: Logging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-02
review_in: 6 months
---

## How GOV.UK use Logit

GOV.UK use [Logit](https://logit.io) to provide our [ELK Stack](https://www.elastic.co/webinars/introduction-elk-stack).

This is in line with [The GDS Way](https://gds-way.cloudapps.digital/) guidance
on [logging](https://gds-way.cloudapps.digital/standards/logging.html).

## Logging in to Logit

We use a Google App to authenticate users with Logit. Login to your GDS Google account in Chrome and from within any Google App (e.g. [GMail](https://mail.google.com)), click on the 9 small dots at the top right of the Chrome browser.

Note that the App doesn't seem to be in the list if you click the 9 small dots at the top right of a new/blank tab, even if you are signed into Chrome with your GDS Google account.

Scroll down the list of Apps (clicking "More" if necessary) and you should find the Logit App.

Clicking on this should log you in.

### Adding your user to the right team

After you have logged in, if you are unable to see any "stacks", please speak to
a GOV.UK Logit administrator. This will normally be your Tech Lead, or a member of
the Infrastructure team.

## Viewing Kibana

Click on the "Kibana" button next to the stack you wish to view.

When you are viewing a Kibana instance for a specific stack, if you open any direct
links externally they will take you to this stack.

At present we are unable to link directly to a stack, or view multiple stacks
at the same time. This is on the Logit roadmap.

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
