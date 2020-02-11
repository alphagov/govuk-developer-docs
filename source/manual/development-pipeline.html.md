---
owner_slack: "#govuk-developers"
title: The development and deployment pipeline
parent: "/manual.html"
layout: manual_layout
section: Deployment
type: learn
last_reviewed_on: 2019-08-28
review_in: 6 months
---

Our development and deployment pipeline looks like this:

<img src="https://docs.google.com/drawings/d/e/2PACX-1vScz6LD_vuXiLH8Nug-29qil0U1m-0p9axgTDAR9_pXRsyTes1sDix45vVQtgjJ4q_msUKDU6fxXuha/pub?w=1289&amp;h=178">

## 1. Local development

Developers develop the code on their laptop. Most of the time, they [use the Development VM](/manual/get-started.html) for this.

Once the tests pass locally you push the code to GitHub and open a Pull Request. The Pull Request [should conform to the guidelines in the styleguides](https://github.com/alphagov/styleguides/blob/master/pull-requests.md).

## 2. GitHub Pull Request

Once the Pull Request is opened, a job starts running on Jenkins, our Continuous Integration tool (CI). For a detailed look, you should [read about the CI infrastructure](/manual/jenkins-ci.html).

In most cases the CI job will run 3 different checks on the repo: a [Ruby linter](/manual/lint-ruby-code.html), a [static security analysis tool](/manual/brakeman.html), and the [unit tests of the repo](/manual/testing.html).

For some applications, Jenkins also runs the [end-to-end tests](/manual/publishing-e2e-tests.html).

All frontend applications and some publishing apps have [Heroku Review Apps](/manual/review-apps.html) enabled.

Next, you'll have to find someone in GOV.UK to review the code. The GDS Way has guidelines on [how to review code](https://gds-way.cloudapps.digital/manuals/code-review-guidelines.html).

We've got [guidelines on merging of Pull Requests](/manual/merge-pr.html).

Only when the tests pass and the code has been approved the Pull Request can be merged, since we've [configured GitHub to prevent merges](/manual/configure-github-repo.html) otherwise.

## 3. Master

Code that is merged to `master` is tested again on CI. If the tests on `master` pass, Jenkins pushes a git tag to GitHub - what we call the "release tag", which looks something like `release_312`.

After that, the CI Jenkins sends a message to the integration Deploy Jenkins to deploy the release tag to integration.

## 4. Deploy to staging and production

👉 Read ["Deploy an application to GOV.UK"](/manual/deploying.html)
