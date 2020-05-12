---
owner_slack: "#re-govuk"
title: AWS RDS Instance Memory Utilization
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert relates to memory usage of our database (RDS) instances in AWS.
There are two ways to check the current usage:

- Access the AWS web console and view the statistics.
- Access the `db-admin` instance via SSH and access the database console. Then
  you should be able to view the current queries in action.
