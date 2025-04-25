---
owner_slack: "#govuk-developers"
title: Dependency Review
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

The [Dependency Review action][dependency-review-action] is a Software Composition Analysis (SCA) scan which diffs the old code and new code to identify whether there are any changes to the dependencies included in the project. It's [configured as a reusable workflow][reusable-workflow] and should be included as a job in the CI pipeline of all GOV.UK repositories. The reusable workflow enables enhancements to the scanning process to be managed centrally.

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

Alerts can always be found in the job logs. There's also a job summary displayed beneath the GitHub Action run where changes are summarised, along with any vulnerabilities found.

## Dealing with Security Alerts

See [this guidance on security alerts](/manual/security-alerts.html).
