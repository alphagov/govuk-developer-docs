---
owner_slack: "#govuk-2ndline-tech"
title: Manage Signon user/API accounts and access tokens
section: Accounts
layout: manual_layout
parent: "/manual.html"
---

[Signon](/repos/signon.html) is the
single sign-on service for our admin applications. We also use it for
creating API accounts for GOV.UK applications.

## Differences between environments

User accounts from production are synced to staging every morning, so any
changes made in production will be reflected in staging the next day.

User accounts in integration are completely separate.

## How to create an account

User accounts should be created by the tech lead on the user's team. In
usual circumstances, Technical 2nd Line should not have to do this, although there
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

## Manage user accounts

### Unsuspending a user

Find the user under the [list of users](https://signon.publishing.service.gov.uk/users).
On the edit page select `Unsuspend user`.

### Resetting a user's 2FA

Find the user under the [list of users](https://signon.publishing.service.gov.uk/users).
On the edit page under "Account security" select `Reset 2-step verification`.

## Organisations with multiple parents

This [structure cannot currently be modelled in Signon][signon-multiple-parents-issue]
which sometimes leads to Zendesk tickets where users cannot access things they should
be able to.

This can be applied manually for the day (it will reset when the organisations are
imported from Whitehall):

```rb
> parent = Organisation.find_by!(slug: "...")
> child = Organisation.find_by!(slug: "...")
> child.update!(parent: parent)
```

Or if you think it makes sense to apply this permanently,
[it can be added to the `OrganisationFetcher`][organisation-fetcher].

The decision of whether this should be applied for the day or permanently depends on
which parent organisation is more likely to need access to the child organisation.

[signon-multiple-parents-issue]: https://github.com/alphagov/signon/issues/1572
[organisation-fetcher]: https://github.com/alphagov/signon/commit/31066d931c073250f0c5d83b0312a489b12c870c
