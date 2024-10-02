---
owner_slack: "#govuk-platform-engineering"
title: The development and deployment pipeline
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

In exceptional circumstances, we may wish to block or _freeze_
deployments for a short period of time. This should be done by
raising a PR against govuk-helm-charts then adding an explanatory note
to the application in the [Release app][release].

To enable or disable automatic deployments of a particular app in a particular environment
the relevant image tag needs to be updated for that app in `govuk-helm-charts`

For example to disable automatic deploys of the `govuk-replatform-test-app` to `staging`
make the [following changes](https://github.com/alphagov/govuk-helm-charts/pull/2196)

```
image_tag: v22
automatic_deploys_enabled: false
promote_deployment: true
```

To re-enable automatic deploys of the `govuk-replatform-test-app` to `staging` make the [following changes](https://github.com/alphagov/govuk-helm-charts/pull/2197)

```
image_tag: v22
automatic_deploys_enabled: true
promote_deployment: true
```

You can still deploy urgent changes manually using the deploy GitHub Action if necessary.

It is important to ensure people are aware of a code freeze:

> Checking "Freeze deployments?" on Release will add an
> "Automatic deployments disabled" label to the application.
> This label will be visible on the landing page of release
> and in applications page underneath the title. It provides
> visiblity of the code freeze to other developers who may
> check Release to view the status of deploys for that app.

Let people know on Slack

> Send a message to #govuk-developers on slack with the @channel
> prefix (to ensure people who are offline are notified) and email
> <govuk-tech-members@digital.cabinet-office.gov.uk>. Your message
> should include the repo you are freezing, the reason why, and the
> expected duration. Follow up to let people know when the freeze
> is lifted.

When a deploy freeze is in effect, you should avoid merging any PRs.
This is because your changes may block other, urgent changes related
to the deploy freeze. Your changes will also remain undeployed for a
long time.

## Merge your own Pull Request

We've got [guidelines on merging of Pull Requests](/manual/merge-pr.html).

Some applications [have restrictions on who can merge PRs](https://github.com/alphagov/govuk-saas-config/blob/master/github/repo_overrides.yml).
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
and improve recovery time. The [Technical 2nd Line team](/manual/welcome-to-2nd-line.html)
is responsible for providing access to deploy software for teams who can't deploy it themselves.

### Continuous Deployment

- Check the notes in the [Release app][release] to see if Continuous Deployment is enabled.
- If so, after merging, you should check the Release app to see if the deployment succeeds.
- If the latest release is not on Production within about 15 minutes, something went wrong:
  - Refer to the [deployment documentation](/kubernetes/manage-app/access-ci-cd/#how-apps-are-deployed) for details of the deployment process so you can pinpoint where in the pipeline it failed.
  - You can manually deploy your change if the automation fails e.g. due to a flakey [Smokey test][smokey].

### Manual Deployment

#### Wait for the release to deploy to Integration

Refer to the [manual deployments documentation](/manual/deployments.html#manual-deployments). You should verify your changes work in Integration before deploying downstream:

- Run a build of [smoke tests][smokey] in the environment you're deploying to.

Our apps should always be in a state where `main` is deployable. You
should raise a PR to revert your changes if they cause a problem and
you're unable to resolve that problem straight away.

#### Manually deploy to Staging, then Production

Deployments to these environments are manual and require
[production access](/manual/rules-for-getting-production-access.html).
Go to the [Release application][release] and find the application you
want to deploy, then select the release tag you want to deploy.
Follow these rules:

- Deployments should generally take place between 9.30am and 5pm
  (4pm on Fridays), the core hours when most people are in the office.
- If there's other people's code to deploy, ask them whether they're
  okay for the changes to go out.
- Announce in `#govuk-2ndline-tech` if you anticipate your release causing
  any issues. Stay around for a while just in case something goes wrong.
- Check the [Release app][release] for a deploy note for the application,
  to see if there are any special instructions or reasons not to deploy.
  Individual app deploy freezes are usually announced here.

After a deployment:

- [Check Sentry for any new errors](/manual/error-reporting.html).
- Check the [Deployment Dashboard](/manual/deployment-dashboards.html) for any issues.
- Run a build of [smoke tests][smokey] in the environment you're deploying to.

[release]: https://release.publishing.service.gov.uk
[smokey]: https://github.com/alphagov/smokey
