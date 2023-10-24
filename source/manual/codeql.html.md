---
owner_slack: "#govuk-developers"
title: CodeQL
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

[CodeQL][codeql] is a Static Application Security Testing (SAST) tool which checks for vulnerability signatures in a repositories codebase. It is [configured as a reusable workflow][reusable-codeql] and should be included as a job in the CI pipeline of all GOV.UK repositories. A reusable workflow design was selected to that enhancements to the scanning process can be managed centrally.

[codeql]: https://codeql.github.com/
[reusable-codeql]: https://github.com/alphagov/govuk-infrastructure/pull/936

## Adding CodeQL to a project

To use the CodeQL reusable workflow, add the following job to the jobs section of your CI workflow:

```codeql-sast:
  name: CodeQL SAST scan
  uses: alphagov/govuk-infrastructure/.github/workflows/codeql-analysis.yml@main
  permissions:
    security-events: write
```

## Where to find Security Alerts

To find the security alerts for a repo, first go to the Security tab of the repo and then the Code Scanning option under the Vulnerability Alerts in the sub menu. This is where all [alerts can be found][codeql-alerts].

[codeql-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository

Additionally, when a PR is created, CodeQL scans the diff to identify vulnerabilities in the new code. [These can be found][codeql-pr-alerts] on the Checks tab of the PR. Select Code Scanning Results and then CodeQL.

[codeql-pr-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/triaging-code-scanning-alerts-in-pull-requests#code-scanning-results-check

## Dealing with Security Alerts

The initial configuration of CodeQL means that only vulnerabilities of a high severity and high precission are identified. This is to reduce the number of false positive alerts and prevent wastage of developer time.

Additionally, it will not fail the test when vulnerabilities are found, it will only create an alert and move on. This is to ensure that progress is not interrupted by false positives.

 Alerts can be resovled either by fixing the identified vulnerability or by dismissing the alert as a false positive. More details on this can be found in the [CodeQL documentation][codeql-docs].

[codeql-docs]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository

CodeQL will provide a recommendation on how to resolve a vulnerability along with references for additional research.

If you do decide to ignore a warning, you must include a note outlining why
it is a false positive and not a security vulnerability.
