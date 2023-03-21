---
owner_slack: "#govuk-2ndline-tech"
title: 2nd line drills
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

There are a number of areas that are important to drill on 2nd line and include some tasks you may not necessarily encounter in your mission team. We want to ensure developers have the opportunity to practise these tasks ahead of the real thing and in preparation of going [on call](/manual/on-call.html) if you are part of the out of hours rota.

## Drill detaching an instance

Follow the [Detaching an instance from an Auto Scaling Group](/manual/common-aws-tasks-for-2nd-line-support.html#detaching-an-instance-from-an-auto-scaling-group) guidance.

## Drill publishing emergency banner

Follow the [Deploy an emergency banner](/manual/emergency-publishing.html) on Staging.

You'll need to choose a non-serious and clearly fake news headline. For example:

- `CAMPAIGN_CLASS`: Death of a notable person
- `HEADING`: Henry Fielding dies
- `SHORT_DESCRIPTION`: English novelist and dramatist known for his earthy humour and satire dies, age 47
- `LINK`: https://en.wikipedia.org/wiki/Henry_Fielding
- `LINK_TEXT`: More information

## Run a Terraform `plan`

Follow the [Deploy Terraform](/manual/deploying-terraform.html) instructions, picking a project at random.
You can run this in any environment, as you're only running `plan` - not `apply` - so shouldn't be making any changes.

## Use a restored database in an app

On Integration or Staging, follow the [Restore an RDS instance via the AWS CLI](/manual/howto-backup-and-restore-in-aws-rds.html#restore-an-rds-instance-via-the-aws-cli) instructions for an app of your choice.

## Force failover to GOV.UK mirror and Emergency publishing using the GOV.UK mirror

1. Warn in `#govuk-2ndline-tech` that you're about to do this, as it will lead to a spike in alerts and will also break continuous deployment for a while (due to Smokey failures).
1. Follow the [Forcing failover to the GOV.UK mirrors](/manual/fall-back-to-mirror.html#forcing-failover-to-the-gov-uk-mirrors) instructions on Integration or Staging.
1. To verify that it worked, visit a page at random and [purge the page from cache](/manual/purge-cache.html). Reload the page, to see the 'mirrored' version of the content. NB: you wouldn't do this in a real incident, as we'd want to serve Fastly's cached version for as long as possible.
1. Undo your changes to have Nginx handling requests again.

## Drill logging into accounts

Make sure you can log into the following accounts:

1. [The AWS Console](/manual/common-aws-tasks-for-2nd-line-support.html#logging-into-aws)
1. Your individual Fastly account
1. Your individual Statuspage account
1. Your individual Logit account
1. [Shared Heroku account](/manual/heroku.html)
1. [Shared CKAN account](/manual/data-gov-uk-2nd-line.html)
1. [Shared Rubygems account](/manual/publishing-a-ruby-gem.html)
1. [Shared NPM account](https://github.com/alphagov/govuk-secrets/tree/main/pass/2ndline/npm)
1. [Shared data.gov.uk publisher account](/manual/data-gov-uk-2nd-line.html#logging-into-the-publisher)

## Drill 2nd line incident processes

### Drill an end to end incident

Decide on a hypothetical incident scenario, e.g. "GOV.UK is down".
Walk through the [incident management guidance](/manual/incident-management-guidance.html).
Use common sense when following the steps (i.e. don't actually publish an incident to Statuspage or email stakeholders).

### Drill how to communicate when Slack is down

Ensure you know how to communicate with your 2nd line colleagues if Slack is unavailable.
See "[If Slack is unavailable](https://docs.google.com/document/d/144y8c2Ly-kG3JQkRitpBSIN3DrxLnPSmLDezEZRMGi4/edit#heading=h.15tbsnb0xhwp)" for details.

## Drill scaling up number of workers

In preparation for a spike in traffic, you can increase the number of unicorn workers for an app.

Pick an application (e.g. `smartanswers`) and drill scaling up the number of workers, by following [scale unicorn workers](/manual/scale-unicorn-workers.html).

Note that you'll need to edit the `integration.yaml` file, not the `production.yaml` file as described in the docs above. And instead of merging to `main`, just build your branch directly to Integration. When you're done drilling, re-deploy the previous release and delete your branch.

## Drill special deployment conditions

### Deploy from AWS CodeCommit when Github is unavailable

Follow the [Deploy when GitHub is unavailable](/manual/github-unavailable.html#drill-creating-and-deploying-a-branch-from-codecommit) instructions.

### Drill enabling a code freeze

Choose a continuously-deployed app where you can make a meaningful change to the default branch, e.g. fixing a typo, or merging a Dependabot PR.

Either before merging the change, or part way through the continuous deployment process, follow the instructions for [implementing a deploy freeze](/manual/development-pipeline.html#check-for-or-implement-a-deploy-freeze) for that app.

Follow the deployment pipeline in Jenkins. Confirm that no further environment deployments are triggered. For example, if you implemented the deploy freeze just after the app was deployed to Staging, confirm that the app was then not automatically deployed to Production.

Remove the code freeze, then manually push the changes to all remaining environments so that they're in sync.

## Drill making changes to user accounts

### Assign a user to their publisher in data.gov.uk

[Log into our shared data.gov.uk publisher account](/manual/data-gov-uk-2nd-line.html#logging-into-the-publisher). Pick a [publisher](https://ckan.publishing.service.gov.uk/organization) to do a hypothetical walk though of [Assign users to publishers](/manual/data-gov-uk-2nd-line.html#assign-users-to-publishers-setting-user-permissions).

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

Change the homepage popular links following [Update popular links](/manual/update_popular_links.html.md). Open a draft PR, and deploy your branch to integration. Once deployed, check your change and redeploy the previous branch to integration.

### Update homepage promotion slots

Follow the [Update homepage promotion slots](/repos/frontend/update-homepage-promotion-slots.html) instructions, using an appropriate image and text.
Open a draft PR, and [deploy your branch to integration](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/).
Once deployed, [check your change](https://www-origin.integration.govuk.digital/) and redeploy the previous branch to integration.
