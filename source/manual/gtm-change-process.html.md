---
owner_slack: "#govuk-frontenders"
title: 'Google Tag Manager change process'
section: Frontend
layout: manual_layout
type: learn
parent: "/manual.html"
related_repos: [govuk_publishing_components]
---

GOV.UK has implemented Google Analytics 4 (GA4) using Google Tag Manager (GTM) to track user journeys through the site. This page describes the process of making changes to GTM to support improvements to our analytics.

This process exists because some changes can increase the size of the JavaScript included from GTM in the public frontend of GOV.UK. We do not want to unnecessarily degrade the performance of GOV.UK.

## Roles and responsibilities

Performance analysts:

- to make changes in GTM and share the change with a succinct explanation of what it does and why it's needed
- to fully document the details of the change

Developers:

- to review and publish the change in GTM
- to check that the changes don't increase the JavaScript size

## Process

Analyst creates a change in the GTM web interface.

- change is created in a new workspace
- change must include a clear description
- change can be checked in preview mode (optional)

Analyst gets a second analyst to check the changes.

Analyst raises a request to have the change approved.

- can be raised in the `#user-experience-measurement-govuk` slack channel
- include a link to the workspace to review
- must specify which environment to publish to

Developer reviews the change

- `modified` is a change to an existing thing
- `added` is a new thing
- specific changes are listed under `Version changes`
- `Activity history` shows previous changes
- ensure no custom HTML or JS included in tags

Developer approves and publishes the change

- publish to the required environment - `Production`, `Staging` or `Integration`
- publishing defaults to the `Production` environment, if it needs to be deployed to a different environment that must be selected first
- publishing may involve more than one publishing act e.g. publish version 35 to `Production`, publish version 36 to `Integration`

Analyst tests that change has been successful, in this order

- `Integration`: analyst checks that change has been implemented as per specifications
- `Staging`: for wider community/second analyst to check that the change fits the data requirement
- `Production`: analyst must check that change has gone live as expected
