---
title: Run an A/B test
parent: "/manual.html"
layout: manual_layout
section: Tools
owner_slack: "@tijmen"
last_reviewed_on: 2016-12-01
review_in: 6 months
---

# Run an A/B test

## 1. Overview

There are two ways of doing A/B testing on GOV.UK. The first uses Javascript to change the contents on a page. The second uses our CDN to allow frontend applications to render different pages.

For a general introduction to A/B testing from a content design perspective, see the [Confluence Wiki](https://bit.ly/AB-testing-GOVUK)

Which implementation you choose depends on your A/B testing needs:

**JavaScript**

* **Pro:** much simpler to configure
* **Con:** content flashes on page load: users see one version first, which is then replaced with the other version
* **Con:** every HTTP response contains both versions, which could significantly increase the page size if the change is large
* **Choose if:** you want to A/B test a small, simple change to a page, such as the wording of a link

**Fastly**

* **Pro:** No content flashing
* **Con:** Requires changes to the CDN configuration
* **Con:** Because it depends on Fastly this can only be fully tested on staging and production. You can still test your A and B versions in other environments, it's just not a completely realistic test without the full stack.
* **Choose if:** you are testing wide-ranging changes, perhaps with redirects to the new version, or if you really need to avoid content flashing

Both options let you report the results to Google Analytics.

## 2. Javascript testing

Javascript testing uses the [Multivariate test framework][multivariate-testing] from the [GOV.UK frontend toolkit][govuk_frontend_toolkit]. It works by running a piece of Javascript after the page is loaded.

A [step-by-step walkthrough is provided on the Wiki](https://gov-uk.atlassian.net/wiki/pages/viewpage.action?pageId=85786770).

[multivariate-testing]: https://github.com/alphagov/govuk_frontend_toolkit/blob/master/docs/javascript.md#multivariate-test-framework
[govuk_frontend_toolkit]: https://github.com/alphagov/govuk_frontend_toolkit

## 3. Using Fastly

This method uses Fastly, our Content Delivery Network (CDN).

### 3.1 How it works

#### Fastly receives the request

When the user requests a GOV.UK page that has A/B testing enabled, they will reach Fastly first.

Fastly appends the `GOVUK-ABTest-Example` header to the request for downstream apps:

- If the request already has a cookie, use the value of that
- If not, randomly assign the user to a test variant and set it value based on that

Fastly will then try to get a response from its cache. The `Vary: GOVUK-ABTest-Example` header on previously cached responses will ensure that the right version is returned to the user.

If there's nothing in Fastly's cache, it'll send the request down the stack to GOV.UK.

#### GOV.UK (Varnish caching layer)

Varnish tries to get a response from the cache. Because Fastly has sent the `GOVUK-ABTest-Example` header, it knows whether to return the `A` or `B` version from the cache. If there's nothing in the cache, Varnish forwards the request to the application server.

#### Application layer

The application (for example, [government-frontend](/apps/government-frontend.html) or [collections](/apps/collections.html)) inspects the `GOVUK-ABTest-Example` header to determine which version of the content to return.

It also adds an extra response header: `Vary: GOVUK-ABTest-Example`. This instructs Fastly and Varnish to cache both versions of the page separately.

#### Varnish (response)

Varnish saves the response in the cache. The `Vary: GOVUK-ABTest-Example` response header will ensure that `A` and `B` are cached separately.

#### Fastly responds

Fastly also saves the response in the cache. The `Vary: GOVUK-ABTest-Example` response header will ensure that `A` and `B` are cached separately.

If the original request did not have the `ABTest-Example` cookie, Fastly will set a `Set-Cookie` header to the response based on the value of the `GOVUK-ABTest-Example` header.

### 3.2 Checklist for enabling A/B testing

Follow these steps:

1. Get your cookie listed on the [cookies page](https://www.gov.uk/help/cookies). The content team can help.
2. You will have to make appropriate changes in [govuk-cdn-config][govuk-cdn-config].
3. Use the [govuk\_ab\_testing gem][govuk_ab_testing] to serve different versions to your users.

[govuk_ab_testing]: https://github.com/alphagov/govuk_ab_testing
[govuk-cdn-config]: https://github.com/alphagov/govuk-cdn-config

## Resources

- ["A/B testing at the edge" - Fastly blog](https://www.fastly.com/blog/ab-testing-edge)
- ["Best Practices for Using the Vary Header" - Fastly blog](https://www.fastly.com/blog/best-practices-for-using-the-vary-header)

[fastly]: https://www.fastly.com/
