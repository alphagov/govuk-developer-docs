---
title: Blocking apps from being released
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/releasing-software/blocking-apps-from-release.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/releasing-software/blocking-apps-from-release.md)


# Blocking apps from being released

Sometimes the master branch of an app might contain a feature which cannot
be released to production. This is usually because it is coupled to the release of
another app.

We should avoid this scenario as much as possible, as it blocks other teams and
makes it more difficult to release time-critical changes, like security updates.

If the changes are not intended to be deployed within a short period of time,
you should consider pulling them out of the master branch.

In the event that an emergency change needs to be released for the app, the
"safe to deploy" tag should be branched and released as a hotfix, and later merged
back into master.

In exceptional circumstances, merging breaking changes into master cannot be avoided.
In this case, the team responsible for the change should perform the following
steps to alert others who might be deploying:

## Email the 2nd line mailing list

Give a brief description of:

- the changes that have been made and the reason they can't be deployed
- an estimated time when it will be possible to deploy the application again
- the most up-to-date release tag which is safe to deploy

## Add a note to the application in the release app

With similar information.

## Tag the badger

Add a post-it to the badger saying which application can't be deployed.
