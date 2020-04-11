---
owner_slack: "#govuk-developers"
title: Check for a 'gone' route
section: Routing
layout: manual_layout
parent: "/manual.html"
---

When a Whitehall document fails to appear on the frontend, and the user
is shown a 'Gone' page, follow these instructions:

## Connect to a router-backend machine

```bash
gds govuk connect -e production ssh router_backend
```

## Check the router API for a `gone` route

```ruby
$ govuk_app_console router-api
> r = Route.where(incoming_path: '/path-to-item').first
> puts r.handler
```

If the result is `gone` and you want to unblock the URL then you need to
remove the route (this works because `/government` is a `prefix` route
to Whitehall):

```ruby
> r.destroy
> RouterReloader.reload
```
