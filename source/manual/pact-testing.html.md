---
owner_slack: "#govuk-developers"
title: Pact Testing
section: Testing
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Pact](https://docs.pact.io/) is a tool we use for *contract testing*. Contract testing involves creating a set of tests that are shared between an API (the "provider") and its users ("consumers") using some kind of "broker". For example, the Publishing API has a "pact" or "contract" with GDS API Adapters:

- the expected interactions are defined in [imminence_api_pact_test.rb in GDS API Adapters](https://github.com/alphagov/gds-api-adapters/blob/main/test/pacts/imminence_api_pact_test.rb)
- when these tests are run they output a JSON pactfile which is published to [our pact broker](https://github.com/alphagov/govuk-pact-broker) ([live site](https://pact-broker.cloudapps.digital/))
- the build of Imminence will setup a [test environment](https://github.com/alphagov/imminence/blob/9a4801da9d58be0af886d9095328894aac56917c/spec/service_consumers/pact_helper.rb) and use this pactfile to test the real API

GDS API Adapters is really a proxy for real "consumer" apps, like Whitehall. The gem includes [a set of shared stubs](https://github.com/alphagov/gds-api-adapters/tree/master/lib/gds_api/test_helpers) for use in each app's own tests ([example](https://github.com/alphagov/contacts-admin/blob/e935fa54bf71c0063bb92faeaf8a27d1618e00ee/spec/interactors/admin/clone_contact_spec.rb#L11)). Using the stubs ensures each app stays in sync with GDS API Adapters, which can then do contract testing on their behalf.

## Running Pact tests locally

### For a consumer (GDS API Adapters)

[Pact tests](https://github.com/alphagov/gds-api-adapters/tree/main/test/pacts) are run as part of the regular test suite:

```sh
bundle exec rake test
```

Or they can be run on their own:

```sh
bundle exec rake pact_test
```

### For a provider

Example for Frontend (provider of `/bank-holidays.json`):

```sh
bundle exec rake pact:verify
```

You can also test against a specific branch of GDS API Adapters:

```sh
env PACT_CONSUMER_VERSION=branch-<branch-of-gds-api-adapters> bundle exec rake pact:verify
```

_Note: when a build runs for GDS API Adapters, [the generated JSON pact is pushed to the broker as `branch-<branch-name>`](https://github.com/alphagov/gds-api-adapters/blob/bcc8e58eccf69dd37657d13156cbe11c07535844/.github/workflows/ci.yml#L37-L51) using [the `pact:publish:branch` rake task](https://github.com/alphagov/gds-api-adapters/blob/59cf7dbcf6b70a6d7ef68b3ed8b05b83cb40ecf2/Rakefile#L26); this is why `PACT_CONSUMER_VERSION` needs to start with `branch-`._

Alternatively, you can test against local changes to GDS API Adapters:

```sh
env PACT_URI="../gds-api-adapters/spec/pacts/gds_api_adapters-bank_holidays_api.json" bundle exec rake pact:verify
```

## Adding tests for a new app

_If the app already had some Pact tests, follow [the steps for changing existing Pact tests](#changing-existing-pact-tests)._

1. Write the consumer and provider tests.
  - [Consumer example](https://github.com/alphagov/gds-api-adapters/pull/1066) (Note: since this example was written [we now store pact tests in the `tests/pacts` directory](https://github.com/alphagov/gds-api-adapters/blob/main/test/pacts)).
  - [Provider example](https://github.com/alphagov/imminence/pull/644).

1. Check the tests pass locally for both provider and consumer
  - CI won't be able to test them yet as they won't be pushed to the pact broker.

1. Merge the consumer tests for the new app.
  - This will cause the [pact tests to be published to the pact broker](https://github.com/alphagov/gds-api-adapters/blob/bcc8e58eccf69dd37657d13156cbe11c07535844/.github/workflows/ci.yml#L37-L51).

1. Merge a GitHub Action ([example](https://github.com/alphagov/asset-manager/blob/7311e5dae03496bde88b4eebf7104ea162603681/.github/workflows/pact-verify.yml)) into the provider app to verify the pact
  - This will verify the provider app fulfills the contract published by the consumer.

1. Update the consumer to utilise the provider GitHub action as part of the build process ([example](https://github.com/alphagov/gds-api-adapters/blob/bcc8e58eccf69dd37657d13156cbe11c07535844/.github/workflows/ci.yml#L101-L117))
  - This will verify the provider contract when the consumer builds.

## Changing existing Pact tests

Follow these steps in order to change the provider and consumer in tandem.

1. Make the change to the API (your provider, e.g. Imminence), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the consumer.

1. Make the change to the pactfile in the consumer (e.g. GDS API Adapters), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the provider.
1. Confirm locally that the provider can verify against the published consumer pact
  - `env PACT_CONSUMER_VERSION=branch-<branch-of-gds-api-adapters> bundle exec rake pact:verify`

1. Merge the provider change
  - We've configured failing Pact tests to not block merging, so you should still be able to merge.

1. Re-run the consumer tests
  - These should pass now that the provider has been updated.

1. Merge the consumer change

## Special cases

Publishing API and Content Store have a direct pact, with [Publishing API acting as the consumer](https://github.com/alphagov/publishing-api/tree/dd8dd9232d3cbf33b8945fdd898ebe80d7dcfcf6/spec/pacts/content_store) and [Content Store acting as the provider](https://github.com/alphagov/content-store/blob/de729dfe12e6e9da4a27a52259f59b9051e4da27/spec/service_consumers/pact_helper.rb#L32). This can be confusing as [Publishing API is also a provider for GDS API Adapters](https://github.com/alphagov/publishing-api/blob/dd8dd9232d3cbf33b8945fdd898ebe80d7dcfcf6/spec/service_consumers/pact_helper.rb#L20).

The tests are run in the same way as other consumers and providers (see above).
