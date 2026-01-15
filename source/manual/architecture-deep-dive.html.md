---
owner_slack: "#govuk-developers"
title: Architectural deep-dive of GOV.UK
section: Applications
type: learn
layout: manual_layout
parent: "/manual.html"
---

We can cover a lot of GOV.UK architecture by asking ourselves three questions:

1. What happens when a user visits a page on GOV.UK?
2. What happens when a publisher hits 'Publish'?
3. What happens when a developer deploys a change to an application?

Refer to the [architectural summary of
GOV.UK](/manual/architecture-shallow-dive.html) for a shorter summary of GOV.UK
architecture.

[GOV.UK]: https://www.gov.uk

## What happens when a user visits a page on GOV.UK?

### DNS

![](images/dns.png)

The browser queries a local DNS server to turn the domain name into an IP address.
The local DNS server might be able to answer immediately from its cache. If not,
it will query the authoritative name servers for the domain.

`gov.uk.` is a country-code second-level domain or ccSLD (like `co.uk.`) and its
authoritative servers are hosted by [Jisc]. Unusually for a ccSLD, `gov.uk` is
also a website, and hosts the redirect from `gov.uk` to `www.gov.uk`. The records
for these two domains are within the `gov.uk` second-level zone hosted by Jisc.

`www.gov.uk` is a CNAME record which ultimately points to `www-gov-uk.map.fastly.net.`
The `fastly.net` domain name is hosted by special nameservers at the Fastly content
delivery network, which aim to respond with the IP address of the Fastly cache node
which is "closest" to the user. Read more about Fastly in the next section, or
[read more about gov.uk DNS][govuk-dns-docs].

[deploy-dns]: https://deploy.blue.production.govuk.digital/job/Deploy_DNS/
[govuk-dns repo]: https://github.com/alphagov/govuk-dns
[govuk-dns-config repo]: https://github.com/alphagov/govuk-dns-config
[govuk-dns-docs]: /manual/dns.html
[Jisc]: https://www.jisc.ac.uk/domain-registry
[Amazon Route53]: https://aws.amazon.com/route53/

### CDN and caching

GOV.UK uses the [Fastly] CDN to handle the majority of requests, which - as
well as reducing load on GOV.UK ('origin') by around 70% - provides 'edge nodes'
(servers) that are closer to our end users (particularly those outside the UK).

Fastly uses [Varnish] for caching, with a default cache time of 1 hour. (Read
["Our content delivery network"][our-cdn] for more information). If Fastly
doesn't have a page in its cache, it fetches the page from origin.

[Caches can be purged][purge-cache], which tells Fastly to soft-purge (i.e.
only remove the cached version once it has received the new version from
origin).

[Fastly]: https://www.fastly.com/
[our-cdn]: /manual/cdn.html
[purge-cache]: /manual/purge-cache.html
[Varnish]: https://varnish-cache.org/

#### Failover

If a Fastly request to origin returns a 5xx response, Fastly will request
content from the mirror, which is static HTML hosted in an S3 bucket on AWS.
The contents of the mirror are updated daily via the [govuk-mirror] crawler,
which recursively crawls GOV.UK URLs from a message queue, visiting the pages
and saving the output to disk.

- Read more about [fallback to the static mirrors] and how the mirrors are populated.
- Read more about [how errors are handled on GOV.UK].

[fallback to the static mirrors]: /manual/fall-back-to-mirror.html
[how errors are handled on GOV.UK]: /manual/errors.html
[govuk-mirror]: https://github.com/alphagov/govuk-mirror

#### Routing on the CDN

As well as for caching, Varnish is used for the redirection from `gov.uk` to
`www.gov.uk`, which is configured in Varnish Configuration Language (VCL) and
uploaded directly to Fastly via [govuk-cdn-config].

Other redirects that happen at the Fastly level include [bouncer]: a GOV.UK
application responsible for redirecting traffic from old pre-GOV.UK websites.
This is configured via [transition]. Read [Transition architecture] for more detail.

[bouncer]: https://github.com/alphagov/bouncer
[govuk-cdn-config]: https://github.com/alphagov/govuk-cdn-config
[Transition architecture]: /manual/transition-architecture.html
[transition]: https://github.com/alphagov/transition

