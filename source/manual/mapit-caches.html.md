---
owner_slack: "#govuk-platform-reliability-tech"
title: Mapit Caches
layout: manual_layout
parent: "/manual.html"
section: Infrastructure
related_repos:
  - mapit
---

Mapit uses Django's [in-built middleware](https://docs.djangoproject.com/en/3.1/topics/cache/#the-per-site-cache) to cache responses to memcached. Mapit instances use a shared memcached instance.

## Clear the shared cache

1. SSH onto a mapit instance

1. Connect via Telnet to memcached instance:

   ```
   telnet mapit-memcached 11211
   ```

1. Enter the following:

   ```
   flush_all
   ```

You may need to clear the cache after updating the Mapit database with new data. As each Mapit instance has it's own database, make sure to clear the cache after you've updated all Mapit instances.

## Limitations of caching

Currently Django will only caches responses from the `/postcode` endpoints and not `/area`. This is due to `/area` responses being streaming responses.

## Bypassing the cache

Cache keys are based on the URI of the request, therefore you can avoid the cache by adding a unique query string. For example `/postcode/sw71ne?nocache=<random>`.
