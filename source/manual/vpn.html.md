---
owner_slack: "#govuk-2ndline-tech"
title: GOV.UK and Virtual Private Networks (VPNs)
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

## GOV.UK and Virtual Private Networks (VPNs)

As of 2023 GOV.UK does not currently use VPNs within its infrastructure. The only VPN you should encounter is the [GDS VPN][gds-vpn] which members of staff use to connect to the corporate network.

In the past, GOV.UK used VPNs to connect AWS with other service providers:

1. Between AWS and Carrenza (while infrastructure was migrated)
2. Between AWS and UK Cloud (to enable networking with Civica Payments, used by GOV.UK Licensing)

Both of these VPNs have now been retired - any alerts or documentation mentioning these VPNs is out of date.

[gds-vpn]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit
