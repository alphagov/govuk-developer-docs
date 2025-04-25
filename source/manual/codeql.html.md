---
owner_slack: "#govuk-developers"
title: CodeQL
section: Testing
layout: manual_layout
type: learn
parent: "/manual.html"
---

[CodeQL][codeql] is a Static Application Security Testing (SAST) tool which checks for vulnerability signatures in a repository's codebase. It's [configured as a reusable workflow][reusable-codeql] and should be included as a job in the CI pipeline of all GOV.UK repositories. The reusable workflow enables enhancements to the scanning process to be managed centrally.

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

To find the security alerts for a repo, go to the Security tab of the repo and select the Code Scanning option in the Vulnerability Alerts sub menu. This is where [all alerts][codeql-alerts] can be found.

Additionally, when a PR is created, CodeQL scans the diff to identify vulnerabilities in the new code. These [PR specific alerts][codeql-pr-alerts] can be found on the Checks tab of the PR: select "Code scanning results" and then "CodeQL".

[codeql-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/managing-code-scanning-alerts-for-your-repository
[codeql-pr-alerts]: https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/triaging-code-scanning-alerts-in-pull-requests#code-scanning-results-check

## Dealing with Security Alerts

See [this guidance on security alerts](/manual/security-alerts.html).

## Troubleshooting

CodeQL scans may fail because they cannot find source code for a specified language, despite detecting other languages:

```
Extracting javascript
Extracting ruby
Finalizing javascript
Finalizing ruby
  /opt/hostedtoolcache/CodeQL/2.17.1/x64/codeql/codeql database finalize --finalize-dataset --threads=4 --ram=14567 /home/runner/work/_temp/codeql_databases/ruby
  CodeQL detected code written in JavaScript/TypeScript, but not any written in Ruby. Confirm that there is some source code for Ruby in the project. For more information, review our troubleshooting guide at https://gh.io/troubleshooting-code-scanning/no-source-code-seen-during-build .
  Error: Encountered a fatal error while running "/opt/hostedtoolcache/CodeQL/2.17.1/x64/codeql/codeql database finalize --finalize-dataset --threads=4 --ram=14567 /home/runner/work/_temp/codeql_databases/ruby". Exit code was 32 and last log line was: CodeQL detected code written in JavaScript/TypeScript, but not any written in Ruby. Confirm that there is some source code for Ruby in the project. For more information, review our troubleshooting guide at https://gh.io/troubleshooting-code-scanning/no-source-code-seen-during-build . See the logs for more details.
```

There currently is [no solution](https://github.com/alphagov/govuk-browser-extension/pull/196) to this problem. Removing all code in the problematic language might resolve the issue, but this is not a viable solution for most projects.
