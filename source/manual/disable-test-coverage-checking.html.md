---
owner_slack: "#govuk-2ndline-tech"
title: Disable test coverage checking
section: 2nd line
layout: manual_layout
parent: "/manual.html"
---

> ⚠️ This information should only be used by 2nd line when it is necessary to
> apply a hotfix e.g. because of an ongoing incident, and they need to act
> quickly. Test coverage checking should not be disabled during normal
> development.

Some applications check for test coverage in continuous integration. If test
coverage requirement (the standard value is 95%) is not met, the testing step in
continuous integration will fail and that will prevent a pull request from being
merged.

When preparing a hotfix during a high priority incident, you sometimes do not have
enough time to write automated tests, and instead you have to test manually.
(It is always necessary to test your changes before pushing them to production.
If possible, you should write the automated tests after the incident is resolved.)
In this case it might be necessary to disable test coverage checking in order to
merge your pull request.

Depending on the application, there might be two possible test coverage checks
implemented:

1. Ruby test coverage check;
1. JavaScript test coverage check.

Depending on the change you want to make, you might need to disable one or both
of them. Perform the following steps when preparing a pull request with your
hotfix. Only disable the check that is related to your change.

## Disabling Ruby test coverage checking

Depending on the testing framework used in the application (Minitest or RSpec),
edit one of the following files:

* `test/test_helper.rb` (for Minitest)
* `spec/spec_helper.rb` (for RSpec)

Find the line specifying test coverage e.g.:

```ruby
minimum_coverage 95
```

and comment it:

```ruby
# minimum_coverage 95
```

Notify the app's owning team about the change and ensure a ticket is created for
checking if test coverage has been reenabled or reenabling it, if necessary.

## Disabling JavaScript test coverage checking

Edit the file `.nycrc` (the file might be hidden by default as it starts with
a dot), find the following line:

```json
  "check-coverage": true,
```

and change it to the following:

```json
  "check-coverage": false,
```

Notify the app's owning team about the change and ensure a ticket is created for
checking if test coverage has been reenabled or reenabling it, if necessary.
