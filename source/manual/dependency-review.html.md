---
owner_slack: "#govuk-developers"
title: Dependency Review
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

The [Dependency Review action][dependency-review-action] is a Software Composition Analysis (SCA) scan which diffs the old code and new code to identify whether there are any changes to the dependencies included in the project. It is [configured as a reusable workflow][reusable-workflow] and should be included as a job in the CI pipeline of all GOV.UK repositories. A reusable workflow design was selected so that enhancements to the scanning process can be managed centrally.

[dependency-review-action]: https://github.com/marketplace/actions/dependency-review
[reusable-workflow]: https://github.com/alphagov/govuk-infrastructure/pull/966

## Add Dependency Review to a project

To use the Dependency Review reusable workflow, add the following job to the `jobs` section of your CI workflow:

```yaml
dependency-review:
  name: Dependency Review scan
  uses: alphagov/govuk-infrastructure/.github/workflows/dependency-review.yml@main
```

## Where to find Security Alerts

Alerts can always be found in the job logs. Additionally, there is a job summary displayed beneath the GitHub Action run. Here, changes are summarised along with any vulnerabilities found.

## Dealing with Security Alerts

Currently, Dependency Review is [configured to find "critical" issues][dependency-review-config]. If issues are found, the check automatically 'fails' and therefore blocks merging of the PR. We therefore want to avoid false positives and wasting developer time, so have set the bar high and only alert on critical issues. Over time, we intent to tune the dial so this becomes more strict.

Alerts can be resolved only by fixing the issue and running the tests again. Vulnerability alerts provide a link to the [GitHub advisory][gh-advisory] database where advice on resolving the issue can be found. Dismissing an alert requires adding the GitHub Advisory Database ID (GHSA) to the inline configuration [via the `allow-ghsas` property][skip-alert]. As the workflow is a communal resource, this should be done sparingly and include a well detailed comment about why it is being skipped.

[dependency-review-config]: https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/dependency-review.yml
[gh-advisory]: https://github.com/advisories
[skip-alert]: https://github.com/marketplace/actions/dependency-review#inline-configuration
