---
owner_slack: "#govuk-developers"
title: Pact Testing
section: Testing
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Pact](https://docs.pact.io/) is a tool we use for *contract testing*. Contract testing involves creating a set of tests that are shared between an API (the "provider") and its users ("consumers") using some kind of "broker". For example, the Publishing API has a "pact" or "contract" with GDS API Adapters:

- the expected interactions are defined in [imminence_api_pact_test.rb in GDS API Adapters](https://github.com/alphagov/gds-api-adapters/blob/master/test/imminence/imminence_api_pact_test.rb)
- when these tests are run they output a JSON pactfile which is published to [our pact broker](https://github.com/alphagov/govuk-pact-broker) ([live site](https://pact-broker.cloudapps.digital/))
- the build of Imminence will setup a [test environment](https://github.com/alphagov/imminence/blob/9a4801da9d58be0af886d9095328894aac56917c/spec/service_consumers/pact_helper.rb) and use this pactfile to test the real API

GDS API Adapters is really a proxy for real "consumer" apps, like Whitehall. We have [a set of shared stubs](https://github.com/alphagov/gds-api-adapters/tree/master/lib/gds_api/test_helpers) that are used to test GDS API Adapters with each app - ensuring they are in sync. GDS API Adapters can then do "proper contract testing" on behalf of all the apps that use it.

## Running Pact tests locally

Example for Frontend (provider of `/bank-holidays.json`):

```sh
bundle exec rake pact:verify
```

You can also test against a specific branch of GDS API Adapters:

```sh
env PACT_CONSUMER_VERSION=branch-<branch-of-gds-api-adapters> bundle exec rake pact:verify
```

_Note: when a build runs for GDS API Adapters, [the generated JSON pact is pushed to the broker as `branch-<branch-name>`](https://github.com/alphagov/gds-api-adapters/blob/59cf7dbcf6b70a6d7ef68b3ed8b05b83cb40ecf2/Jenkinsfile#L7) using [the `pact:publish:branch` rake task](https://github.com/alphagov/gds-api-adapters/blob/59cf7dbcf6b70a6d7ef68b3ed8b05b83cb40ecf2/Rakefile#L26); this is why `PACT_CONSUMER_VERSION` needs to start with `branch-`._

Alternatively, you can test against local changes to GDS API Adapters:

```sh
env PACT_URI="../gds-api-adapters/spec/pacts/gds_api_adapters-bank_holidays_api.json" bundle exec rake pact:verify
```

## Adding tests for a new app

_If the app already had some Pact tests, follow [the steps for changing existing Pact tests](#changing-existing-pact-tests)._

1. Write the consumer and provider tests.
  - [Consumer example](https://github.com/alphagov/gds-api-adapters/pull/1066).
  - [Provider example](https://github.com/alphagov/imminence/pull/644).

1. Check the consumer tests pass locally.
  - CI won't do this for you yet because it doesn't know about the new app.

1. Merge the consumer tests for the new app.
  - Warning: the build will pass because it runs with the old Jenkinsfile.

1. Check the main build of the consumer.
  - [This will clone the default branch of the provider](https://github.com/alphagov/gds-api-adapters/blob/ddb49a487f5c8b5e28f74b81d98660fb2c02d98d/Jenkinsfile#L72) and [try to test it](https://github.com/alphagov/gds-api-adapters/blob/ddb49a487f5c8b5e28f74b81d98660fb2c02d98d/Jenkinsfile#L82).
  - The build should fail until the provider part is merged.

1. Merge tests for the provider.
  - Re-run the build if you made the PR before merging the consumer one.

1. Re-run the main build for the consumer.
  - This will pass because the provider part now exists on the default branch.

## Changing existing Pact tests

Follow these steps in order to change the provider and consumer in tandem.

1. Make the change to the API (your provider, e.g. Imminence), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the consumer.

1. Make the change to the pactfile in the consumer (e.g. GDS API Adapters), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the provider.

1. Run a parameterised build of the consumer, specifying the new branch name of the provider to test against.
  - The build should pass so you can now merge the PR, which will mean the change is on the default branch.

1. Re-run the build for the provider PR now the consumer is merged.
  - The build should pass so you can now merge the PR.

## Special cases and tech debt

Publishing API and Content Store have a direct pact, with [Publishing API acting as the consumer](https://github.com/alphagov/publishing-api/tree/dd8dd9232d3cbf33b8945fdd898ebe80d7dcfcf6/spec/pacts/content_store) and [Content Store acting as the provider](https://github.com/alphagov/content-store/blob/de729dfe12e6e9da4a27a52259f59b9051e4da27/spec/service_consumers/pact_helper.rb#L32). This can be confusing as [Publishing API is also a provider for GDS API Adapters](https://github.com/alphagov/publishing-api/blob/dd8dd9232d3cbf33b8945fdd898ebe80d7dcfcf6/spec/service_consumers/pact_helper.rb#L20). It's unclear if the direct pact was intentional. In future we should consider changing Publishing API to use GDS API Adapters to talk to Content Store and have an indirect pact like we do for all other apps.
