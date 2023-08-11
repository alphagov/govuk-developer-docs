---
owner_slack: "#find-and-view-tech"
title: SLO Error Rate on GOV.UK Accounts has exceeded an acceptable threshold across the last 10 minutes
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

# SLO Error Rate on GOV.UK Accounts has exceeded an acceptable threshold across the last 10 minutes

The GOV.UK Account team has defined Service Level Objectives (SLOs) for
reliability of the `account-api`.

You can read more about these in [GOV.UK Accounts Service Level
Objectives](https://docs.google.com/document/d/1HVXlyy2vdy9U0O-_7Nw8_Oso7VXQeKgJ2_-bi4pKlz0/edit)

## HTTP Error on GOV.UK Account has exceeded an acceptable threshold across the last 10 minutes

This warning triggers when over 1% of all HTTP status codes are deemed "bad
responses" as a proportion of all responses within a rolling 10 minute time
period.

This is an early warning that, if these errors continue at a consistent rate,
the GOV.UK Account team would spend its entire error budget across the full
monitoring period.

This warning automatically triggers a message to the `#find-and-view-tech`
slack channel.

No further action is required from GOV.UK 2ndline or any other team.

## Latency on GOV.UK Account has exceeded an acceptable threshold across the last 10 minutes

This warning triggers when over 1% of all HTTP responses are deemed
"too slow" as a proportion of all responses within a rolling 10 minute time
period.

This is an early warning that, if these errors continue at a consistent rate,
the GOV.UK Account team would spend its entire error budget across the full
monitoring period.

This warning automatically triggers a message to the `#find-and-view-tech`
slack channel.

No further action is required from GOV.UK 2ndline or any other team.
