---
owner_slack: "#govuk-developers"
title: How A/B testing works
parent: "/manual.html"
layout: manual_layout
section: A/B testing
type: learn
---

GOV.UK uses our [Content Delivery Network (Fastly)][cdn] to run A/B and multivariate tests.

For a general introduction to A/B testing from a content design perspective, see the [Confluence Wiki](https://bit.ly/AB-testing-GOVUK).

[cdn]: https://docs.publishing.service.gov.uk/manual/cdn.html

![](https://docs.google.com/drawings/d/e/2PACX-1vR67bcDfNDaa4buyKGKQev0xUsjcD9RzjNCjWGhr0HJtXRmSNaltPJotXjwmKUmZj0ZH_B2xAymEYbV/pub?w=1330&h=517)

Source: [GOV.UK Architecture Google Drive](https://docs.google.com/drawings/d/1rx4brKZBzj-9q3evkiUw2MbqwqTYWkc0Lku6u3cLXqU/edit)

## How A/B testing works

**A/B tests are only enabled for users who have opted in to analytics cookies.**

### Fastly receives the request

When the user requests a GOV.UK page that has A/B testing enabled, they will reach Fastly first.

Fastly appends the `GOVUK-ABTest-Example` header to the request for downstream apps:

- If the request already has a cookie, use the value of that
- If not, randomly assign the user to a test variant and set it value based on that

Fastly looks up the weighting for the random assignment in a [Fastly dictionary][dicts] configured for our A/B tests.

Fastly will then try to get a response from its cache. The `Vary: GOVUK-ABTest-Example` header on previously cached responses will ensure that the right version is returned to the user.

If there's nothing in Fastly's cache, it'll send the request down the stack to GOV.UK.

[dicts]: https://docs.fastly.com/guides/edge-dictionaries/

### GOV.UK (Varnish caching layer)

Varnish tries to get a response from the cache. Because Fastly has sent the `GOVUK-ABTest-Example` header, it knows whether to return the `A` or `B` version from the cache. If there's nothing in the cache, Varnish forwards the request to the application server.

### Application layer

The application (for example, [government-frontend](/apps/government-frontend.html) or [collections](/apps/collections.html)) inspects the `GOVUK-ABTest-Example` header to determine which version of the content to return.

It also adds an extra response header: `Vary: GOVUK-ABTest-Example`. This instructs Fastly and Varnish to cache both versions of the page separately.

### Varnish (response)

Varnish saves the response in the cache. The `Vary: GOVUK-ABTest-Example` response header will ensure that `A` and `B` are cached separately.

### Fastly responds

Fastly also saves the response in the cache. The `Vary: GOVUK-ABTest-Example` response header will ensure that `A` and `B` are cached separately.

If the original request did not have the `ABTest-Example` cookie, Fastly will set a `Set-Cookie` header to the response based on the value of the `GOVUK-ABTest-Example` header.

## Further reading

- ["A/B testing at the edge" - Fastly blog](https://www.fastly.com/blog/ab-testing-edge)
- ["Best Practices for Using the Vary Header" - Fastly blog](https://www.fastly.com/blog/best-practices-for-using-the-vary-header)

[fastly]: https://www.fastly.com/
[pass-folder]: https://github.com/alphagov/govuk-secrets/tree/master/pass
