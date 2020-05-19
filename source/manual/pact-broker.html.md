---
owner_slack: "#govuk-developers"
title: Pact Broker
section: Testing
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-18
review_in: 6 months
---

[Pact](https://docs.pact.io/) is a tool for *consumer-driven contract testing*.
It's a way of testing the integration between microservices without performing
end-to-end testing.

"Consumer-driven" means that the consumer of a service sets expectations about
behaviour it needs from the provider.

For example, [the publishing API is set up to run pact tests](https://github.com/alphagov/publishing-api/blob/master/doc/pact_testing.md).
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
