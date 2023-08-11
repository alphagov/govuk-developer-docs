---
owner_slack: "#govuk-2ndline-tech"
title: AWS RDS Instance CPU Utilization
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# AWS RDS Instance CPU Utilization

This alert relates to the AWS relational database service (RDS) CPU Utilization being higher than we would expect. We use RDS to run both PostgreSQL and MySQL databases in AWS.

We use `db-admin` machines as a way of connecting to the RDS instances via a database client application. There are a number of `db-admin` machines for various RDS instances.

There are two ways to check the current usage:

The first is to [access the AWS web console][] and view the statistics. These are available under Amazon RDS ➡ Databases ➡ your-database-name ➡ Monitoring.

The second is to [access a `db-admin` instance][] via SSH and access the database console. Then you should be able to view the current queries in action.

[access the AWS web console]: https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1
[access a `db-admin` instance]: /manual/howto-ssh-to-machines.html
