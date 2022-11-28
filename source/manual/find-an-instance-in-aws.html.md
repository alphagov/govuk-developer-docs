---
owner_slack: "#govuk-2ndline-tech"
title: Identify an EC2 instance in AWS
section: 2nd line
layout: manual_layout
parent: "/manual.html"
---

Sometimes you may have references (in logs or in a [locksmith log file](/manual/alerts/rebooting-machines.html#checking-locking-status)) to an EC2 instance by its internal name (for example ip-10-13-4-254.eu-west-1.compute.internal), and need to work out what it is.

The numbers after IP are the internal IP address in AWS, which will allow you to narrow down where it should be:

1. You can tell which environment it's in by looking at the first two octets of the IP (because we use /16s for environments) - production uses 10.13.0.0/16
2. You can tell which subnet it's in by the first three octets of it's IP address. 10.13.4.0/24 is govuk_private_a. You can find details for the subnets in all enviroments by looking in [govuk-aws-data](https://github.com/alphagov/govuk-aws-data/tree/main/data/infra-networking).
3. Not everything that gets a private IP address is an Ec2 instance - things like NAT gateways and RDS instances get them too (although RDS instances have their own subnet, so they won't be in `govuk_private_{a,b,c}`)
4. Searching in Network Interfaces should get them all, and you can search by a particular subnet - e.g. https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#NIC:v=3;subnetId=subnet-0e44c1f27dbaf5af7;sort=desc:privateIpAddress
5. Amazon reserves the first four (4) IP addresses and the last one (1) IP address of every subnet for IP networking purposes.

If after this you can't find the machine, it's possible that it has been terminated.
