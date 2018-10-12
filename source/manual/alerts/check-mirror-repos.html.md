---
owner_slack: "#govuk-2ndline"
title: Check Mirror Repos
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-12
review_in: 6 months
---

This alert is triggered on a non successful build of the [Mirror_Repositories CI jenkins job](https://ci.integration.publishing.service.gov.uk/job/Mirror_Repositories/).

## Mirroring repositories

We keep a backup of Github alphagov repos tagged 'govuk' on Amazon CodeCommit. These mirrored repositories are not publicly visible and can also be used to make discrete security fixes.

The mirroring process runs on CI Jenkins every 2 hours and to communicate the success or failure of the build it posts a request to the Integration Deploy Jenkins where the [Check_Mirror_Repositories](https://deploy.integration.publishing.service.gov.uk/job/Check_Mirror_Repositories/) job will alert if the build fails for any reason.

## Diagnosing problems

Checking the CI build of [Mirror_Repositories](https://ci.integration.publishing.service.gov.uk/job/Mirror_Repositories/) will tell you if the Github repos/branches were successfully mirrored to AWS CodeCommit.

Look in the CI job console log to check the repos/branches are mirroring correctly.
eg.

```
...
Checking if whitehall is up to date... updating
From https://github.com/alphagov/whitehall
 x [deleted]         (none)     -> dependabot/bundler/govuk_publishing_components-12.0.1
 * [new branch]      fix-change-history-issue-with-speech-and-corporate-information-page-presenters -> fix-change-history-issue-with-speech-and-corporate-information-page-presenters
   b54f7e2..9cccc2f  master     -> master
   b54f7e2..9cccc2f  release    -> release
 * [new tag]         release_13802 -> release_13802
 * [new tag]         release_13801 -> release_13801
 * [new tag]         release_13801 -> release_13801
 * [new tag]         release_13802 -> release_13802
Checking if smart-answers is up to date... updating
Everything up-to-date
Checking if rummager is up to date... ok
Checking if calendars is up to date... ok
Checking if smokey is up to date... ok
Checking if gds-api-adapters is up to date... updating
Everything up-to-date
...
```

Also check the POST request at the end of the build is successful.
(Changes to Jenkins API tokens have broken this step in the past).
