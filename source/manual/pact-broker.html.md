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

This has to be done in several stages:

1. Write the consumer tests ([example](https://github.com/alphagov/gds-api-adapters/pull/1035)).
1. Write the provider pact ([example](https://github.com/alphagov/frontend/pull/2643)).
  - You'll need to write these two in conjunction with each other.
1. Merge both of the above PRs.
1. Configure the provider to test against the default branch of the consumer as part of its deployment pipeline ([example](https://github.com/alphagov/frontend/pull/2644)).
  - You'll need to expose this as a rake task that takes a branch argument (see the example PR above). This is needed in the next step.
1. Merge.
1. Configure the consumer to test against the provider as part of its deployment pipeline, using the rake task defined above ([example](https://github.com/alphagov/gds-api-adapters/pull/1036)).
1. Merge.

## Changing existing Pact tests

Due to the co-dependent nature of Pact providers and consumers, changes need to be made in a particular order:

1. Make the change to the API (your provider, e.g. Frontend), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the consumer.
1. Make the change to the pactfile in the consumer (e.g. gds-api-adapters), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the provider.
1. Run a parameterised build of the consumer, specifying the new branch name of the provider to test against.
  - The build should pass.
1. Merge the consumer PR, followed by the provider PR.
