---
owner_slack: "#govuk-2ndline"
title: GOV.UK and Virtual Private Networks (VPNs)
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-07
review_in: 6 months
---

GOV.UK uses several VPNs to connect environments. This page explains what they
are and what happens if they stop working.

## VPN between live organisation and disaster recovery organisation

There's a VPN in each Carrenza environment (currently staging and production) which connects
the live organisation to the disaster recovery organisation. It's used for monitoring
the disaster recovery machines and for syncing data to them. The VPNs are managed by Carrenza.

If it goes down, these things will happen:

1. The machines on the disaster recovery side of the connection will appear as
   unreachable hosts in GOV.UK monitoring
2. Data replication will pause

## VPN between live organisation and Licensing

Licensing is hosted in Skyscape.
There's a VPN in each environment which connects it to the live (Carrenza) organisation. The VPN
is managed by Carrenza and Skyscape.

If it goes down, these things will happen:

1. The machines on the disaster recovery (Skyscape) side of the connection will appear as
   unreachable hosts in GOV.UK monitoring

Applying for a licence should remain available because
the connection between GOV.UK (the router and content store) and the Licensify organisation is made
over the internet rather than over the VPN.

[carrenza-secure]: https://github.com/alphagov/govuk-legacy-opsmanual/blob/master/infrastructure/howto/connect-carrenza-il2.rst
[gds-vpn]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/how-to/connect-to-the-aviation-house-vpn
