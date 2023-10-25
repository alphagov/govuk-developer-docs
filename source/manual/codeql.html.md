---
owner_slack: "#govuk-developers"
title: CodeQL
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

[CodeQL][codeql] is a Static Application Security Testing (SAST) tool which checks for vulnerability signatures in a repository's codebase. It is [configured as a reusable workflow][reusable-codeql] and should be included as a job in the CI pipeline of all GOV.UK repositories. A reusable workflow design was selected so that enhancements to the scanning process can be managed centrally.

[codeql]: https://codeql.github.com/
[reusable-codeql]: https://github.com/alphagov/govuk-infrastructure/pull/936

## Add CodeQL to a project

To use the CodeQL reusable workflow, add the following job to the `jobs` section of your CI workflow:

```yaml
codeql-sast:
  name: CodeQL SAST scan
  uses: alphagov/govuk-infrastructure/.github/workflows/codeql-analysis.yml@main
  permissions:
    security-events: write
```

## Where to find Security Alerts

To find the security alerts for a repo, first go to the Security tab of the repo and then the Code Scanning option under the Vulnerability Alerts in the sub menu. This is where [all alerts][codeql-alerts] can be found.

Additionally, when a PR is created, CodeQL scans the diff to identify vulnerabilities in the new code. These [PR specific alerts][codeql-pr-alerts] can be found on the Checks tab of the PR: select "Code scanning results" and then "CodeQL".

[codeql-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository
[codeql-pr-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/triaging-code-scanning-alerts-in-pull-requests#code-scanning-results-check

## Dealing with Security Alerts

Currently, CodeQL is configured to [only identify vulnerabilities of a high severity and high precision][codeql-config]. Additionally, it will not fail the test when vulnerabilities are found: it will only create an alert and move on. This is to reduce the number of false positives and avoid wasting developer time. Over time, we intend to tune the dial to make CodeQL more strict.

CodeQL will provide a recommendation on how to resolve a vulnerability along with references for additional research.

Alerts can be resolved either by fixing the identified vulnerability or by dismissing the alert as a false positive. More details on this can be found in the [CodeQL documentation][codeql-docs]. If you do decide to ignore a warning, you must include a note outlining why it is a false positive and not a security vulnerability.

[codeql-config]: https://github.com/alphagov/govuk-infrastructure/blob/f9c3b2bddf407d78c04552563a4ba23a89c8af61/.github/workflows/codeql-analysis.yml#L24-L35
[codeql-docs]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository
