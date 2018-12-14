---
owner_slack: "#govuk-2ndline"
title: cannot ping across AWS-Carrenza VPN
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-12-13
review_in: 6 months
---

There is a VPN tunnel between AWS and Carrenza for both the Staging and
Production environment.

To check the status and obtain troubleshooting information about the VPN,
please consult the document
[here](https://docs.publishing.service.gov.uk/manual/vpn.html)

If the VPN is up/active and the ping probes are failing, check the following:

1. the security groups of the AWS EC2 instances allow ping packets, i.e. ICMP
   packets

2. the firewall in the vCloud in Carrenza allows ping packets

3. the VPN routes have been propagated to the subnet of the AWS EC2 instances

4. in the Carrenza vCloud Graphical User Interface (GUI), check that the subnet
   of the VPN includes the Carrenza endpoint that is being pinged.
