---
owner_slack: "#2ndline"
title: Deploy an application to GOV.UK
parent: "/manual.html"
layout: manual_layout
section: Deployment
important: true
last_reviewed_on: 2017-05-12
review_in: 6 months
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
multiple teams are involved in the release, pick one.


## Experimental deployment process

As a response to [RFC-70](https://gov-uk.atlassian.net/wiki/pages/viewpage.action?pageId=130703581) starting 15th May we are experimenting with a process which allows us to remove the need to book a deployment slot. If you think there's something wrong with the process during the experiment speak up as soon as possible.

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

### Rollback

Make sure you have a rollback plan if things go wrong. When you're just changing code, this is relatively easy; when you're doing data migrations, less so. **As far as is possible, all data migrations should be reversible**. Don't rely on backups unless you absolutely have to.

If a release fails on staging and you can fix it, test it in integration,
redeploy it to staging, re-test it, deploy it to production and test it
there, then that's allowed. You're probably better off rolling back and
trying again later.

## GitHub

We depend on both GitHub and GitHub Enterprise for deploying software to GOV.UK. We have processes in place to deploy if [either of the GitHubs are unavailable](github-unavailable.html).

## Release application

The [release app](https://release.publishing.service.gov.uk/) tracks releases.

You need to have a Signon account with appropriate permissions to access the release app.

## Badger deployment (on hold for the moment)

While the above experiment is in progress you do not need to book a deployment slot and can ignore this section.

### Scheduling

Any member of the team responsible for a release can book a release slot. To
book a release slot, find a free slot in the GOV.UK Release Calendar, then create an event in either your personal or your team's calendar, including the "GOV.UK Release Calendar"
as a guest.

Release slots are half an hour for normal changes and one hour for larger or
more complex changes. The release calendar shows what times releases can happen - they can start from 9:30am and must be finished by 5pm, or 4pm on Fridays.

At an absolute minimum, you should include the name of the app or apps you're
deploying; you should probably also include a description of what you're
releasing and build numbers for all the apps. If you invite yourself to the
event, people will be able to see who to talk to about it.

If you do not have deploy access, and you need someone from the 2nd line team to deploy for you, put as much information into the event as possible, include "2nd line required' in the title. Please be considerate when booking deployments over lunchtime, the team need to eat too.
If in doubt, ask.

### The Badger

The [Badger of Deploy][badger] stops multiple people deploying to GOV.UK at once. If you want to deploy to production, you **must** acquire the badger. You
**should** display it prominently on your monitor, so people can see when you
are deploying. Once your release is finished, return it to one of the people on
2nd line.

If the previous release is over-running slightly, you can technically deploy to
staging without the badger. Be sensible, though: make sure before you start that the previous team isn't going to have to roll back their release.

[badger]: https://twitter.com/badgerofdeploy

### Deployment

1.  Check any notes against the application in the [Release app][release].
1.  Acquire the badger
1.  Ensure the badger is not tagged with the application you are deploying,
    indicating that it is [blocked from being released](blocking-apps-from-release.html).
1.  Deploy to staging
1.  Check Smokey passes; remember most apps take a couple of minutes to restart
1.  Check the new functionality works as you would expect
1.  No, really: **acquire the badger**
1.  Deploy to production
1.  Check Smokey passes in production; once again, apps take a couple of minutes
    to restart
1.  Check the new functionality works in production
1.  Take a look at any alerts and metrics, just to check you haven't broken
    something
1.  Return the badger to someone on 2nd line
1.  Stay around for a while just in case something goes wrong

[release]: https://release.publishing.service.gov.uk/

## On the blog

- [Releasing applications to GOV.UK](https://gdstechnology.blog.gov.uk/2014/09/10/releasing-applications-to-gov-uk/)
