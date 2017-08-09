---
owner_slack: "#2ndline"
title: GOV.UK and Virtual Private Networks (VPNs)
section: Monitoring
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/vpn.md"
last_reviewed_on: 2017-08-09
review_in: 6 months
---

GOV.UK uses several VPNs to connect environments. This page explains what they
are and what happens if they stop working.

## VPN between the GDS office and Carrenza

Monitoring for GOV.UK is restricted by IP address to the GDS office.
[Carrenza's secure vCloud Director environment][carrenza-secure]
is restricted to users with Carrenza VPN accounts.

GDS service desk have set up a site-to-site VPN between the GDS office and the
Carrenza datacentre. This exists for the case when:

1. There is an emergency out-of-hours, so the person responding is not in the office
2. They need access to GOV.UK monitoring
3. They need access to Carrenza's hosted vCloud Director

This site-to-site VPN means that when you're at home you can access both monitoring
and vCloud Director by connecting to the [normal GDS office VPN][gds-vpn].

If it breaks during office hours it's not a huge deal. If it breaks out-of-hours and
there is an emergency at the same time, we will only be able to connect to one of
either GOV.UK monitoring or vCloud Director at a time.

## VPN between live organisation and disaster recovery organisation

There's a VPN in each environment (integration, staging and production) which connects
the live organisation to the disaster recovery organisation. It's used for monitoring
the disaster recovery machines and for syncing data to them.

If it goes down, these things will happen:

1. The machines on the disaster recovery side of the connection will appear as
   unreachable hosts in GOV.UK monitoring
2. Data replication will pause

## VPN between live organisation and Licensing

Licensing is hosted in Skyscape.
There's a VPN in each environment which connects it to the live (Carrenza) organisation.

If it goes down, these things will happen:

1. The machines on the disaster recovery (Skyscape) side of the connection will appear as
   unreachable hosts in GOV.UK monitoring

Applying for a licence should remain available because
the connection between GOV.UK (the router and content store) and the Licensify organisation is made
over the internet rather than over the VPN.

[carrenza-secure]: howto/connect-carrenza-il2.html
[gds-vpn]: https://docs.google.com/document/d/1WRh-uBLP1XAKaytgRm5YX5DWUFHM3InZEB-xhoKzvqI/edit
