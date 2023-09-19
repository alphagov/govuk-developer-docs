---
owner_slack: "#govuk-2ndline-tech"
title: AWS RDS Instance CPU Utilization
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert relates to the AWS relational database service (RDS) CPU Utilization being higher than we would expect. We use RDS to run both PostgreSQL and MySQL databases in AWS.

We use `db-admin` machines as a way of connecting to the RDS instances via a database client application. There are a number of `db-admin` machines for various RDS instances.

 Check the current usage:

[Access the AWS web console][] and view the statistics. These are available under Amazon RDS ➡ Databases ➡ your-database-name ➡ Monitoring.

[Access the AWS web console]: https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1
