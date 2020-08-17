---
owner_slack: "#govuk-developers"
title: Grafana Dashboards
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert means there are dashboards that exist only in the database of a single Grafana instance.

> Sometimes a temporary dashboard is necessary to deal with an incident. In this case, you can acknowledge the alert temporarily until the incident concludes and we're confident we won't need it again.

First you need to find out who 'owns' the dashboard. The best place to do this is Slack. Once you've found an owner, you can point them to this documentation and acknowledge the alert temporarily.

## Keeping dashboards temporarily

Having too many temporary dashboards makes it harder to find the ones we need. **If the dashboard was temporary or experimental, you should include the word `TEMPORARY` in the title.**

Alternatively, you can [export your dashboard][grafana-export] and delete the original. This means you can import it again in the future and continue editing, ideally in a non-production environment.

## Keeping dashboards permanently

Dashboards that have longterm value should be moved into version control. We don't store backups of the Grafana database, so we risk losing them if the Grafana instance is destroyed.

> Before adding a new dashboard, think about whether you could improve an existing one.

We use [Puppet to provision dashboards][puppet-grafana] consistently across all environments. [Export your dashboard][grafana-export] and make a PR in govuk-puppet to add it alongside the existing ones.

> Use the 'View JSON' method to export your dashboard. Exporting the dashboard as a JSON file introduces placeholders that are not compatible with Puppet provisioning it automatically.

[grafana-export]: https://grafana.com/docs/grafana/latest/reference/export_import/#exporting-a-dashboard
[puppet-grafana]: https://github.com/alphagov/govuk-puppet/tree/master/modules/grafana/files/dashboards
