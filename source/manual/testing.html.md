---
owner_slack: "#govuk-developers"
title: 'How we test GOV.UK'
section: Testing
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK has several layers of testing:

- [Continuous Deployment checks](#continuous-deployment-checks)
  - [Smokey](#smokey)
  - [Application Healthchecks](#application-healthchecks)

- [Continuous Integration checks](#continuous-integration-checks)
  - [Contract Tests](#contract-tests)
  - [Unit, Integration, etc. Tests](#unit-integration-etc-tests)

Recommended reading: [A new standard of testing for GOV.UK](https://technology.blog.gov.uk/2021/10/08/a-new-standard-of-testing-for-gov-uk/).

This manual is about how we currently test GOV.UK. We will never have "perfect" tests but we can also do better than what we have now e.g. by

- Having more types of tests that run before a change is merged, so we can learn about issues earlier in the development process.

- Investing in other ways to test changes, so that we are less relient on expensive end-to-end tests for things like CDN config ([tech debt](https://trello.com/c/y6MIgxjp/14-cdn-configuration-is-spread-over-multiple-repositories-and-not-reproducible)).

## Continuous Deployment checks

### Smokey

[Smokey](https://github.com/alphagov/smokey) is the smoke test suite for GOV.UK.

Smoke tests are meant to be "probes": their purpose is to monitor real environments for transient failures. Conversely, a "test" should be run in a temporary, isolated environment. We use Smokey as a suite of probes and a suite of "surrogate" end-to-end tests:

- **Probes**. A full run of Smokey is triggered [every few minutes](https://github.com/alphagov/govuk-puppet/blob/278426769a1711c622bcb67a59175f73e8f4db61/modules/govuk_jenkins/manifests/jobs/smokey.pp#L24) in every environment, causing a Slack alert if it fails. This should prompt an engineer to go and fix a problem. However, many of the probes are unreliable so they are not currently used to page people.

- **Surrogate Tests**. [A subset of the probes](https://github.com/alphagov/smokey/blob/main/docs/tagging.md#app-app_name) are run as part of the [Continuous Deployment pipeline](/manual/development-pipeline.html). These can fail for reasons unrelated to the app being targeted, which is why we consider this a "surrogate" form of testing.

[We use Sentry to monitor flakey probes](https://sentry.io/organizations/govuk/issues/?project=6370326) and identify patterns we can fix.

[Read more about when and how to write Smoke tests](https://github.com/alphagov/smokey/blob/main/docs/writing-tests.md).

### Application Healthchecks

Healthchecks are a fast way to check an app is running at the end of a deployment. They can also perform detailed checks on the infrastructure the app needs to run.

Web apps have a [`/healthcheck/ready` endpoint](https://github.com/alphagov/govuk_app_config/blob/main/docs/healthchecks.md), which directly checks if the app can serve requests and connect to its infra e.g. a database.

Apps that are automatically deployed all the way to Production should follow the [guidance on healthchecks ("safety checks") in the Continuous Deployment RFC](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-128-continuous-deployment.md#check-app-is-healthy-ie-it-can-run-in-a-production-environment):

- The healthcheck covers connectivity to all systems the app uses to read or write data e.g. databases, remote file systems, remote caches.

Note that service apps have no web server to query, so [we check the process is running](https://github.com/alphagov/govuk-puppet/blob/32c1bbbb10067078c1406170666a135b4a10aaea/modules/govuk/files/usr/local/bin/govuk_supervised_initctl); apps should fail to start if they can’t connect to their infra ([example](https://github.com/alphagov/email-alert-service/commit/cc6123e88d1ec9542d0d19e719e8e02c37b78538)).

See also: [how we reuse health check endpoints to alert about transient failures](/manual/alerts/app-healthcheck-not-ok.html).

## Continuous Integration checks

### Contract Tests

Also known as "Pact Tests".

Contract tests check that APIs exposed by one app (the "provider") are compatible with other apps that use those APIs ("consumers"). This is done by having a set of shared tests: the tests are run by the provider and the consumers.

Apps that are automatically deployed all the way to Production should follow the [guidance on tests (“safety checks”) in the Continuous Deployment RFC](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-128-continuous-deployment.md#safety-checks):

- Each endpoint with multiple, internal consumer apps has at least one contract test.

Contract tests are an important part of the overall test strategy for GOV.UK. If we visually add unit and integration tests, the result is a "chain" of test coverage:

```
Consumer (Unit tests) <---> API (Contract Test) <---> Provider (Unit tests) <---> ...
```

The chain can be brittle, though: it can't test incremental state changes across multiple apps - think about all the API calls and state changes involved in publishing a document on GOV.UK. End-to-end tests are an alternative way of checking for this kind of end-to-end behaviour.

[Read more about how to write contract tests](/manual/pact-testing.html).

### Unit, Integration, etc. Tests

Most GOV.UK apps are built with Ruby on Rails and you should use specific [tools](/manual/conventions-for-rails-applications.html#testing-utilities) and [strategies](/manual/conventions-for-rails-applications.html#testing-strategies) for testing them. Some older apps use the [Minitest](https://guides.rubyonrails.org/testing.html#rails-meets-minitest) framework as they were written prior to us adopting RSpec; we have migrated some apps to RSpec ([example](https://github.com/alphagov/collections/issues/2259)) but [this should be avoided due to the effort required](https://github.com/alphagov/smart-answers/issues/5350).

Apps that are automatically deployed all the way to Production should also follow the [guidance on tests ("safety checks") in the Continuous Deployment RFC](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-128-continuous-deployment.md#safety-checks):

- It has at least one JavaScript test, if it makes use of the language.
- Its code coverage exceeds 95%.

We use [GitHub Actions](/manual/test-and-build-a-project-with-github-actions.html) to run these tests for some repositories, but most Continuous Integration checks are run on [Jenkins](/manual/test-and-build-a-project-on-jenkins-ci.html).
