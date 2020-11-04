---
owner_slack: "#govuk-2ndline"
title: Manage Signon user/API accounts and access tokens
section: Accounts
layout: manual_layout
parent: "/manual.html"
---

[Signon](https://docs.publishing.service.gov.uk/apps/signon.html) is the
single sign-on service for our admin applications. We also use it for
creating API accounts for GOV.UK applications.

## Differences between environments

User accounts from production are synced to staging every morning, so any
changes made in production will be reflected in staging the next day.

User accounts in integration are completely separate.

## How to create an account

User accounts should be created by the tech lead on the user's team. In
usual circumstances, 2nd line should not have to do this, although there
are exceptions such as when the tech lead has no admin access, or if the
user has no obvious tech lead.

### User accounts

Determine which environment the account is needed in:

- [integration signon 'users'](https://signon.integration.publishing.service.gov.uk/users)
- [staging signon 'users'](https://signon.staging.publishing.service.gov.uk/users)
- [production signon 'users'](https://signon.publishing.service.gov.uk/users)

Click 'Create user' and fill in the details. 2FA is encouraged for all,
including editors, however it is only [mandatory for admins and superadmins](https://github.com/alphagov/signon/commit/83cb90132831441fa4fb10027a03aa122a18502f#diff-4676c008b11a5480d73d4a6de01e45b9R233).

### API user accounts

Determine which environment the account is needed in:

- [integration signon 'api_users'](https://signon.integration.publishing.service.gov.uk/api_users)
- [staging signon 'api_users'](https://signon.staging.publishing.service.gov.uk/api_users)
- [production signon 'api_users'](https://signon.publishing.service.gov.uk/api_users)

Then create the account:

- Click 'Create API user'
- Fill in the name and email address of the team requesting the account
- An account will be created associated with their email address

### Create application token for the API user

- From the API user's account page, click 'Add application token'
- Select the 'Application' for which you need a token, and click 'Create access token'
- A token will be generated. Copy it to your clipboard and then manually email it to the team email address

An account can have API tokens for multiple applications.
