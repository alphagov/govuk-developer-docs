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

CodeQL scans may fail because they cannot find analysable source code for a
detected language. Some examples are provided in the "Example failures"
subsection below.

A workaround for this issue is to exclude such languages from CodeQL analysis.
You can do this by passing in a `languages` input value to the code action. You
should set this to all the other languages CodeQL automatically detects as
indicated by the `Extracting [language]` lines in the job output.

A minimal example based on a [govuk-content-api-docs
PR](https://github.com/alphagov/govuk-content-api-docs/pull/205):

```yaml
  codeql-sast:
    uses: alphagov/govuk-infrastructure/.github/workflows/codeql-analysis.yml@main
    with:
      languages: actions,ruby
```

See the [CodeQL docs on "Changing the languages that are
analyzed"](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#changing-the-languages-that-are-analyzed)
for a list of language identifiers.

### Example failures

```
Extracting javascript
Extracting ruby
Finalizing javascript
Finalizing ruby
  /opt/hostedtoolcache/CodeQL/2.17.1/x64/codeql/codeql database finalize --finalize-dataset --threads=4 --ram=14567 /home/runner/work/_temp/codeql_databases/ruby
  CodeQL detected code written in JavaScript/TypeScript, but not any written in Ruby. Confirm that there is some source code for Ruby in the project. For more information, review our troubleshooting guide at https://gh.io/troubleshooting-code-scanning/no-source-code-seen-during-build .
  Error: Encountered a fatal error while running "/opt/hostedtoolcache/CodeQL/2.17.1/x64/codeql/codeql database finalize --finalize-dataset --threads=4 --ram=14567 /home/runner/work/_temp/codeql_databases/ruby". Exit code was 32 and last log line was: CodeQL detected code written in JavaScript/TypeScript, but not any written in Ruby. Confirm that there is some source code for Ruby in the project. For more information, review our troubleshooting guide at https://gh.io/troubleshooting-code-scanning/no-source-code-seen-during-build . See the logs for more details.
```

```
Extracting ruby
Extracting javascript
Extracting actions
Finalizing ruby
Finalizing javascript
  /opt/hostedtoolcache/CodeQL/2.23.5/x64/codeql/codeql database finalize --finalize-dataset --threads=4 --ram=14581 /home/runner/work/_temp/codeql_databases/javascript
  CodeQL detected code written in JavaScript/TypeScript but could not process any of it. For more information, review our troubleshooting guide at https://gh.io/troubleshooting-code-scanning/no-source-code-seen-during-build .
  Error: Encountered a fatal error while running "/opt/hostedtoolcache/CodeQL/2.23.5/x64/codeql/codeql database finalize --finalize-dataset --threads=4 --ram=14581 /home/runner/work/_temp/codeql_databases/javascript". Exit code was 32 and last log line was: CodeQL detected code written in JavaScript/TypeScript but could not process any of it. For more information, review our troubleshooting guide at https://gh.io/troubleshooting-code-scanning/no-source-code-seen-during-build . See the logs for more details.
```
