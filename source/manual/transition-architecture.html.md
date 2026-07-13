---
owner_slack: "#govuk-content-apis"
title: Transition architecture
section: Transition
type: learn
layout: manual_layout
parent: "/manual.html"
related_repos: [bouncer, transition]
---

The Transition system is built to transition government websites to GOV.UK. The
main work around this [happened in 2014][blog], but we still take on websites.

[blog]: https://insidegovuk.blog.gov.uk/2014/12/19/300-websites-to-just-1-in-15-months

## Components

- [transition][] is the admin app that departments use to transition and manage
  redirects.
- The [cloudwatch / athena / lambda][infra-fastly-logs] trio process the logs
  from Fastly to produce the statistics. Those are then loaded into Transition by the [transition-import-hits-from-cdn-logs job][stats-import] configured to run on schedule in [govuk-helm-charts repo][stats-cron-config] or can be manually triggered.
- [bouncer][] is the application that does the actual redirecting.
- [govuk-fastly][] contains the terraform configuration for Bouncer CDN service
  in Fastly.
- [optic14n][] gem used by both apps to canonicalises URLs

## Transition data sources

Traffic data is automatically imported every day via [a Kubernetes cron
job][stats-import]. This import puts a high load on the database. CDN logs
for the "Production Bouncer" Fastly service are sent (by Fastly) to the
`govuk-production-fastly-logs` S3 bucket and processed by a lambda function
defined in the [infra-fastly-logs][] Terraform project.

[transition]: /repos/transition.html
[optic14n]: /repos/optic14n.html
[stats-import]: https://argo.eks.production.govuk.digital/applications/cluster-services/transition?view=tree&resource=&orphaned=false&node=batch%2FCronJob%2Fapps%2Ftransition-import-hits-from-cdn-logs%2F0
[stats-cron-config]: https://github.com/alphagov/govuk-helm-charts/blob/cf73aee160cb6378a1fe3d7ea52ebc7956b260b5/charts/app-config/values-production.yaml#L3608-L3610
[infra-fastly-logs]: https://github.com/alphagov/govuk-fastly/blob/e1ad145158517ffaa5fbcb0419afb4a269506edd/logs/main.tf#L716

## Bouncer

[Bouncer][] is a Ruby/Rack web app that receives requests for the URLs of government
sites that have either been transitioned to GOV.UK, archived or removed. It queries
the database it shares with Transition and replies with a redirect, an archive page
or a 404 page. It also handles `/robots.txt` and `/sitemap.xml` requests.

Transition is a Rails app that allows users in transitioning organisations and
at GDS to view, add and edit the mappings used by Bouncer. It also presents
traffic data sourced from CDN logs and logs provided by transitioning organisations
(though this latter activity has now ended).

### Bouncer's stack

#### DNS

When sites transition they are generally CNAMEd to a domain we control that
points to our CDN (an A record is used for root domains which can't be CNAMEd).

Some sites partially transition, which means that they redirect some paths to
their AKA domain, which is CNAMEd to us.

GDS doesn't control the DNS for most transitioned domains, except for some domains such as
`*.direct.gov.uk`, `*.businesslink.co.uk`, `*.alphagov.co.uk`. If the DNS
for a particular transitioned site isn't configured correctly we need to inform
the responsible department so they can fix it themselves.

#### CDN

Bouncer has a separate CDN service at Fastly ("Production Bouncer") from the
main GOV.UK one, and it's configured in a [govuk-fastly-bouncer-production
Terraform project](https://github.com/alphagov/govuk-fastly/tree/main/bouncer)
which adds and removes domains to and from the service.  That project [fetches
the list of
domains](https://github.com/alphagov/govuk-fastly/blob/e1ad145158517ffaa5fbcb0419afb4a269506edd/bouncer/service.tf#L2)
which should be configured at the CDN from Transition's [hosts API][]. If the
domain is missing, no changes to the Fastly service will appear in the plan in
the [Terraform
Cloud](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-bouncer-production/runs).

The domains are populated by the [transition-import-dns cron
job](https://github.com/alphagov/govuk-helm-charts/blob/6c8c83c3a5d90512732bfe8d77437ab1007d7cd3/charts/app-config/values-production.yaml#L3605-L3607),
which can also be triggered manually in [Argo
CD](https://argo.eks.production.govuk.digital/applications/cluster-services/transition?resource=&orphaned=false&node=batch%2FCronJob%2Fapps%2Ftransition-import-dns%2F0).

[More information about Bouncer's Fastly service](/manual/cdn.html#bouncers-fastly-service)

#### Machines

Bouncer runs as a Kubernetes workload in the GOV.UK EKS cluster. Traffic is
routed to the application via an AWS Application Load Balancer (ALB), which is
configured through the Kubernetes Ingress resource.

The application runs as replicated pods.
The ALB performs health checks against the `/readyz` endpoint and distributes
traffic across healthy pods.

#### Database

Transition stores its data in a managed PostgreSQL database hosted on Amazon
RDS.

Bouncer reads from the `transition_production` PostgreSQL database using the
`DATABASE_URL` connection string generated from the
[govuk/bouncer/postgres](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/external-secrets/templates/bouncer/postgres.yaml)
secret in AWS Secrets Manager.

#### HTTPS support for transitioned sites

Bouncer in late 2020 began supporting HTTPS for transitioned sites, through
a new feature in Fastly.

Follow the guidance to [request a Fastly TLS certificate][].

[Bouncer]: /repos/bouncer.html
[govuk-fastly]: https://github.com/alphagov/govuk-fastly/tree/main/bouncer
[hosts API]: https://transition.publishing.service.gov.uk/hosts.json
[request a Fastly TLS certificate]: /manual/request-fastly-tls-certificate.html
