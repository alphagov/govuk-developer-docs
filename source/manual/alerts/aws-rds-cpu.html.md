---
owner_slack: "#govuk-2ndline"
title: AWS RDS Instance CPU Utilization
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-03-19
review_in: 6 months
---

This alert relates to the AWS relational database service (RDS) CPU Utilization. We use RDS to run both PostgreSQL and MySQL databases in AWS.
We use db-admin machines as jumpboxes to connect to the RDS instances via a database client application. There are a number of db-admin machines for various RDS instances.
There are two ways to check the current usage:
1. - Access the AWS web console and view the statistics.
2. - Access a "db-admin" instance via SSH and access the database console. Then you should be able to view the current queries in action.
