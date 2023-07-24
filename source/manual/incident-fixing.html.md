---
owner_slack: "@ana.botto"
title: Fixing an Incident
parent: "/manual.html"
layout: manual_layout
type: learn
section: Incidents
---

When there is an incident in an application you are supporting, it is important to make a quick fix so that users can get back to use the application as usual.

You should look into the logs on Sentry and Logit to see where the error is coming from.

You should have a look at the latest commits to the application on Github. When seeing the latest commits you will be able to see if there are any commits that are related to the error.

When discovering what commit could be the one causing the issue, and it is not an issue that can be solved straight away, you should revert that commit.
This revert commit can be made on Github from the pull request where the issue could have come from. This should ensure that your revert commit is fix forwards too.

You should test this in integration to see if it has fixed the issue.

Sometimes it could be necessary to freeze automatic deployment so we can see if we have identified the correct fix.
