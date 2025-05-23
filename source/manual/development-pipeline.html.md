---
owner_slack: "#govuk-platform-engineering"
title: The development pipeline
parent: "/manual.html"
layout: manual_layout
section: Deployment
type: learn
---

> When responding to a security incident, you should make any code changes in private, so that you don't accidentally disclose the vulnerability. To do this, follow the instructions for [making a repo private](make-github-repo-private.html).

Our development and deployment pipeline looks like this:

1. Open a Pull Request (PR)
1. [Wait for Continuous Integration to pass](#wait-for-continuous-integration-to-pass)
1. [Review your own changes](#review-your-own-changes)
1. [Get someone to review your Pull Request](#get-someone-to-review-your-pull-request)
1. [Check for or implement a deploy freeze](#check-for-or-implement-a-deploy-freeze)
1. [Merge your own Pull Request](#merge-your-own-pull-request)
1. [Deploy through each of the environments](#deployment)

## Wait for Continuous Integration to pass

When a Pull Request (PR) is opened, it often triggers an automated
job, which typically lints the code and runs the tests.

[Read about Continuous Integration checks](/manual/testing.html#continuous-integration-checks).

## Review your own changes

As well as double-checking your code and commits, you may refer
to the following:

### Heroku App Review

Sometimes you may need to demo a running version of your change.
All frontend applications and some publishing apps have
[Heroku Review Apps](/manual/review-apps.html) enabled, with a
link near the bottom of each PR.

### Branch Deploy Review

Sometimes you may need to deploy your change in Integration in
order to test it works on real infrastructure. Refer to the [manual deployments documentation](/manual/deployments.html#manual-deployments).

## Get someone to review your Pull Request

The GDS Way has guidelines on [how to review code](https://gds-way.digital.cabinet-office.gov.uk/manuals/code-review-guidelines.html).

Only when the tests pass and the code has been approved the Pull Request can be merged, since we've
[configured GitHub to prevent merges](/manual/github.html) otherwise.

## Check for or implement a deployment freeze

We sometimes have a deployment freeze on applications, e.g. during periods where accidental bad deploys would be particularly disruptive, such as during an election.

You should check whether or not there is a code freeze in effect by referring to the relevant section in the [deployments documentation](/manual/deployments.html#deployment-freezes).

## Merge your own Pull Request

We've got [guidelines on merging of Pull Requests](/manual/merge-pr.html).

Some applications [have restrictions on who can merge PRs](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/repos.yml).
If you are unable to merge your own PR, you should ask
[someone else](https://github.com/orgs/alphagov/teams/gov-uk-production/members)
to merge (and deploy) it for you.

Code that is merged to `main` is tested again on CI. This is because
the `main` branch may have changed since the tests last ran on the PR.

> **WARNING**: some applications have Continuous Deployment enabled,
> which means the deployment process is fully automated. You should do
> any manual testing with [a temporary, branch deployment](#branch-deploy-review)
> before you merge.

## Deployment

Teams are responsible for deploying their own work. We believe that
[regular releases minimise the risk of major problems](https://gds.blog.gov.uk/2012/11/02/regular-releases-reduce-risk)
and improve recovery time.

Refer to the [deployments documentation](/manual/deployments.html#deployment-freezes).

After a deployment:

- [Check Sentry for any new errors](/manual/error-reporting.html).
- Check the [Deployment Dashboard](/manual/graphite-and-deployment-dashboards.htmll) for any issues.
- Run a build of [end-to-end tests](https://github.com/alphagov/govuk-e2e-tests) in the environment you're deploying to.
