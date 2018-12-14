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
please consult the document [here](yet_to_defined)

If the VPN is up/active and the ping probes are failing, check the following:
1. the security groups of the AWS EC2 instances allow ping packets, i.e. ICMP
   packets
2. the firewall in the vCloud in Carrenza allows ping packets
3. the VPN routes have been propagated to the subnet of the AWS EC2 instances
4. the subnet of the VPN in the Carrenza vCloud Graphical User Interface (GUI) is
   includes the Carrenza endpoint that is being pinged.
