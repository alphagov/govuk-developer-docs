---
owner_slack: "#re-govuk"
title: Cannot ping across AWS-Carrenza VPN
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

There is a VPN tunnel between AWS and Carrenza for both the Staging and
Production environment.

You can [check the status and troubleshoot the VPN](https://docs.publishing.service.gov.uk/manual/vpn.html).

If the VPN is up/active and the ping probes are failing, check the following:

1. The security groups of the AWS EC2 instances allow ping packets, i.e. ICMP
   packets

2. The firewall in the vCloud in Carrenza allows ping packets

3. The VPN routes have been propagated to the subnet of the AWS EC2 instances

4. In the Carrenza vCloud Graphical User Interface (GUI), check that the subnet
   of the VPN includes the Carrenza endpoint that is being pinged.
