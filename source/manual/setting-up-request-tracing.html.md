---
title: Setting Up Request Tracing
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/setting-up-request-tracing.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/setting-up-request-tracing.md)


# Setting Up Request Tracing

Request tracing makes it easier to understand how requests originating from
users of publishing apps make their way through the system. For example, if a
user publishes a piece of content, request tracing will "connect the dots"
between that user's request and downstream requests that were made as a
consequence of the publish.

## How it works

For the most part, the gds-api-adapters handle this for you. The adapters read
the HTTP_GOVUK_REQUEST_ID header and forward this onto backend services. A
search can then be carried out against log files for a single request id to see
all of the backend service requests that were made in consequence to the
originating request.

## When it "just works"

If you are using gds-api-adapters to speak to backend services and your requests
are handled synchronously, you don't need to do anything. It should just work.

## When it doesn't "just work"

If you are running out-of-band processes via asynchronous workers (e.g. Sidekiq)
the request id won't be available in the worker and will not be sent downstream.
This also includes any rake tasks you may have, such as republishing tasks.

For many of these cases, there isn't an originating request and so it's fine not
to send a request id downstream. The request id will be generated and populated
once a subsequent downstream request hits a load balancer, this will result in
a partial trace.

In cases where you do have a request id available, it is preferable to
send this downstream as this could make it easier to debug in the future.

Use [govuk_sidekiq](https://github.com/alphagov/govuk_sidekiq) to do this. This
gem injects middleware that will pass on the request id.

