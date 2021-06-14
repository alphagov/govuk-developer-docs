---
owner_slack: "#govuk-accounts-tech"
title: Error budget exceeded - Accounts
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
related_applications: [account-api]
---

The GOV.UK Accounts team has defined Service Level Objectives (SLOs) for reliability of the `account-api`.

You can read more about these in [GOV.UK Accounts Service Level Objectives](https://docs.google.com/document/d/1HVXlyy2vdy9U0O-_7Nw8_Oso7VXQeKgJ2_-bi4pKlz0/edit)

## Error budget under 50%

When our error budget falls below 50% it will trigger an Icinga warning alert warning the GOV.UK Accounts team that something is wrong.

This warning automatically triggers a message to the `#govuk-accounts-tech` slack channel.

No further action is required from GOV.UK 2ndline or any other team.

## Error budget under 25%

When our error budget falls below 25% it will trigger an Icinga alert critical the GOV.UK Accounts team that something is wrong.

This warning automatically triggers a message to the `#govuk-accounts-tech` slack channel.

No further action is required from GOV.UK 2ndline or any other team.
