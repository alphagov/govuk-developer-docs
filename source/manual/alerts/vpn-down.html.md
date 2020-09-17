---
owner_slack: "#govuk-2ndline"
title: VPN down
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

We use VPNs to connect between datacentres. Please see [GOV.UK and Virtual Private Networks (VPNs)](/manual/vpn.html) for details of the VPNs we have and a description of the impact of each VPN failing. These should appear as Icinga Alerts on the dashboards.

If a VPN is down, it is likely caused by a network issue due to a vendor incident or our own misconfiguration.

If no change has been made recently to our [network configuration](https://github.com/alphagov/govuk-provisioning), contact the vendors involved.

If the VPN connects one vendor to another, the problem could lie on either side, so open a ticket with each vendor.
