---
owner_slack: "#govuk-2ndline"
title: Merge a Pull Request from an external contributor
section: Development & Reviews
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-03
review_in: 12 months
---

The examples below are from a [release from the Start Pages team](https://github.com/alphagov/publisher/pull/687).
Note: we didn't need a second reviewer, since the Content Designer was right next to the developer, for other contributors take extra care.

## How to merge a change from an external contributor

As described in the [Pull Request merging RFC](https://github.com/alphagov/govuk-rfcs/blob/2135a4c9363a499a7182e7594d6c4054422e76a1/rfc-052-pull-request-merging-process.md#a-change-from-an-external-contributor) we have a slightly different process for contributions that are not from people in the alphagov organisation.

The main things to note are that we require extra effort in reviews to make sure we don't accidentally merge something malicious.

1. Get a second reviewer, see RFC reference for details.
2. Get Continuous Integration to run their Pull Request so that the build will pass.

### Getting the build to pass

You'll need to pull their branch and push it yourself to trigger the build, this relies on the fact that their commit will be the same in the branch you push up. You can then remove this branch after this process is finished.

```bash
# Make sure you're up-to-date
git pull

# Fetch their forked branch, replace `thomasjhughes` with their username
# and `patch-1` if their branch is not called `patch-1`
git fetch https://github.com/thomasjhughes/publisher patch-1:thomasjhughes-patch-1

git checkout thomasjhughes-patch-1

git push --set-upstream origin thomasjhughes-patch-1
```

Since you're pushing the same commit up to remote, it will trigger the original PR to update with commit being tested.

Once the build has completed and you've merged the PR, make sure to [clean up your temporary branch](https://github.com/alphagov/publisher/branches)

Finally make sure to make them feel awesome for contributing (emoji heavy responses encouraged).
