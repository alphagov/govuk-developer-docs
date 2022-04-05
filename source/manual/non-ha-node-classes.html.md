---
owner_slack: "#govuk-2ndline-tech"
title: Node classes without redundancy
layout: manual_layout
type: learn
parent: "/manual.html"
section: Applications
important: true
---

Below we provide a list of node classes that are not configured to be highly available (HA). This means that short outages of these machines are architecturally considered acceptable.

Installation of a critical software component on a non-redundant node class has caused an incident in the past. This happened when `pgbouncer`, required for all Postgresql database accesses at the time, was installed on `db_admin`, a single EC2 instance. That single instance became unavailable and took down Postgres in Production.

**Please do not install new services or applications on any of the following machines unless it's OK for your service to be down 5% of the time:**

- asset-master
- jumpbox
- ckan
- apt
- mirrorer
- licensing_backend
- db-admin or any of the \*-db-admin machines

If in doubt, please discuss your requirements with GOV.UK Platform Reliability (#govuk-platform-reliability-team on Slack).
