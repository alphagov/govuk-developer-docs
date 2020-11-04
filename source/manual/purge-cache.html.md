---
owner_slack: "#govuk-2ndline"
title: Purge a page from cache
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
important: true
---

The `www.gov.uk` domain is served through Fastly, which honours the
cache control headers sent by Varnish. When new content is published, the
[Cache Clearing Service][cache-clearing-service] should take care of purging
the page from Varnish and Fastly.

[cache-clearing-service]: https://github.com/alphagov/cache-clearing-service

If, for whatever reason, this hasn't worked properly content already seen by
Fastly may be cached for up to an hour (depending on the Varnish cache
headers). In this case, you may need to manually purge a page from the two
caches.

## Purging a page from the cache

Cache Clearing Service provides three Rake tasks which can be used to clear
the various caches manually:

- **Varnish**: [`rake cache:clear_varnish[/your-path-here]`][jenkins-varnish-task]
- **Fastly**: [`rake cache:clear_fastly[/your-path-here]`][jenkins-fastly-task]
- **Both**: [`rake cache:clear[/your-path-here]`][jenkins-both-task]

[jenkins-varnish-task]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=cache-clearing-service&MACHINE_CLASS=backend&RAKE_TASK=cache:clear_varnish[/your-path-here]
[jenkins-fastly-task]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=cache-clearing-service&MACHINE_CLASS=backend&RAKE_TASK=cache:clear_fastly[/your-path-here]
[jenkins-both-task]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=cache-clearing-service&MACHINE_CLASS=backend&RAKE_TASK=cache:clear[/your-path-here]

### Assets

If you need to clear the Fastly cache for a URL which is not `www.gov.uk` (e.g. for assets),
you can provide a full URL to the [Fastly cache clearing rake task](https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=cache-clearing-service&MACHINE_CLASS=backend&RAKE_TASK=cache:clear_fastly[%22https://assets.example.gov.uk/your-path-here%22]).

```sh
$ rake cache:clear_fastly["https://assets.example.gov.uk/your-path-here"]
```

## Purging a page from Fastly manually (e.g. if GOV.UK Production is dead)

To purge content on the Fastly cache nodes, SSH onto a `cache` machine and use the
PURGE method against the URL you wish to purge. For instance:

```sh
$ curl -XPURGE https://www.gov.uk/bank-holidays
```

You should receive `ok` returned as a response. If not, you may wish to request
more verbose output using the `-i` switch:

```sh
$ curl -i -XPURGE https://www.gov.uk/bank-holidays
```

## Full Edge Flush on Fastly

There are two steps involved in flushing *everything*; our origin (the cache
servers) followed by Fastly.

To flush our origin run the following Fabric command:

```sh
$ fab $environment class:cache class:draft_cache cache.ban_all
```

Once this is done move on to Fastly. This can only be done through the Fastly
UI - the credentials are in the 2nd line store. If possible, speak to a member
of the senior tech team before doing this, to evaluate the risk.

Within the UI you reach the purge all functionality.

- Click "Configure"
- Choose the correct service in the service drop down
- Click on the "Purge" drop down
- Click on "Purge All"
