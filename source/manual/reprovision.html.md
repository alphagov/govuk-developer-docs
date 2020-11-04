---
owner_slack: "#re-govuk"
title: Reprovision a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

Make sure you are aware what the consequences will be of removing a
machine from the rotation and consider who needs to be aware of
potential downtime. In particular, removing a single-point-of-failure
machine will result in downtime.

## AWS

1. Log into the AWS console, select the correct environment and go to the EC2 service
2. Locate the instance and confirm it's the correct one by either instance ID or private IP address
3. Select Terminate from the Actions -> Instance State menu
4. The AWS Auto Scaling Group will reprovision the instance automatically
