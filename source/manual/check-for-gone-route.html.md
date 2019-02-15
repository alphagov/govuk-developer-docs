---
owner_slack: "#govuk-2ndline"
title: Check for a 'gone' route
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-06
review_in: 6 months
---

When a Whitehall document fails to appear on the frontend, and the user
is shown a 'Gone' page, follow these instructions:

## Connect to a router-backend machine

```console
ssh router-backend-1.router.production
```

in Carrenza, and

```console
govukcli set-context integration
govukcli ssh router_backend
```

in AWS.

## Check the router API for a `gone` route

```console
govuk_app_console router-api
> r = Route.where(incoming_path: '/path-to-item').first
> puts r.handler
```

If the result is `gone` and you want to unblock the URL then you need to
remove the route (this works because `/government` is a `prefix` route
to Whitehall):

```console
> r.destroy
> RouterReloader.reload
```
