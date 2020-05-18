---
owner_slack: "#govuk-developers"
title: Work with the end to end publishing tests
section: Testing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-18
review_in: 6 months
---

Most GOV.UK applications are run against a [end-to-end test suite](https://github.com/alphagov/publishing-e2e-tests) as part of their build process. This is done to determine if a change in one application has a negative impact on a dependant application and to test the changed application is functioning correctly in a quasi-production environment.

There is specific documentation available on:

 - [what belongs in the test suite](https://github.com/alphagov/publishing-e2e-tests/blob/master/docs/what-belongs-in-these-tests.md)
 - [how to debug a failing test in jenkins](https://github.com/alphagov/publishing-e2e-tests/blob/master/docs/debugging-failures.md)
 - [how to resolve breaking changes](https://github.com/alphagov/publishing-e2e-tests/blob/master/docs/breaking-app-change.md)
 - [how to handle intermittently failing (flakey) tests](https://github.com/alphagov/publishing-e2e-tests/blob/master/CONTRIBUTING.md#dealing-with-flaky-tests)
 - [how to add new tests/applications](https://github.com/alphagov/publishing-e2e-tests/blob/master/CONTRIBUTING.md)
