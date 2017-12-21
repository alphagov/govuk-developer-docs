---
title: Cookies and sessions in GOV.UK frontend apps
parent: "/manual.html"
layout: manual_layout
section: CDN & Caching
owner_slack: "@bevan"
last_reviewed_on: 2017-12-17
review_in: 3 months
---

GOV.UK frontend applications, with the exception of Licensing, do not currently require cookies.

We configure Varnish to strip cookies for
[inbound](https://github.com/alphagov/govuk-puppet/blob/a6c51d887a6501f02766b7279127b60f02037a7f/modules/varnish/templates/default.vcl.erb#L83) and [outbound](https://github.com/alphagov/govuk-puppet/blob/a6c51d887a6501f02766b7279127b60f02037a7f/modules/varnish/templates/default.vcl.erb#L119) requests.

This means any features in frontend application relying on sessions/cookies will
not work.

## CSRF protection

By default Rails enforces CSRF protection by adding a hidden `athenticity_token`
to forms. This is verified by Rails on the subsequent POST. In order to
verify the `authenticity_token`, Rails needs to set and access a session cookie.

Because we strip cookies, verfying the CSRF `authenticity_token` causes an error
and displays a Rails based "The change you wanted was rejected" error.

If your front end application does not need CSRF protection, you can disable it
on a per application basis or per method basis. A per method basis is preferred
because it exposes the smallest unit of risk from a security perspective. To
disable CSRF protection, you can add an exception to your controller:

```
protect_from_forgery except: [:a_method_or_two]
```

## Enabling cookies and sessions

This is as yet untested on new applications - it looks like this is what
Licensing is doing, so replicating the setup should work for your application.
The Email Team will be testing this early 2018.

[Fastly's cache-control
documentation](https://docs.fastly.com/guides/tutorials/cache-control-tutorial) notes that you should set your `Cache-Control` to
`private` if you want to ensure Fastly does not cache the resource (not that
`no-cache` and `no-store` apparently are not respected by Fastly). You will
also need to update the Varnish configuration to allow cookies for your application for both [inbound](https://github.com/alphagov/govuk-puppet/blob/a6c51d887a6501f02766b7279127b60f02037a7f/modules/varnish/templates/default.vcl.erb#L83) and [outbound](https://github.com/alphagov/govuk-puppet/blob/a6c51d887a6501f02766b7279127b60f02037a7f/modules/varnish/templates/default.vcl.erb#L119) requests.
