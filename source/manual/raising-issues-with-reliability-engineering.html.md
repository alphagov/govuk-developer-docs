---
owner_slack: "#govuk-2ndline-tech"
title: Raise issues with Reliability Engineering
parent: "/manual.html"
layout: manual_layout
section: 2nd line
---

When on 2nd-line Tech Support you may experience an issue with GOV.UK where you need help from a Site Reliability Engineer (SRE). The SREs generally work on the _Platform Engineering_ and _Platform Security and Reliability_ teams.

## If you require assistance

Ask in `#govuk-platform-reliability` or `#govuk-platform-engineering`.

## If a problem is not urgent

If the issue you've identified seems like a non-urgent story you can add it the
[GOV.UK Technical 2nd Line trello board][2nd-line-trello] in the "Ongoing issues to be aware
of & unexplained events" column. The Technical 2nd Line tech lead(s) will then decide whether
to pass this on to another team, manage the ticket through its life cycle, or to
resolve this problem themselves.

[2nd-line-trello]: https://trello.com/b/M7UzqXpk/govuk-2nd-line

## Understanding what SREs can assist with

There is a broad explanation of the different areas of support in GOV.UK in
[ask for help](/manual/ask-for-help.html).

SREs can help with:

- Scalability and resilience
- Designing or improving monitoring, metrics, tracing and observability of system behaviour
- Troubleshooting complex problems
- Designing new systems or backend (APIs, information storage and processing) features
- Designing for graceful degradation under failure conditions (for example the GOV.UK static mirrors)
- Migrating from legacy systems, for example [GOV.UK Puppet](https://github.com/alphagov/govuk-puppet)
- Upgrading software packages that are end-of-life/have security issues/no longer fit for purpose
- Advice on how to structure or maintain [Terraform modules](https://github.com/alphagov/govuk-aws/) for managing cloud resources
- Continuous deployment and continuous delivery systems (CI/CD), build and release automation
