---
owner_slack: "#govuk-developers"
title: Merge a Pull Request
section: GitHub
layout: manual_layout
parent: "/manual.html"
---

There are five rules for reviewing and merging PRs, which apply to all applications:

1. The `main` branch must be able to be released at any time.
2. The change must have two reviews from people from GDS (preferably GOV.UK). This can (and normally will) include the author.
3. If a branch is force-pushed or rebased after a review on its PR, the author must dismiss the stale review and ask for a new one, unless the change is a rebase on top of a small piece of work and the author is confident there are no side effects.
4. The GitHub review UI should be used to mark a PR as approved or requiring changes.
5. The GitHub UI should be used to merge the PR. This ensures the PR number is added to the merge commit.

We're doing more and more [continuous deployment](https://docs.google.com/document/d/1YhgjJjDRB57-IlgPNAAZzFTI3jIUucGJKokti_lQiRQ/edit) these days, which means that merging to `main` on some apps is [restricted to those with Production access](https://github.com/alphagov/govuk-saas-config/search?q=need_production_access_to_merge&unscoped_q=need_production_access_to_merge), as doing so auto-deploys to Production. If an app is continuously deployed, the PR template will show a warning triangle emoji. For apps that are not continuously deployed, you should deploy your changes all the way to Production as soon as possible after merging them.

## Example scenarios

### A simple change

A small PR for a well-understood application, written by someone with good knowledge of the problem domain and with a well-defined scope. When a PR is created, someone with similar understanding of the application and change can approve and merge the PR. Both people are very confident that `main` will be deployable once this PR is merged.

### A simple change for a repository that has a long-running test suite

Similar to the above. If a PR is for an application that has a long-running test suite, you've approved the change and are confident that the suite will pass, the reviewer can approve the PR. The author of the PR now has approval to merge it themselves once the test suite has passed.

### A simple change that needs a small rebase before being merged

Similar to the above, but it includes a change in the Gemfile which then conflicts with another, unrelated Gemfile change that is merged before this one. The author of the PR can keep any existing approvals on the PR, rebase the branch to remove the conflict, and merge the PR.

### A simple change that needs a large rebase before being merged

Similar to the above, but the changes made conflict with a number of large refactoring-style changes made in another branch that is merged before this one. The author of the PR should rebase the branch to remove the conflicts, dismiss any existing (now stale) approvals, and ask for a new review.

### A change where a reviewer doesn't have the full context or knowledge required

Some changes require different levels of context and knowledge. For example, a PR which involves a lot of CSS changes may not be easily reviewable by a backend developer. They may have the product context required to be able to review the before and after screenshots and say "this looks good to me", but not understand the implications of the code changes. In this instance, you can leave a review comment with something like "Looks good to me, but I'd appreciate an additional review from someone with more frontend knowledge". If you can, you should also \@mention someone who you think may be better placed to review it. This is essentially registering your review as a half review. Someone else with the other half of the knowledge (or full knowledge) can then merge the PR once they've reviewed it.

### A change that has timing or dependency implications

If a change is ready to be reviewed but must wait to be merged for some other event, the title should be prefixed with `[Do not merge]`. A description of what the PR is waiting for should be included in the main description of the PR. When a change like this is reviewed, you can simply approve the PR. It's then up to the author to merge that PR when the correct conditions are met.

### A change from a non-developer

Some repositories, such as [smart-answers](https://github.com/alphagov/smart-answers), regularly have PRs opened by content designers, which usually only change text content. These changes should be welcomed, as they've saved a developer from having to make them!

When reviewing these PRs, you should not expect them to be at the same commit structure standard as we'd expect of developers. Changes are often made individually through the GitHub UI, which tends to lead to PRs with lots of commits, each changing a single file at a time.

A verbose commit structure isn't itself a problem, and can be merged as-is if you do not think it would be difficult to unpick later on. However, if it makes sense to do so, consider using the "Squash and merge" feature on GitHub (you'll be asked to specify one overall commit message before merging), or rebase the commits yourself for more control.

### A change from an external contributor

We occasionally receive PRs from external contributors who use our code. These will come from forks of the main repository. Typically this will be from someone outside GOV.UK but inside GDS, in which case you can treat it as normal (ie review it normally), except that you will have to merge when satisfied (the originator may not have permission to merge)

If the PR comes from outside GDS entirely, you will need to be a little more cautious. Two people from GDS should review this PR, focusing on anything that might be malicious and damaging if run inside our infrastructure. The first reviewer should approve the PR, and the second reviewer should merge. You should then thank the contributor with an amount of emoji proportional to the time they're saving GDS developers.

#### Dependabot

As Dependabot changes the Gemfile/Gemfile.lock, or some other package
management related manifests in the repository, when reviewing the
diff, you should especially check if this is the case. Dependabot
shouldn't be making changes other than these.

As well as reviewing the diff, take note of the version changes
involved, and consider looking at the release notes or changelog for
the affected packages.

If you decide that particular versions are inappropriate, then you can
inform Dependabot through commands like `@dependabot ignore this major
version`. If you do this, add the PR to the [tech debt Trello
board][tech-debt].

[tech-debt]: https://trello.com/b/oPnw6v3r

### A change where two people worked on the same branch

If two developers worked on the same branch and individually contributed commits, they can approve each other's work. If they worked as a pair, that pair counts as a single contributor, so someone else should review the work.

## Other considerations

1. When opening a PR, if you don't feel confident about your change and want a particular review from someone, it's OK to ask for that review in the PR description. For example, if you are changing a Helm template and are unfamiliar with Helm, you can ask for a review from Platform Engineering team.
2. It's OK for someone other than the author to merge a PR, particularly if the author is not available. That person should be confident that the change doesn't have dependencies on other changes, and that it won't break `main`.
3. If a PR is particularly good, remember to praise the author for it. Emoji are a great way of showing appreciation for a PR that fixes a problem you've been having, or implements something you've wanted to do for a while.
4. It's sometimes OK for merges to happen when test suites are failing. This ability is limited to repository administrators and account owners, so ask them if you need them to force a merge. This is particularly useful in a catch-22 situation of two repositories with failing test suites that depend on each other.
