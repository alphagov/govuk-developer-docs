---
owner_slack: "#govuk-developers"
title: Security Alerts Guidance
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

This page outlines the recommended process for handling security alerts raised by our static analysis tools (Brakeman, CodeQL, Dependency Review) and GitHub's native security features (Dependabot and Code Scanning).

## General Alert Review Process

When a security alert is raised, follow these steps:

1. **Investigate the alert** to determine if it’s a real vulnerability.
2. If **action is required**, fix the issue in an appropriate timeframe based on the severity.
3. If **no action is required**, dismiss the alert with a reason and an explanatory comment.

> ⚠️ Do **not** create public GitHub issues for security vulnerabilities. They may expose sensitive information.

### Dismissing Alerts

When dismissing an alert, choose one of the predefined reasons in GitHub. You must add a comment explaining your reasoning and any supporting investigation. This ensures traceability and context for future reviewers.

---

## Tool-Specific Guidance

### Brakeman

Brakeman alerts are static analysis results for Ruby applications.

- If you ignore a Brakeman alert, you **must** also manually dismiss the associated GitHub security alert.
- Always provide a note explaining why the alert is considered a false positive.

### CodeQL (Code Scanning)

CodeQL is currently [configured to only identify vulnerabilities of high severity and precision](https://github.com/alphagov/govuk-infrastructure/blob/f9c3b2bddf407d78c04552563a4ba23a89c8af61/.github/workflows/codeql-analysis.yml#L24-L35).

- CodeQL does **not block builds**; it simply creates alerts for later review.
- Alerts include recommendations and references for resolving issues. More details on this can be found in the [CodeQL documentation](https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository).
- You may fix or dismiss alerts, but dismissals **must** include a comment explaining why.

### Dependency Review

Dependency Review checks for known vulnerabilities in pull requests. It's currently [configured to find "critical" issues](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/dependency-review.yml).

- It **blocks merges** when critical issues are found.
- Alerts are resolved by updating the dependency and re-running the checks.
- To dismiss an alert:
  - Add the GitHub Advisory Database ID (GHSA) to the [`allow-ghsas` list](https://github.com/marketplace/actions/dependency-review?tab=readme-ov-file#configuration-options) in the [inline configuration](https://github.com/marketplace/actions/dependency-review?tab=readme-ov-file#option-1-using-inline-configuration).
  - Provide a clear, documented reason in a code comment.

> Dismissing via `allow-ghsas` should be rare and well justified, as this affects the shared workflow.

---

## Dependabot Alerts

Dependabot monitors dependencies and opens PRs for known vulnerabilities.

- Teams should regularly review and resolve these alerts.
- Fixing the dependency and merging the PR will automatically close the alert.

---

## Related Links

- [Brakeman docs](https://docs.publishing.service.gov.uk/manual/brakeman.html)
- [CodeQL docs](https://docs.publishing.service.gov.uk/manual/codeql.html)
- [Dependency Review docs](https://docs.publishing.service.gov.uk/manual/dependency-review.html)
- [Manage dependencies with Dependabot](https://docs.publishing.service.gov.uk/manual/manage-dependencies.html)
