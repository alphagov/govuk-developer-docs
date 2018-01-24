---
owner_slack: "#2ndline"
title: Deploy an application to GOV.UK
parent: "/manual.html"
layout: manual_layout
section: Deployment
important: true
last_reviewed_on: 2018-01-24
review_in: 3 months
---

## Introduction

2nd line is responsible for:

- ensuring that software is released to GOV.UK responsibly
- providing access to deploy software for teams who can't deploy it themselves

As far as possible, teams are responsible for deploying their own work. We believe that [regular releases minimise the risk of major problems][regular_releases_reduce_risk] and improve recovery time.

[regular_releases_reduce_risk]: https://gds.blog.gov.uk/2012/11/02/regular-releases-reduce-risk/

If possible, you should avoid coupling multiple applications so that they all have to be deployed at once. Changes should be backwards compatible except in exceptional circumstances.

We have a staging environment that must always be deployed to immediately before production. Access to staging and production is restricted to certain people.

## Release process

Only one release takes place at a time. One product team owns the release - if
multiple teams are involved in the release, pick one. Releases are tracked by the [release app](https://release.publishing.service.gov.uk/).

You need to have a Signon account with appropriate permissions to access the release app.

## Deployment process

As a response to [RFC-70](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-070-path-towards-continuous-deployment-cd.md) starting 15 May 2017 we are using a process which allows us to deploy without the need for a booked deployment slot.

Deployment communications are in the `#govuk-deploy` Slack channel. If you are on 2ndline you should add yourself to that channel. As before, releases can start from 9:30am and must be finished by 5pm, or 4pm on Fridays.

### Deployment

1. Check with anyone whose changes you will release during your deploy (check the release app)
1. Check `#govuk-deploy` recent history and the channel topic
1. Announce your deployment if it’s potentially problematic
1. Deploy to staging
1. Check Smokey passes; remember most apps take a couple of minutes to restart
1. Check the new functionality works as you would expect
1. Deploy to production
1. Check Smokey passes in production; once again, apps take a couple of minutes
    to restart
1. Check the new functionality works in production
1. Take a look at any alerts and metrics, just to check you haven't broken
   something
1. Stay around for a while just in case something goes wrong

An alert for the start and end of your deployment will appear in the channel. Jenkins will still enforce sequential deployments per environment across all applications, so you may end up in a queue.

### Holding deployment of other applications

If you need to hold deployments of applications during your deploy say so in your announcement post and add it to the channel topic (along with your name). Post again and remove from the topic when you release your hold.

### 2nd line support

If you need support from 2nd line during your deploy, contact them in advance and agree a time.

### Security patches

If you are responding to a security incident, follow the steps to [deploy fixes for a security vulnerability](deploy-fixes-for-a-security-vulnerability.html).

### Rollback

Make sure you have a rollback plan if things go wrong. When you're just changing code, this is relatively easy; when you're doing data migrations, less so. **As far as is possible, all data migrations should be reversible**. Don't rely on backups unless you absolutely have to.

If a release fails on staging and you can fix it, test it in integration,
redeploy it to staging, re-test it, deploy it to production and test it
there, then that's allowed. You're probably better off rolling back and
trying again later.

## GitHub

We depend on GitHub for deploying software to GOV.UK. We have processes in place to deploy if [GitHub is unavailable](github-unavailable.html).

## On the blog

- [Releasing applications to GOV.UK](https://gdstechnology.blog.gov.uk/2014/09/10/releasing-applications-to-gov-uk/) (older post, using the badger)
