---
owner_slack: "#govuk-2ndline-tech"
title: AWS RDS Instance Storage Utilization
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# AWS RDS Instance Storage Utilization

This alert relates to disk usage of our databases (RDS) in AWS being higher than we would expect. There are two ways to check the current usage.

- [Access the AWS web console][] and view the statistics.
- [Access the `db-admin` instance][] via SSH and access the database console. Then you should be able to view the current queries in action.

[Access the AWS web console]: https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1
[Access the `db-admin` instance]: /manual/howto-ssh-to-machines.html
