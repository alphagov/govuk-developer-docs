---
owner_slack: "#govuk-developers"
title: SNYK
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

[SNYK][snyk] is a software testing tool which provides a number of different scan types. Initially, it has been configured to provide Static Application Security Testing (SAST) which checks for vulnerability signatures in a repository's codebase and Software Composition Analysis (SCA) which cross references all the included software packages in a project against a CVE (common vulnerabilities and exposures) database to ensure none are vulnerable to any known issues. It is [configured as a reusable workflow][reusable-snyk] and should be included as a job in the CI pipeline of all GOV.UK repositories. A reusable workflow design was selected so that enhancements to the scanning process can be managed centrally.

[snyk]: https://snyk.io/
[reusable-snyk]: https://github.com/alphagov/govuk-infrastructure/pull/1016

## Add SNYK to a project

To use the SNYK reusable workflow, add the following job to the `jobs` section of your CI workflow:

```yaml
snyk-security:
  name: SNYK Security Analysis
  uses: alphagov/govuk-infrastructure/.github/workflows/snyk-security.yml@main
  secrets: inherit
  permissions:
    contents: read
    security-events: write
    actions: read
```

## Where to find Security Alerts

The scan outputs the scan alerts in SARIF format and uploads the file to Code scanning. If alerts are present, they can be found in the Code scanning section in Github by selecting Security > Code scanning.

## Dealing with Security Alerts

Currently, SNYK is configured to [only identify vulnerabilities of a high severity][snyk-config]. Additionally, it will not fail the test when vulnerabilities are found: it will only raise an alert and move on. This is to reduce the number of false positives and avoid wasting developer time. Over time, we intend to tune the dial to make SNYK more strict.

Alerts can be resolved either by fixing the identified vulnerability or by dismissing the alert as a false positive in the .snyk file of the project. More details on this can be found in the [SNYK documentation][snyk-docs]. If you do decide to ignore a warning, you must include a note outlining why it is a false positive and not a security vulnerability.

[snyk-config]: https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/snyk-security.yml#L20
[snyk-docs]: https://docs.snyk.io/scan-using-snyk/policies/the-.snyk-file
