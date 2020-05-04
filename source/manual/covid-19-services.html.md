---
owner_slack: "#govuk-corona-forms-tech"
title: COVID-19 Services
section: Services
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-04-21
review_in: 1 month
---

GOV.UK operates three standalone services for COVID-19 response:

- Offer coronavirus support from your business
- Get coronavirus support as an extremely vulnerable person
- Find support if you're affected by coronavirus

## Offer coronavirus support from your business

This service allows businesses to tell us how they might be able to
help with the response to coronavirus.  This may include goods or
services such as medical equipment, hotel rooms or childcare.

- [Start page](https://www.gov.uk/coronavirus-support-from-business)
- [Service](https://coronavirus-business-volunteers.service.gov.uk/medical-equipment)
- [GitHub](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form)

## Get coronavirus support as an extremely vulnerable person

This service allows people identified as vulnerable by the NHS to
tell us if they need help accessing essential supplies and support.
Users will have received a link to the service in a letter or a text
message from the NHS, or been advised by their GP to fill in the form.
They can fill the form in themselves, or someone else can fill it in
for them.

There is also an interactive voice response (IVR) automated phone
service provided by AWS. This is for users who do not have access to
the internet.

The service is also known as the Shielded Vulnerable service, or
SV.

- [Start page](https://www.gov.uk/coronavirus-extremely-vulnerable)
- [Service](https://coronavirus-vulnerable-people.service.gov.uk/live-in-england)
- [GitHub](https://github.com/alphagov/govuk-coronavirus-vulnerable-people-form)

## Find support if you're affected by coronavirus

This service allows the public - who may not have been eligible for
the extremely vulnerable service - to find information about what help
is available if they're struggling with unemployment, an inability to
get food, having somewhere to live, or their general wellbeing as a
result of coronavirus.

The service is also known as the Non-Shielded Vulnerable service, or
NSV.

- [Start page](https://www.gov.uk/find-coronavirus-support)
- [Service](https://find-coronavirus-support.service.gov.uk/urgent-medical-help)
- [GitHub](https://github.com/alphagov/govuk-coronavirus-find-support)

## Architecture

All applications have a similar architecture of:

- **Framework:** Ruby on Rails
- **Database:** AWS RDS (business volunteering, find support) and DynamoDB (vulnerable people)
- **Hosting:** PaaS
- **CDN:** AWS CloudFront
- **CI:** GitHub Actions (branches and PRs)
- **CD:** Concourse (master builds and production deploys)
- **Logging:** Sentry and Logit
- **Email**: GOV.UK Notify
- **Queuing**: Sidekiq (business volunteering only)

### Application structure

Each application is a standard Rails application with:

- question pages, each has their own controller, view and route
- a check your answers page (except find support form)
- a confirmation ("Thank you") page
- ineligible pages (vulnerable people form only)
- a privacy page

To run one of the applications locally, see the README in the GitHub repo.

## Session and data storage

### Session storage

While the user is filling out the form, we use session storage to
store the user's data.

For the vulnerable people form and find support form, we store session data for
4 hours in an encrypted cookie, persisted in the browser and sent back to the
server for every question.  Cookies have a limit of 4KB, so this approach could
cause errors if the user submits large inputs.

For the business volunteering form, we store the following for 4 hours:

- the session id in an encrypted cookie
- the session data in Redis

### Data storage

For all but the find support form, when the user submits the form on
the "Check your answers" page, the application writes user data to the
database.

For the find support form, user responses are written to the database
on submission of the final question. There is no "Check your answers"
page.

The vulnerable people form application only has permission to write
items to the database. For security and privacy reasons, there's no
way to read or change already-submitted user data.

Developers should not have access to the production database for
the vulnerable people form application.

The business volunteering form and find support form applications can both read
and write to their databases as the security and privacy requirements are lower.

Developers may treat data in the business volunteering form and find support
form to the same standards as any other GOV.UK personal data store, and are able
to access it for legitimate development duties.

## Hosting

### PaaS

All applications are hosted on GOV.UK Platform as a Service (PaaS) in
the Ireland region.  PaaS provides a scalable hosting platform based
on CloudFoundry managed by GDS.  You can read more in the [PaaS
technical documentation][paas-docs].

#### Get access

To get access, email
govuk-senior-tech-members@digital.cabinet-office.gov.uk and ask for an
invite to the `govuk_development` organisation.  They need to give you
a role that lets you access both `staging` and `production` spaces and
the applications inside.

#### Log in

Before you start, [install the CloudFoundry CLI][cf-cli].

1. Log in with `cf login -a api.cloud.service.gov.uk --sso`
2. Select staging or production with `cf target -s <staging or production>`

All applications are Rails applications, and use the
[`ruby_buildpack`][] to build and deploy to PaaS.  You can read more
about [managing PaaS applications][paas-managing] and [monitoring PaaS
applications][paas-monitoring].

#### Manage backing services

The business volunteer application uses PaaS's [Redis backing
service][paas-redis].  The backing service is attached to the
application by a setting in the `manifest.yml` file in the repository
root.

The JSON data in the `VCAP_SERVICES` environment variable exposes
settings and credentials for the backing service automatically.

### AWS

We have two AWS accounts (staging and production) for CDN and data
storage. They contain DynamoDB, IAM and CloudFront resources,
which were provisioned by Terraform in the [alphagov/covid-engineering
repository][covid-engineering-repo]. Members of the GOV.UK Coronavirus
Services team have access.

To log in to AWS:

1. [Install and set up the gds-cli](/manual/get-started.html#8-use-your-aws-access), then log in to the AWS Console with either:

   - `gds aws govuk-corona-data-staging-poweruser -l` for staging
   - `gds aws govuk-corona-data-prod-poweruser -l` for production

## Deployment

Deployment is managed via [TechOps shared Concourse][big-concourse].
CI/CD pipelines are configured under the `govuk-tools` team. You can
read about what Concourse is, its access controls, and how to
administer it, on the [Concourse](/manual/concourse.html) developer
docs page.

In terms of these applications, any changes to application code on the
master branch are continuously deployed to staging.  Smoke tests are
set up to run on staging, if these pass the applications are
automatically deployed to production.  The smoke tests are the feature
tests within the application repository.

The Concourse deployment pipeline and task configuration for each
application is stored in the "concourse" directory at the root of each
repository. Changes to these pipelines apply automatically when pushed
to `master`.

Links to Concourse Pipelines:

- [`govuk-corona-business-volunteer-form`](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-corona-business-volunteer-form)
- [`govuk-corona-vulnerable-people-form`](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-corona-vulnerable-people-form)
- [`govuk-corona-find-support-form`](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-corona-find-support-form)

### Zero-Downtime Deployment

The deployment tasks use the CloudFoundry v3 API commands in order to
support zero-downtime deployment and various new features.

When working with the cf cli tool, use the `v3` prefixed commands.
For example: `cf v3-apps`.

### Cancelling a failed deployment

Occasionally a zero-downtime deployment may fail.  This can occur if
the application fails to start, or the required number of app
instances cannot be created in time.  To cancel and roll back to the
previous deployment, run: `cf v3-cancel-zdt-push <app-name>`.

### Links to Staging

- [`govuk-coronavirus-business-volunteer-form`](https://govuk-coronavirus-business-volunteer-form-stg.cloudapps.digital/medical-equipment)
- [`govuk-coronavirus-vulnerable-people-form`](https://govuk-coronavirus-vulnerable-people-form-stg.cloudapps.digital/live-in-england)
- [`govuk-coronavirus-find-support-form`](https://govuk-coronavirus-find-support-stg.cloudapps.digital/urgent-medical-help)

These are protected by HTTP basic auth.  You can find the credentials
in govuk-secrets and get them by running:

```
cd ~/govuk/govuk-secrets/pass
./edit.sh 2ndline coronavirus-forms/creds
```

## Monitoring

There's a [Splunk dashboard][splunk] for all of these services.  To
access Splunk, you need to have the `GDS-006-GOVUK` permission on your
Google account.  To get this permission, raise an IT Helpdesk ticket
and post in `#cyber-security-help` to get them to confirm the request
is legitimate.

Application errors are sent to the GOV.UK hosted Sentry:

- [`govuk-coronavirus-business-volunteer-form`](https://sentry.io/organizations/govuk/issues/?project=5172100)
- [`govuk-coronavirus-vulnerable-people-form`](https://sentry.io/organizations/govuk/issues/?project=5170680)
- [`govuk-coronavirus-find-support-form`](https://sentry.io/organizations/govuk/issues/?project=5192076)

These are under the GOV.UK Sentry account and you can sign in with
your Google Account.

Logs for all applications are streamed to Logit and can be found in
following dashboards:

[GOV.UK Production Corona Forms](https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74/s/04b46992-f653-4c14-965c-236e9a6c2777/kibana/access)
[GOV.UK Staging Corona Forms](https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74/s/7a0be476-6535-4544-8318-4c7a130948e8/kibana/access)

## Confirmation emails

### GOV.UK Notify

The business volunteering service sends confirmation emails on form submission,
using GOV.UK Notify.

Sidekiq is used to manage the queuing of email jobs. The application [README](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form#running-sidekiq)
details how to manage the Sidekiq queue.

To login to the [GOV.UK Notify Dashboard](https://www.notifications.service.gov.uk/sign-in)
obtain the credentials using govuk-secrets:

```
cd ~/govuk/govuk-secrets/pass
pass govuk-notify/govuk-coronavirus-services
```

In staging only, emails are sent to `coronavirus-services-smoke-tests@digital.cabinet-office.gov.uk`
rather than the form submitter.

## Extracting form responses (business volunteering only)

Cabinet Office require data exports at regular intervals.  A
[recurring Concourse job](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form/blob/5aed27777a22035b1b4f7ea9eafe612b105469a1/concourse/pipeline.yml#L99-L107)
exports the data to a S3 bucket each day between midnight and 1am.
Details of the bucket can be obtained using `cf services` and `cf env`.

Should further exports be required, there is a rake task to export
the data for a single day in JSON format.

```
cf v3-ssh govuk-coronavirus-business-volunteer-form
$ /tmp/lifecycle/shell
$ rake export:form_responses["<date>"]
```

Date to be included in the format 2020-03-26.

## Troubleshooting

### What things will call you

The GOV.UK PagerDuty will page on-call/2ndline if these applications go down. It's connected up to a Pingdom check in the GOV.UK account that checks if the first form page is up.

### Useful commands

> **Note:** Make sure to use the `v3-` commands for things like
> restarting or deploying apps, to do so in a zero-downtime way.

See the status of all the apps and how many instances are running:

```
cf v3-apps
```

Get the logs for an app:

```
cf logs <app-name> --recent
```

View detailed information about an app:

```
cf app <app-name>
```

Restart an app:

```
cf v3-restart <app-name>
```

Access a Postgres console (for business form only):

```
cf conduit govuk-coronavirus-business-volunteer-form-db -- psql
```

### Escalating to PaaS support

PaaS support contact details are in the [legacy opsmanual doc][legacy-opsmanual] under the
heading "PaaS Support (COVID-19 forms)".

[`ruby_buildpack`]: https://docs.cloud.service.gov.uk/deploying_apps.html#deploy-a-ruby-on-rails-app
[big-concourse]: https://cd.gds-reliability.engineering/
[cf-cli]: https://docs.cloud.service.gov.uk/get_started.html#set-up-the-cloud-foundry-command-line
[legacy-opsmanual]: https://docs.google.com/document/d/17XUuPaZ5FufyXH00S9qukl6Kf3JbJtAqwHR3eOBVBpI/edit
[paas-docs]: https://docs.cloud.service.gov.uk/
[paas-managing]: https://docs.cloud.service.gov.uk/managing_apps.html#managing-apps
[paas-monitoring]: https://docs.cloud.service.gov.uk/monitoring_apps.html#monitoring-apps
[paas-redis]: https://docs.cloud.service.gov.uk/deploying_services/redis/#redis
[splunk]: https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/d006_coronavirus
[covid-engineering-repo]: https://github.com/alphagov/covid-engineering/blob/master/reliability-engineering/terraform/deployments/corona-data-prod/account/iam.tf#L296-L386
