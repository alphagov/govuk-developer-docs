---
owner_slack: "#govuk-developers"
title: Brakeman
section: Testing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-15
review_in: 12 months
---

[Brakeman][brakeman] is a static analysis tool which checks Rails applications
for security vulnerabilities. It is effectively a type of linter, similar to
[govuk-lint][]. It is [configured to run automatically][automatic-brakeman] as
part of the CI build process of any Rails application.

[brakeman]: https://github.com/presidentbeef/brakeman
[govuk-lint]: https://github.com/alphagov/govuk-lint
[automatic-brakeman]: https://github.com/alphagov/govuk-jenkinslib/pull/19

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