### Routing on GOV.UK

#### Getting to the 'router' application

![](images/load-balancer.png)

Some requests make it through the CDN and cache layers to 'origin'. Origin is
a stack of computers in the cloud - in this case, AWS - and its entry point is
a load balancer.

The load balancer knows based on the hostname which machine 'class' to route
to. Different classes of machine run different sets of GOV.UK applications.
How many machines are allocated to a class - and how big those machines are -
is configured using [Terraform], in [govuk-aws]. What runs on each machine
class is configured in govuk-puppet, a file and process management system we'll
cover in more detail later.

![](images/nginx-routing.png)

External requests are routed to a 'cache' machine, where the request is
received by an [Nginx] web server running on the machine. Nginx proxies some
routes directly to other apps, such as [asset URLs] being
[routed to asset-manager][asset-proxy] - this is configured with govuk-puppet.
However, [Nginx proxies most requests to Varnish][nginx-varnish-proxy].
If Varnish has the route response in its cache, that is returned, otherwise it
proxies the request to [router], which is a GOV.UK maintained application
running on the cache machines.

[asset URLs]: https://github.com/alphagov/govuk-puppet/blob/881cbcdef477332948e92b88ecd04a830fd02337/hieradata/common.yaml#L1176-L1178
[asset-proxy]: https://github.com/alphagov/govuk-puppet/blob/a114dd5f80d789be368573545dc56fe388c0ac58/modules/router/templates/assets_origin.conf.erb#L53-L67
[govuk-aws]: https://github.com/alphagov/govuk-aws
[Nginx]: https://www.nginx.com/
[nginx-varnish-proxy]: https://github.com/alphagov/govuk-puppet/blob/66b2f6c6d8e572d0b4cc8d6d47338c050a1c46a2/modules/router/templates/router_include.conf.erb#L78
[router]: https://github.com/alphagov/router
[Terraform]: https://www.terraform.io/

#### Routing via 'router'

'Router' is a reverse proxy app written in Go. It is designed to be fast,
storing all known routes in memory using a [prefix trie], which it loads
from a MongoDB database of all known routes.

Every Router instance reloads it's in memory routes periodically or being
triggered by LISTEN/NOTIFY notification from the Content Store Postgres
database. This process is repeated across all instances.

Routes have different handlers. Routes marked as `gone` return a 410 Gone
response. Routes marked as `redirect` serve a 301 Moved Permanently
response. These handlers are useful for when content is deleted or
superseded. Most publishing apps provide a way of deleting or redirecting
their content, but it's worth noting the [short-url-manager] app, whose
sole purpose is to create special redirect routes to allow the creation
of short, memorable URLs that redirect to longer URLs, often as part of a
media campaign.

Routes with a `backend` handler are routed to the relevant rendering app,
based on the `backend_id` of the route, which is derived from the
`rendering_app` field in the corresponding content item in the Content
Store - we'll cover this later. For example, if the route has a
`backend_id` of `frontend`, it will forward the request to the [frontend]
application.

[frontend]: https://github.com/alphagov/frontend
[prefix trie]: https://en.wikipedia.org/wiki/Trie
[register-route]: https://github.com/alphagov/content-store/blob/08f02f990e621c9d2fd473e12a70a6805ddd8dcb/app/models/route_set.rb#L58-L82
[short-url-manager]: https://github.com/alphagov/short-url-manager

### Rendering

Once Router has forwarded the request to the right rendering app, the
rendering app itself has to do some routing. Most GOV.UK front-end apps are
built in [Rails], which means typically there is a `routes.rb` file that
maps the route to a controller. The controller takes the URL path and any
parameters and decides how to render the page.

Many pages require the application to make a request to the Content Store
to retrieve the corresponding content. Some pages are associated with
collections of content, rather than simply one content item. If it is a
static collection, such as a homepage which references several news stories,
then this remains just one content item that has been expanded via "link
expansion" (which we'll cover later) to 'include' the other content items
within it. If it is a dynamic collection, such as a search results page,
then content items are retrieved via the [search-api].

[Rails]: https://rubyonrails.org/
[search-api]: https://github.com/alphagov/search-api

#### Static assets

