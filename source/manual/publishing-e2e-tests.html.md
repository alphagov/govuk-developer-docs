---
title: End to end testing publishing apps
section: Testing
layout: manual_layout
parent: "/manual.html"
owner_slack: "#govuk-developers"
last_reviewed_on: 2019-03-01
review_in: 6 months
---

We have [end to end tests][repo] running against proposed changes to applications to verify
that the change doesn't break flows interacting with multiple applications.

## Flaky tests

These tests execute through the UI, and can be fragile and flaky as a result.  Rerunning a build may fix the immediate
problem but [you are implored to tackle the root cause][flaky-tests-guide].

## Test against branch

The test-against branch is used by [Jenkins when executing the test suite][jenkins-test-against] against proposed
changes.  This branch should get pushed to automatically whenever a change is made to master branch.  On occasion the
master branch has failed due to the flaky nature of the test suite causing test-against to
[become behind master][compare-test-against-master].  [Rerunning the master branch build][rebuild-master-branch] should fix it.

## How to add new tests

If you are writing a new publishing application or wanting to cover new end to end flows you are advised to
[read the guidance on Github][add-new-tests-guidance].

[repo]: https://github.com/alphagov/publishing-e2e-tests
[flaky-tests-guide]: https://github.com/alphagov/publishing-e2e-tests/blob/master/CONTRIBUTING.md#dealing-with-flaky-tests
[compare-test-against-master]: https://github.com/alphagov/publishing-e2e-tests/compare/test-against...master
[jenkins-test-against]: https://ci.integration.publishing.service.gov.uk/job/publishing-e2e-tests/job/test-against/
[add-new-tests-guidance]: https://github.com/alphagov/publishing-e2e-tests/blob/master/CONTRIBUTING.md#adding-new-tests
[rebuild-master-branch]: https://ci.integration.publishing.service.gov.uk/job/publishing-e2e-tests/job/master/build?delay=0sec
