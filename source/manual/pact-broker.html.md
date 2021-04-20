---
owner_slack: "#govuk-developers"
title: Pact Broker
section: Testing
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Pact](https://docs.pact.io/) is a tool for *consumer-driven contract testing*.
It's a way of testing the integration between microservices without performing
end-to-end testing.

"Consumer-driven" means that the consumer of a service sets expectations about
behaviour it needs from the provider.

For example, [the publishing API is set up to run pact tests](https://github.com/alphagov/publishing-api/blob/master/docs/pact_testing.md).
This means that any consumer of the publishing API can create contracts using the pact gem,
and the publishing api deployment pipeline will check that consumers' contracts are still met by new builds.

The [Pact Broker](https://docs.pact.io/getting_started/sharing_pacts) is
a repository for all the contracts. The consumers publish to it, and the producers query from it when they run the tests.

## Information you need to know

* It runs on the Government PaaS at <https://pact-broker.cloudapps.digital/>
* It is deployed from <https://github.com/alphagov/govuk-pact-broker>

## Accessing and logging on

The application is open to the internet with no authentication for read
requests. Write requests are restricted with HTTP basic auth. These credentials
are exposed as environment variables to jobs on CI to enable them to publish
pacts to the broker.

## About the app itself

### Codebase

Pact Broker is a ruby app that's provided as [a
gem](https://github.com/bethesque/pact_broker) that needs to be wrapped in a
small rack app. The resulting 'application' lives at
<https://github.com/alphagov/govuk-pact-broker>.

### Persistence

Pact Broker stores its data in a PostgreSQL database. The location and creds for
this are passed in the `DATABASE_URL` environment variable.

### Logging

The app logs to `/var/log/pact_broker.log` and `/var/log/pact_broker.err.log`.

### Pactfile versioning

Out of the box, the Pact Broker allows uploading of pact files with semver
style versions (eg 2.0.1). For our usage, we wanted to be able to upload pact
files from various branches in addition the released versions so that our
branch builds of consumers can verify their pactfiles with the producers.

Pact Broker allows us to [implement our own versioning
scheme](https://github.com/bethesque/pact_broker/wiki/Configuration#version-parser)
by providing a custom version parser.  We've [used
this](https://github.com/alphagov/govuk-pact-broker/blob/master/config.ru#L23-L50)
to extend the versioning scheme to allow branch builds to be uploaded as well.
In addition to numeric versions, our scheme allows for "master", and
"branch-foo" versions to be uploaded. These will always be ordered after any
numeric versions, so the 'latest' pactfile from the pact brokers POV will
always be the highest numeric version.

## Writing Pact tests

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

### Updating Pact tests

Due to the co-dependent nature of Pact providers and consumers, changes need to be made in a particular order:

1. Make the change to the API (your provider, e.g. Frontend), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the consumer.
1. Make the change to the pactfile in the consumer (e.g. gds-api-adapters), in a branch.
  - Its build should fail at the Pact test stage, because it is testing against the default branch of the provider.
1. Run a parameterised build of the consumer, specifying the new branch name of the provider to test against.
  - The build should pass.
  - It should also be possible to test this locally e.g. `bundle exec rake PACT_URI="../gds-api-adapters/spec/pacts/gds_api_adapters-collections_organisation_api.json" pact:verify`.
1. Merge the consumer PR, followed by the provider PR.