Whilst views can be any arbitrary HTML, GOV.UK pages are typically constructed
from components defined in [govuk_publishing_components], set in a standard
page template (header, footer, JavaScript and CSS) also defined in [govuk_publishing_components].
For more details, read about the GOV.UK [Frontend architecture].

Static JS/CSS is delivered over <https://assets.publishing.service.gov.uk>.
Custom assets, such as images, are delivered over the same domain and uploaded
by content designers via [asset-manager]. Under the hood, all of these assets
live in an [AWS S3 bucket]; read ["Assets: how they work"].

[asset-manager]: https://github.com/alphagov/asset-manager
["Assets: how they work"]: /manual/assets.html
[AWS S3 bucket]: https://aws.amazon.com/free/storage/
[Frontend architecture]: /manual/frontend-architecture.html
[govuk_publishing_components]: https://components.publishing.service.gov.uk/component-guide

### Summary

The request is resolved through DNS, more often than not hitting the CDN/cache
layers. Some requests make it through to origin, where they're routed to the
machine running the (usually Rails-based) rendering application that knows how
to handle the request.

## What happens when someone hits 'Publish'?

### Draft and live stacks

![](images/draft-live-stacks.png)

Everything you've just read about in the first section exists in two stacks:
draft and live. These are very similar to each other: each is a collection
of machines in the cloud, running GOV.UK applications. Everything that runs in
the live stack also runs in the draft stack, in order to have a way of
previewing content in a non-public-facing way. However, the draft stack also
has additional machines that run the [publishing apps].

Applications shouldn't know what stack they're in - they're simply configured
to talk to other applications in their stack.

The live stack entry point is the 'router' app. You can swap `www` for
`www-origin` to bypass Fastly and view the live stack at origin. This is
only available to office IPs / VPN, and to Fastly IP addresses (configured in
[govuk-provisioning]).

The draft stack entry point is [authenticating-proxy], which sits in front
of 'router'. You can swap `www` for `draft-origin` to view the draft stack at
origin. The draft stack is not IP-restricted, as we need to be able to share
links to be reviewed ("2i'd") or fact-checked by non-Government departments.
It is, however, only visible to users who have been verified through
Authenticating Proxy, by signing into [signon][] (an authentication and
authorisation portal) or by providing a valid `auth_bypass_id` (as a URI
parameter or session cookie). Read more about previews in ["How the draft stack works"].

Signon doubles up as an authorisation platform, as it associates users with
arbitrary permissions, so a publishing app can query if the current user has
the necessary permissions to perform a given action, such as publishing
content.

[authenticating-proxy]: https://github.com/alphagov/authenticating-proxy
[govuk-provisioning]: https://github.com/alphagov/govuk-provisioning
["How the draft stack works"]: /manual/content-preview.html
[publishing apps]: /#publishing-apps
[signon]: /repos/signon.html

### Publishing API vs Content Store

![](images/publishing-api-content-store.png)

At this point it's probably worth summarising what "content" is. Almost every
piece of content on GOV.UK lives in a database called "[content-store]", which
stores only the latest "edition" of that content. Internally the content is
referred to as a "document", even if it is not itself a document. Content is
retrieved via the "[Content API]", which lives in the content-store repo.

Content is published to the Content Store via the [Publishing API], which
stores all of the editions of the document, and performs validation checks
whenever it receives a new edition. Every piece of content has a `schema_name`
corresponding to a particular JSON schema defined in the [content schemas in Publishing Api].
Most backend apps have their own databases modelling documents in their own
way; at the point of sending the document to Publishing API, they transform the
document to a JSON payload conforming to the appropriate schema.

![](images/content-store-draft-live.png)

When a new edition is sent to Publishing API, it is automatically published to
the draft Content Store, replacing whatever contents existed for that document
beforehand. An edition must be explicitly published for it to go to the live
Content Store, where it becomes visible to the outside world.

[Link expansion], mentioned in [Rendering][rendering] is the process of
joining related content items (such as the title and details of a document's
parent, used for navigational breadcrumbs) into a single JSON payload, so that
rendering apps don't need to handle the complexity of pulling all of that data
together manually. Link expansion happens in Publishing API at the point of
sending an edition downstream to the Content Store.

