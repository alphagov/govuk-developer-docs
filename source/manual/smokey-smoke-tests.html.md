---
title: Smoke testing with smokey
section: Testing
layout: manual_layout
parent: "/manual.html"
owner_slack: "#2ndline"
last_reviewed_on: 2017-07-01
review_in: 6 months
---

We have [smoke tests][smokey] running against our infrastructure to verify
that core functionality of the site is working.

## Integration with Signon

These tests rely on a user in [GOV.UK Signon][signon]. All Signon users have their passphrase expire periodically. This will cause the tests to fail.

You can either change the passphrase of the account and rotate it in encrypted
hieradata, or you can fake a passphrase change in the Signon Rails console:

```
$ govuk_app_console signon
irb(main):001:0> smokey = User.find_by(email: 'EMAIL_OF_THE_TEST_ACCOUNT')
irb(main):002:0> smokey.password_changed_at = Time.now
irb(main):003:0> smokey.save!
```

[smokey]: https://github.com/alphagov/smokey
[signon]: https://github.com/alphagov/signon
