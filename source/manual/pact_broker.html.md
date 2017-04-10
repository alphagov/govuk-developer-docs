---
title: Pact Broker
section: Tools
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/introductions/pact_broker.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/introductions/pact_broker.md)


# Pact Broker

[Pact Broker](https://github.com/bethesque/pact_broker#readme) is a repository
for consumer contracts created by the [pact
gem](https://github.com/realestate-com-au/pact). It allows consumers of an
API to publish their pact files here so that the producer of an API can use
them in its test suite to verify that it adheres to the contract.

## Information you need to know

* The URL is <https://pact-broker.cloudapps.digital/>
* It is deployed from <https://github.com/alphagov/pact-broker>
* It runs on GOV.UK PaaS (<https://www.cloud.service.gov.uk/>)

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
<https://github.com/alphagov/pact-broker>.

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
this](https://github.com/alphagov/pact-broker/blob/master/config.ru#L23-L50)
to extend the versioning scheme to allow branch builds to be uploaded as well.
In addition to numeric versions, our scheme allows for "master", and
"branch-foo" versions to be uploaded. These will always be ordered after any
numeric versions, so the 'latest' pactfile from the pact brokers POV will
always be the highest numeric version.
