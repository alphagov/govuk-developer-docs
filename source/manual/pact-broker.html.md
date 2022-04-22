---
owner_slack: "#govuk-developers"
title: Pact Broker
section: Testing
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Pact](https://docs.pact.io/) is a tool we use for *contract testing*. Contract testing involves creating a set of tests that are shared between an API (the "provider") and its users ("consumers") using some kind of "broker". For example, the Publishing API has a "pact" or "contract" with GDS API Adapters:

- the expected interactions are defined in [the publishing_api_test.rb in gds-api-adapters](https://github.com/alphagov/gds-api-adapters/blob/master/test/publishing_api_test.rb)
- when these tests are run they output a JSON pactfile which is published to [our pact broker](https://github.com/alphagov/govuk-pact-broker) ([live site](https://pact-broker.cloudapps.digital/))
- the build of publishing api will use this pactfile to test the publishing-api service

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

## Adding new tests for an app

Write both parts at the same time so you can check they work together.

- [Consumer example](https://github.com/alphagov/gds-api-adapters/pull/1066)
- [Provider example](https://github.com/alphagov/imminence/pull/644)

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