[Content API]: /repos/content-store.html
[content-store]: https://github.com/alphagov/content-store
[content schemas in Publishing Api]: https://github.com/alphagov/publishing-api/tree/main/content_schemas
[Link expansion]: https://github.com/alphagov/publishing-api/blob/main/docs/link-expansion.md
[Publishing API]: https://github.com/alphagov/publishing-api
[rendering]: #rendering

### Downstream Sidekiq background processing triggered by publishing

The Publishing API could update the Content Store directly, but the scale of
GOV.UK means we're safer offloading that call to a background process to be
processed when resources become available. In addition, when we publish a new
edition, we often want to trigger some other actions as a result. For example,
we want to send an email to anyone subscribed to that content.

We use [Sidekiq] to manage the background processing. When each Sidekiq
process is evaluated, a message is put onto a [RabbitMQ] queue.

The RabbitMQ cluster used by publishing-api is managed by AWS, via their [AmazonMQ] service.

RabbitMQ is a message broker: when a message is broadcast to a RabbitMQ
exchange, it forwards the message to its consumers. These consumers
retrieve the content item and do something in response, such as:

- [Send emails to users subscribed to that content][message-queues-rake]. (The
  exceptions to this are `travel-advice` & `specialist-publisher`, which
  communicate directly with email-alert-api to ensure emails go out immediately)

[message-queues-rake]: https://github.com/alphagov/email-alert-service/blob/main/lib/tasks/message_queues.rake
[AmazonMQ]: https://aws.amazon.com/amazon-mq/
[RabbitMQ]: https://www.rabbitmq.com/
[Sidekiq]: /manual/sidekiq.html

#### Sidekiq queues: high and low priority

Updating one content item often requires updating other pieces of content.
For example, if a content item's title has been changed, then content items
which refer to that content item will need to be updated to use the new
title. Sometimes a single change can trigger changes in thousands of items.

Putting both the directly changed and indirectly changed content items
on the same queue would mean it would take a long time to see the changes
in a document you've edited. Generally, it is less important to see a quick
change to the indirectly changed content than it is to see a change in the
directly changed content items. Therefore we have a concept of 'high' and
'low' priority queues.

The main content item is processed in the high priority queue. Exactly the
same things happen to the low priority content items as the high priority
content items; it just tends to take longer as there are more items to
process.

The process for finding the content items affected by a content change is
known as [dependency resolution]. Content items can be associated with
other content items in a number of ways. For example, you may provide an
[array of organisation IDs][schema-organisations-example] in your payload
when sending to Publishing API, to indicate that those organisations are
responsible for the content (this is stored on the content item in content
store as `links.organisations`).

Content can also be tagged to [taxonomies], which are used to describe where
in the site hierarchy the content sits. These are stored on the content item
as `links.taxons`. Some apps have their own interface for tagging, or you can
tag content independently using [content-tagger].

[content-tagger]: https://github.com/alphagov/content-tagger
[dependency resolution]: https://github.com/alphagov/publishing-api/blob/main/docs/dependency-resolution.md
[schema-organisations-example]: https://github.com/alphagov/publishing-api/blob/a8039d430e44c86c3f54a69569f07ad48a4fc912/content_schemas/dist/formats/news_article/publisher_v2/schema.json#L70-L73
[taxonomies]: /manual/taxonomy.html

### Summary

The publishing app uses the Publishing API to create and synchronise a new
edition of a document, which consolidates related content items into it prior to
sending to Content Store. All affected content items are added to a publishing
queue, which triggers downstream actions such as cache clearing and email alerts.

## What happens when a developer deploys a change to an application?

### Environments

There is a copy of the live and draft stacks in each of the following
environments:

- Production
- Staging
- Integration

Nightly cronjobs copy data from Production to Staging and from Staging to
Integration. This is because:

- this gives us automated restore testing, to prove that we can actually
  restore from production backups
- we don't yet have example datasets suitable for development and testing
  purposes
- most of the data is public

Some data is removed or redacted in the staging environment so that we don't
copy it to the integration environment, such as:

- email addresses, for example of subscribers to topic change notifications
- draft content that has yet to be published on the public website

### Release and rollout automation

See [The development and deployment pipeline](/manual/development-pipeline.html).
