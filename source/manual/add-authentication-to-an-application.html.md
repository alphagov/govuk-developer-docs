---
owner_slack: "#govuk-developers"
title: Add authentication to an application
parent: "/manual.html"
layout: manual_layout
section: Applications
---

The process outlined here relies on the [data sync][] to synchronise
credentials between production and staging which will mean that you will have
to wait overnight from starting this to completing.

## Setting up authentication for your Ruby application

Prior to merging authentication into an existing application there are a
[number of steps](#before-an-application-can-be-deployed-with-authentication)
that need to be performed so that users and applications can access the app
immediately.

To set up an application:

1. Install [GDS-SSO gem][gds-sso-gem] as per the gem instructions.
2. Determine whether the whole application or just particular routes need
   authentication.
3. Configure the application to require authentication. If you're using a
   non-Rails app, check [OmniAuth][] documentation (GDS-SSO uses OmniAuth).
4. Update the application tests so that there is a user created or mocked for
   tests. [Example commit][gds-sso-test-user].
5. If the application is part of [Publishing End-to-end Tests][publishing-e2e]
   then you may need to add user creation to the database seeds.
   [Example commit][e2e-database-seeds].

## Before an application can be deployed with authentication

1. Your application will need to be registered as an application in
   [signon](../apps/signon.html) in [production][signon-production] and
   [integration][signon-integration]. Staging is not required as it will be
   synced with production as part of the [data sync][].
   - Create the application in signon with a [rake task][app-create-rake]
   - Make a note of the `oauth_id` and `oauth_secret` for each environment
2. *API application only:* Create bearer tokens for all the applications that will
   need authenticated access to your application.
   - Identify each of the applications that communicate with your application,
     the [Architectural overview of GOV.UK applications][arch-overview] may
     help, and determine whether they need authenticated access.
   - For each of these:
     - Find or create an API user for the application in
       [Production][api-user-production] and
       [Integration][api-user-integration];
     - Run the "Add application token" action to create a token for the
       application added in step 1;
     - Make a note of the created token;
     - Add any necessary app permissions to the application access.
3. Add the tokens and OAuth credentials you have created to [govuk-secrets][].
   This is so they can be used in Puppet hieradata. The production tokens should
   also be added to the staging secrets. [Example PR][secrets-example-pr].
4. Create environment variables in [govuk-puppet][] for the tokens you have
   created. [Example PR][puppet-example-pr].
   - If your application runs on the draft stack you'll also need to ensure
     it can communicate with signon. [Example PR][draft-signon-example-pr].
5. *API application only:* Use the bearer tokens in applications that need to
   authenticate with your application.
   - Applications differ in how they configure bearer token.
   - The ideal approach is for the bearer token to be set automatically in
     [GDS API Adapters][gds-api-factory].
   - You may need to update [lib/services.rb][lib-services-example] or find
     where GdsApi classes are [initiailised][whitehall-rummager].
6. Once all these changes are merged and deployed you should see the
   environment variables set up in the appropriate environments.

## Deploying

If you are adding authentication to an existing application, the deployment
process should be approached with caution as a mistake in copying the
tokens could break the app in any of the environments.

Once you have completed all the steps above, you should start by deploying the
branch of your application to integration and check that:

- Authentication is enabled - this can be achieved by doing a cURL request on
  the box against a known authenticated route of the application;
- Check the logs to ensure the application is successfully processing requests.

Once this is verified the branch can be merged.

Prior to deploying to staging and production, you should inform 2nd line so they
are prepared for any problems. For each environment you deploy to you should
repeat the same checks that authentication is enabled and that the application
is still successfully processing requests.

[gds-sso-gem]: https://github.com/alphagov/gds-sso
[data sync]: https://docs.publishing.service.gov.uk/manual/alerts/data-sync.html
[Omniauth]: https://github.com/omniauth/omniauth
[gds-sso-test-user]: https://github.com/alphagov/content-store/pull/498/commits/f405ca84940efe9705ee48fc21f373dacc05da63
[publishing-e2e]: https://github.com/alphagov/publishing-e2e-tests
[e2e-database-seeds]: https://github.com/alphagov/content-store/pull/498/commits/cf41056f3cee446ef94043f3a3b074c71bcfa7d6
[signon-integration]: http://signon.integration.publishing.service.gov.uk
[signon-production]: http://signon.publishing.service.gov.uk
[app-create-rake]: https://github.com/alphagov/signon/blob/master/docs/usage.md#setup-rake-tasks
[arch-overview]: https://docs.publishing.service.gov.uk/manual/architecture.html
[api-user-production]: https://signon.publishing.service.gov.uk/api_users
[api-user-integration]: https://signon.integration.publishing.service.gov.uk/api_users
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[secrets-example-pr]: https://github.com/alphagov/govuk-secrets/pull/517
[puppet-example-pr]: https://github.com/alphagov/govuk-puppet/pull/8426
[draft-signon-example-pr]: https://github.com/alphagov/govuk-puppet/pull/8439
[gds-api-factory]: https://github.com/alphagov/gds-api-adapters/pull/852
[lib-services-example]: https://github.com/alphagov/publisher/blob/008b79a902795aa25d102913e2f4f2fde1ac834b/app/lib/services.rb
[whitehall-rummager]: https://github.com/alphagov/whitehall/blob/7b5c5a086b89cb62ffba62b152a0a8dcfc10c8e6/config/initializers/rummager.rb
