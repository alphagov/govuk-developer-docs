---
owner_slack: "#re-govuk"
title: Node classes without redundancy
layout: manual_layout
parent: "/manual.html"
section: Applications
important: true
last_reviewed_on: 2019-07-29
review_in: 6 months
---

Below we provide a list of node classes that are not configured to be highly available (HA). This means, that short outages of these machines are architecturally considered acceptable. Recently, the installation of a critical software componenent on a non-redundant node class did cause an incident.

The situation in question involved pgbouncer, required for all Postgresql database accesses at the time, to be installed on the db-admin machines. Because the architectural design anticipated machines of the db-admin node class to be used as jumpboxes for administrative database access only, a high load introduced on a database created a Postgresql outage for GOV.UK.

When adding new services and applications to GOV.UK, please be aware that machines of the node classes below are considered non-critical to the operation of the platform. If you require your service to be highly available (HA), please consider deployment to another node class or contact RE GOV.UK to create a dedicated infrastructure solution if necessary.

- db-admin
- transition-db-admin
- content-data-api-db-admin
- asset-master
- jumpbox (In AWS, only - There exist two in the Carrenza environments)
- ckan
- apt
- mirrorer
