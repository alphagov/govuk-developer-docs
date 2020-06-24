---
owner_slack: "#govuk-developers"
title: The development and deployment pipeline
parent: "/manual.html"
layout: manual_layout
section: Deployment
type: learn
last_reviewed_on: 2020-06-10
review_in: 6 months
---

> When responding to a security incident, you should make any code changes in private, so that you don't accidentally disclose the vulnerability. To do this, follow the instructions for [making a repo private](make-github-repo-private.html).

Our development and deployment pipeline looks like this:

1. Open a Pull Request (PR)
1. [Wait for Continuous Integration to pass](#wait-for-continuous-integration-to-pass)
1. [Get someone to review your Pull Request](#get-someone-to-review-your-pull-request)
1. [Check if there is a deploy freeze](#check-if-there-is-a-deploy-freeze)
1. [Merge your own Pull Request](#merge-your-own-pull-request)
1. [Wait for the release to deploy to Integration](#wait-for-the-release-to-deploy-to-integration)
1. [Manually deploy to Staging, then Production](#manually-deploy-to-staging-then-production)

## Wait for Continuous Integration to pass

When a Pull Request (PR) is opened, a job starts running on [our CI infrastructure](/manual/test-and-build-a-project-on-jenkins-ci.html). In most cases the CI job will run 3 different checks on the repo: a [Ruby linter](https://github.com/alphagov/rubocop-govuk), a [static security analysis tool](/manual/brakeman.html), and the [unit tests of the repo](/manual/testing.html).

> For some applications, Jenkins also runs the [end-to-end tests](/manual/publishing-e2e-tests.html).

## Get someone to review your Pull Request

The GDS Way has guidelines on [how to review code](https://gds-way.cloudapps.digital/manuals/code-review-guidelines.html). Only when the tests pass and the code has been approved the Pull Request can be merged, since we've [configured GitHub to prevent merges](/manual/configure-github-repo.html) otherwise.

### Heroku App Review

Sometimes you may need to demo a running version of your change. All frontend applications and some publishing apps have [Heroku Review Apps](/manual/review-apps.html) enabled, with a link near the bottom of each PR.

### Branch Deploy Review

Sometimes you may need to deploy your change in Integration in order to test it works on real infrastructure. Go to [the `Deploy_App` job in Jenkins](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/) and click 'Build with Parameters':

- `TARGET_APPLICATION` - choose the name of the repository you want to deploy
- `DEPLOY_TASK` - usually 'deploy' is most appropriate
- `TAG` - put the name of your branch
- Typically you can leave the checkboxes as they are

## Check if there is a deploy freeze

In exceptional circumstances, we may wish to block or _freeze_ deployments for a short period of time. This should be done by checking "Freeze deployments?" and adding an explanatory note to the application in the [Release app][release].

> Checking "Freeze deployments?" will turn off all automatic deployments for the application. You can still deploy urgent changes manually if necessary.

When a deploy freeze is in effect, you should avoid merging any PRs. This is because your changes may block other, urgent changes related to the deploy freeze. Your changes will also remain undeployed for a long time.

> People don't always check the Release app before merging their PRs. If you need to freeze deployments for an application, you should also make people aware using other channels.

## Merge your own Pull Request

We've got [guidelines on merging of Pull Requests](/manual/merge-pr.html).

> Some applications [have restrictions on who can merge PRs](https://github.com/alphagov/govuk-saas-config/blob/master/github/repo_overrides.yml). If you are unable to merge your own PR, you should ask [someone else](https://github.com/orgs/alphagov/teams/gov-uk-production/members) to merge (and deploy) it for you.

Code that is merged to `master` is tested again on CI. This is because the `master` branch may have changed since the tests last ran on the PR. If the tests on `master` pass, Jenkins pushes a `release_123` git tag to GitHub.

> **WARNING**: some applications have Continuous Deployment enabled, which means the deployment process is fully automated. You should do any manual testing with [a temporary, branch deployment](#branch-deploy-review), before you merge.
>
> - Check the notes in the [Release app][release] to see if Continuous Deployment is enabled.
> - You should still monitor the progress of your deployment in the [Release app][release] to check it succeeds.
> - You can manually deploy your change if the automation fails e.g. due to a flakey [Smokey test][smokey].

## Deployment

Teams are responsible for deploying their own work. We believe that [regular releases minimise the risk of major problems](https://gds.blog.gov.uk/2012/11/02/regular-releases-reduce-risk) and improve recovery time. The [2nd line team](/manual/welcome-to-2nd-line.html) is responsible for providing access to deploy software for teams who can't deploy it themselves.

### Wait for the release to deploy to Integration

When a new release is created, CI sends a message to Integration Deploy Jenkins to deploy the tag and run [Smokey][smokey]. You should verify your changes work in Integration before deploying downstream:

- Check the results of the [smoke tests][smokey].
- Look for any Icinga alerts related to your application.

Our apps should always be in a state where `master` is deployable. You should raise a PR to revert your changes if they cause a problem and you're unable to resolve that problem straight away.

### Manually deploy to Staging, then Production

Deployments to these environments are manual and require [production access](/manual/rules-for-getting-production-access.html). Go to the [Release application][release] and find the application you want to deploy, then select the release tag you want to deploy. Follow these rules:

- Deployments should generally take place between 9.30am and 5pm (4pm on Fridays), the core hours when most people are in the office.
- If there's other people's code to deploy, ask them whether they're okay for the changes to go out.
- Announce in `#govuk-2ndline` if you anticipate your release causing any issues. Stay around for a while just in case something goes wrong.
- Check the [Release app][release] for a deploy note for the application, to see if there are any special instructions or reasons not to deploy. Individual app deploy freezes are usually announced here.

After a deployment:

- [Check Sentry for any new errors](/manual/error-reporting.html).
- Look for [any Icinga alerts](/manual/icinga.html) related to your application.
- Check the [Deployment Dashboard](/manual/deployment-dashboards.html) for any issues.
- Check the results of the [smoke tests][smokey].

[release]: https://release.publishing.service.gov.uk
[smokey]: https://github.com/alphagov/smokey
