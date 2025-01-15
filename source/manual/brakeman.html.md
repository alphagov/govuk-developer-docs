---
owner_slack: "#govuk-developers"
title: Brakeman
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

[Brakeman][brakeman] is a static analysis tool which checks Rails applications
for security vulnerabilities. It is effectively a type of linter, similar to
[rubocop][]. It is configured as a [reusable workflow][] and should be included
as a job in the CI pipeline of all GOV.UK Ruby repositories.

[brakeman]: https://github.com/presidentbeef/brakeman
[rubocop]: https://github.com/rubocop-hq/rubocop
[reusable workflow][https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/brakeman.yml]

## Add Brakeman to a project

To use the Brakeman reusable workflow, add the following job to the `jobs` section of your CI workflow:

```yaml
security-analysis:
  name: Security Analysis
  uses: alphagov/govuk-infrastructure/.github/workflows/brakeman.yml@main
  permissions:
    contents: read
    security-events: write
    actions: read
```

## Where to find Security Alerts

To find the security alerts for a repo, first go to the Security tab of the repo and then the Code Scanning option under the Vulnerability Alerts in the sub menu. This is where [all alerts][alerts] can be found.

Additionally, when a PR is created, Brakeman scans the diff to identify vulnerabilities in the new code. These [PR specific alerts][pr-alerts] can be found on the Checks tab of the PR: select "Code scanning results" and then "Brakeman".

[alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository
[pr-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/triaging-code-scanning-alerts-in-pull-requests#code-scanning-results-check

## Dealing with false positives

There will be times when Brakeman flags up false positives in your code. You
should try to refactor the code to satisfy Brakeman in such a way that it would
also pass a code review. There is no benefit to refactoring the code just for
Brakeman, if the resulting code is harder to understand.

There is an [example of refactoring the Content Store][content-store-example]
to satisfy Brakeman where the resulting code could be considered slightly less
elegant, but still suitable without having to ignore the warning.

[content-store-example]: https://github.com/alphagov/content-store/pull/459

You should only ignore warnings when it's not possible to refactor the code in
a way that is both elegant and satisfies Brakeman. Brakeman provides a
useful tool for ignoring warnings:

```bash
$ brakeman -I
```

It will help you decide what to do with each individual warning step by step.

If you do decide to ignore a warning, you must include a note outlining why
it is a false positive and not a security vulnerability.

## Dealing with Security Alerts

If you do decide to ignore a Brakeman alert, as described above, you will also need to close the security alert in GitHub.

Alerts can be resolved by dismissing the alert as a false positive. You must include a note outlining why it is a false positive and not a security vulnerability.
