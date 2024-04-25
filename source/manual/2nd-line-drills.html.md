---
owner_slack: "#govuk-2ndline-tech"
title: 2nd line drills
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

There are a number of areas that are important to drill on 2nd line and include some tasks you may not necessarily encounter in your mission team. We want to ensure developers have the opportunity to practise these tasks ahead of the real thing and in preparation of going [on call](/manual/on-call.html) if you are part of the out of hours rota.

## Drill publishing emergency banner

Follow the [Deploy an emergency banner](/manual/emergency-publishing.html) on Staging.

You'll need to choose a non-serious and clearly fake news headline. For example:

- `CAMPAIGN_CLASS`: Death of a notable person
- `HEADING`: Henry Fielding dies
- `SHORT_DESCRIPTION`: English novelist and dramatist known for his earthy humour and satire dies, age 47
- `LINK`: https://en.wikipedia.org/wiki/Henry_Fielding
- `LINK_TEXT`: More information

## Use a restored database in an app

On Integration or Staging, follow the [Restore an RDS instance via the AWS CLI](/manual/howto-backup-and-restore-in-aws-rds.html#restore-an-rds-instance-via-the-aws-cli) instructions for an app of your choice.

## Force failover to GOV.UK mirror and Emergency publishing using the GOV.UK mirror

1. Warn in `#govuk-2ndline-tech` that you're about to do this, as it will lead to a spike in alerts and will also break continuous deployment for a while (due to Smokey failures).
1. Follow the [Forcing failover to the GOV.UK mirrors](/manual/fall-back-to-mirror.html#forcing-failover-to-the-gov-uk-mirrors) instructions on Integration or Staging.
1. To verify that it worked, visit a page at random and [purge the page from cache](/manual/purge-cache.html). Reload the page, to see the 'mirrored' version of the content. NB: you wouldn't do this in a real incident, as we'd want to serve Fastly's cached version for as long as possible.
1. Undo your changes to have Nginx handling requests again.

## Drill logging into accounts

Make sure you can log into the following:

1. [The AWS web console](/manual/common-aws-tasks-for-2nd-line-support.html#logging-into-aws)
1. [Fastly](https://manage.fastly.com/) (using your individual account)
1. [Statuspage](https://manage.statuspage.io/login) (using your individual account)
1. [Logit](https://dashboard.logit.io/sign-in) (using your individual account)
1. [Heroku](/manual/heroku.html)
1. [data.gov.uk CKAN](/manual/data-gov-uk-2nd-line.html)
1. [Rubygems](https://rubygems.org/sign_in) (`2ndline/rubygems` in [Secrets Manager](secrets-manager.html))
1. [NPM](https://www.npmjs.com/login) (`2ndline/npm` in Secrets Manager)

## Drill scaling up an application

In preparation for a large spike in traffic, you can increase the number of replicas for an app.

Pick an application and try [scaling it up](/kubernetes/manage-app/scale-app/) in staging. Don't forget to revert your change afterwards.

Example PR - [Increase content store replica count in staging](https://github.com/alphagov/govuk-helm-charts/pull/1254)

## Drill 2nd line incident processes

### Drill an end to end incident

Decide on a hypothetical incident scenario, e.g. "GOV.UK is down".
Walk through the [incident management guidance](/manual/incident-management-guidance.html).
Use common sense when following the steps (i.e. don't actually publish an incident to Statuspage or email stakeholders).

### Drill how to communicate when Slack is down

Ensure you know how to communicate with your 2nd line colleagues if Slack is unavailable.
See [Communicate when Slack is unavailable](/manual/slack-unavailable.html#2nd-line-google-space) for details.

## Drill special deployment conditions

### Deploy from AWS CodeCommit when Github is unavailable

Follow the [Deploy when GitHub is unavailable](/manual/github-unavailable.html#create-and-deploy-an-image-to-ecr) instructions.

### Drill enabling a code freeze

Choose a continuously-deployed app where you can make a meaningful change to the default branch, such as fixing a typo or merging a Dependabot PR.

Before merging the change, [implement a deployment freeze](/manual/development-pipeline.html#check-for-or-implement-a-deploy-freeze) for that app.

View the application's page in Argo CD in each environment to see whether a deployment happened or not.

Remove the code freeze, then make sure the current version is deployed to all three environments.

## Drill making changes to user accounts

### Assign a user to their publisher in data.gov.uk

[Log into our shared data.gov.uk publisher account](/manual/data-gov-uk-2nd-line.html#logging-into-the-publisher). Pick a [publisher](https://ckan.publishing.service.gov.uk/organization) to do a hypothetical walk through of [assign users to publishers](/manual/data-gov-uk-2nd-line.html#assigning-users-to-publishers-setting-user-permissions).

### Change a user's permissions in Signon

Carry out a hypothetical walk through of [unsuspending a user](/manual/manage-sign-on-accounts#unsuspending-a-user) and [resetting a user's 2FA](/manual/manage-sign-on-accounts#resetting-a-users-2fa).

## Drill creating and changing redirects

### Redirect a route

On Integration or Staging, follow the [Removing a route created in the Short URL Manager](/manual/redirect-routes.html#removing-a-route-created-in-the-short-url-manager) and [Removing a route completely so it can be replaced with another route](/manual/redirect-routes.html#removing-a-route-completely-so-it-can-be-replaced-with-another-route) instructions.

### Change a slug and create a redirect

On Integration or Staging, follow the [Change a slug and create redirect in Whitehall](/manual/howto-change-slug-and-create-redirect.html), picking something
at random in Whitehall from one of the group of entities listed ([people](https://whitehall-admin.publishing.service.gov.uk/government/admin/people), [role](https://whitehall-admin.publishing.service.gov.uk/government/admin/roles), [organisation](https://whitehall-admin.publishing.service.gov.uk/government/admin/organisations), etc).

## Drill modifying a document's change note

### Modify and remove a document's change note in Whitehall

On Integration or Staging, follow [Modify a change note in Whitehall](/manual/howto-modify-change-note.html#whitehall) using [this document](https://www.staging.publishing.service.gov.uk/guidance/deer-keepers-tagging-deer-and-reporting-their-movements) or one of your choice.
Once you have successfully updated the change note you can drill [removing a change note in Whitehall](/manual/howto-remove-change-note.html#whitehall).

### Modify and remove a document's change note in Content Publisher

On Integration or Staging, follow [Modify a change note in Content Publisher](/manual/howto-modify-change-note.html#content-publisher) using [this document](https://www.staging.publishing.service.gov.uk/government/news/cold-weather-alert-issued-by-ukhsa). The 30th November 2021 shows a bespoke change note which you could try changing - click "show all updates" at the bottom of the page.

You can also try deleting the change note. Again, ensure you do this on Staging or Integration.

### Modify a document's change note in Publishing API

On Integration or Staging, follow [Modify a change note in Publishing API](/manual/howto-modify-change-note.html#publishing-api) using [this document](https://www.staging.publishing.service.gov.uk/guidance/deer-keepers-tagging-deer-and-reporting-their-movements) or one of your choice.
Once you have successfully updated the change note you can drill [removing a change note in Publishing API](/manual/howto-remove-change-note.html#other-apps).

## Drill making changes to the homepage

### Drill updating homepage popular links

Change the homepage popular links following [Update popular links](/manual/update_popular_links.html). Open a draft PR, and deploy your branch to integration. Once deployed, check your change and redeploy the previous branch to integration.

### Drill updating homepage promotion slots

Follow the [Update homepage promotion slots](/repos/frontend/update-homepage-promotion-slots.html) instructions, using an appropriate image and text.
Open a draft PR, and [deploy your branch to integration](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/).
Once deployed, [check your change](https://www-origin.integration.govuk.digital/) and redeploy the previous branch to integration.

## Drill CDN failover

1. Warn in `#govuk-2ndline-tech` that you're about to do this, because our failover CDN does not have full feature parity with our primary one.
1. Ensure that you are connected to the VPN before starting.
1. Follow the [Fall back to AWS CloudFront](/manual/fall-back-to-aws-cloudfront.html) instructions for staging only.
1. Check if [GOV.UK Staging](https://www.staging.publishing.service.gov.uk) still works correctly after performing the failover.
1. Revert your changes when finished.
