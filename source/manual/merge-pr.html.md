---
owner_slack: "#govuk-2ndline"
title: Merge a Pull Request
section: Development & Reviews
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-08
review_in: 6 months
---

There are just four rules of reviewing and merging PRs:

1. `master` must be able to be released at any time.
2. The change must have two reviews from people from GDS (preferably GOV.UK). This can (and normally will) include the author.
3. Use the Github Review UI to mark a PR as approved or requiring changes.
4. Use the Github UI to merge the PR. This ensures the PR number is added to the merge commit.

These rules apply to all applications, including Whitehall. As long as these rules are followed, PRs can be reviewed and merged in a way best suited to the situation.

### Example scenarios

#### A simple change

A small PR against a well-understood application, written by someone with good knowledge of the problem domain and with a well defined scope. When a PR is raised, someone with similar understanding of the application and change can just approve and merge the PR. Both people are very confident that master will be deployable once this PR is merged.

#### A simple change for a repository that has a long running test suite

Similar to the above. If a PR is against a repository that has a long running test suite and you've approved the change and are confident that the suite will pass, the reviewer can approve the Pull Request. The author of the PR now has approval to merge the PR themselves once the test suite has passed.

#### A change where a reviewer doesn't have the full context or knowledge required

Some changes require different levels of context and knowledge. For example, a PR which involves a lot of CSS changes may not be easily reviewable by a backend developer. They may have the product context required to be able to review the before and after screenshots and say "this looks good to me", but not understand the implications of the code changes. In this instance you can leave a review comment with something like "Looks good to me, but I'd appreciate an additional review from someone with more frontend knowledge". If you can, you should also&nbsp;@mention someone who you think may be better placed to review it. This is essentially registering your review as a half review. Someone else with the other half of the knowledge (or full knowledge) can then merge the PR once they've reviewed it.

#### A change that has timing or dependency implications

If a change is ready to be reviewed but must wait to be merged for some other event, the title should be prefixed with&nbsp;`[Do not merge]`. A description of what the PR is waiting for should be included in the main description of the PR. When a change like this is reviewed, you can simply approve the Pull Request. It's then up to the author to merge that PR when the correct conditions are met.

#### A change from an external contributor

We occasionally receive PRs from external contributors who use our code. These will come from forks of the main repo. In the majority of cases, our test suite will not run automatically against these PRs. First, review the code carefully for anything that might be malicious and damaging if run inside our infrastructure. Once you're satisfied, follow Github's instructions to pull the forked branch locally, then push it to origin. This will cause the test suite to run with the original commits, which will cause Github to (hopefully, eventually) green light the original PR. Two people from GDS should review this PR. The first reviewer should approve the PR, and the second reviewer should merge. You should also thank the contributor with an amount of emoji proportional to the time they're saving GDS developers.

#### A change where two people worked on the same branch

If two members of GOV.UK staff worked on the same branch and individually contributed commits, they can approve each other's work. If they worked as a pair, that pair counts as a single contributor, so someone else should review the work.

### Other considerations

1. When raising a PR, if you feel you don't have full confidence in your change and want a particular review from someone, it's ok to ask for that review in the PR description. For example, a puppet change might warrant a particular review from a member of the Reliability Engineering team.
2. It's ok for someone other than the author to merge a PR, particularly if the author is off work. The merger should be confident that the change doesn't have dependencies on other changes, and that it won't break master.
3. If a PR is particularly good, remember to praise the author for it. Emoji are a great way of showing appreciation for a PR that fixes a problem you've been having, or implements something you've wanted to do for a while.
4. It's sometimes ok for merges to happen when test suites are failing. This ability is limited to repo administrators and account owners, so ask them if you need them to force a merge. This is particularly useful in a catch-22 situation of two repos with failing test suites that depend on each other.
