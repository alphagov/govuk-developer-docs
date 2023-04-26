---
owner_slack: "#govuk-2ndline-tech"
title: Raise issues with Reliability Engineering
parent: "/manual.html"
layout: manual_layout
section: 2nd line
---

When on Technical 2nd Line you may experience an issue with GOV.UK that requires asking the Site Reliability Engineers (SREs) who work on GOV.UK infrastructure for assistance. The SREs previously worked in the RE GOV.UK team in Reliability Engineering, but currently they mostly work as part of the Platform Engineering team. It is best to use RE GOV.UK channels for communication.

There are [Reliability Engineering docs](https://reliability-engineering.cloudapps.digital/) for users of their systems. There are also [other Reliability Engineering docs](https://re-team-manual.cloudapps.digital/) for use by the team, these may contain more technical details.

## If you require assistance

Ask in `#govuk-platform-reliability` or in `#govuk-platform-engineering`.

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

More specificially to GOV.UK, SREs can help with:

- [GOV.UK Puppet](https://github.com/alphagov/govuk-puppet)
- Upgrading software packages that are end-of-life/have security issues/no longer fit for purpose
- Running and maintaining the [Terraform configurations](https://github.com/alphagov/govuk-aws/) for AWS
- Maintaining the mirror configuration
- Keeping the CI environment running (GOV.UK are responsible for job configuration)
