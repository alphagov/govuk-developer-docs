---
title: Run an A/B test
parent: "/manual.html"
layout: manual_layout
section: Tools
owner_slack: "@tijmen"
last_reviewed_on: 2017-06-02
review_in: 2 months
---

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
* **Con:** Requires deploying the Fastly CDN
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

Fastly looks up the weighting for the random assignment in a [Fastly dictionary](https://docs.fastly.com/guides/edge-dictionaries/) configured for our A/B tests.

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

1. Get your cookie listed on the [cookies page](https://www.gov.uk/help/cookies). Raise a ticket on [GOV.UK Zendesk](https://govuk.zendesk.com) and assign it to the content team's 2nd line Gov.uk content triage. They need to know the name of the cookie that you will be using, a description and the expiry time.
2. If you want to use Google Analytics to monitor the A/B test, talk to a performance analyst and pick a [GA dimension][analytics-dimensions] to use for your test. There is a range of dimensions from 40-49 blocked out for A/B tests. These can be reused when an A/B test has ended.
3. Configure the A/B test in [the cdn-configs repo][cdn-configs]. Add your test to the following files:
  - `active_ab_tests.yaml`: This controls whether the test is active or not. You may want to configure your test to be inactive at first, so that you can activate it at a later date.
  - `ab_test_b_percentages.yaml`: The percentage of users who should see the B version of your test. This can be changed at a later date to expand the test to more users, but note that there will be some lag because users who have already visited the site will stay in their A/B test bucket until their cookie expires.
  - `ab_test_expiries.yaml`: The lifetime of the A/B test cookie. The value you choose depends on what kind of change you are making. If it is important that users always see a consistent version of the site (e.g. because you are making large changes to the navigation) then choose a lifetime which is significantly longer than the duration of your A/B test, such as 1 year. On the other hand, a shorter lifetime (such as 1 day) causes less lag when changing the B percentage, and might be more appropriate when testing something where consistency is less important from day-to-day, such as changing the order of search results.
4. Deploy the cdn-configs changes to staging and production using the `Update_CDN_Dictionaries` Jenkins job. The `vhost` must be set to `www`, and the credentials are in the deployment repo.
5. Add your test to the [ab_tests configuration file][configuration-file] in the [fastly-configure][fastly-configure] repo. The test name must match the name configured in the cdn-configs repo in step 3.
6. Deploy the Fastly configuration to staging and production using the `Deploy_CDN` Jenkins job. Use the same parameters as in step 4. You can test it on staging by visiting https://www.staging.publishing.service.gov.uk/. Changes should appear almost immediately - there is no caching of the CDN config.
7. Use the [govuk\_ab\_testing gem][govuk_ab_testing] to serve different versions to your users. It can be configured with the analytics dimension selected in step 2.
8. To activate or deactivate the test, or to change the B percentage, update your test in the cdn-configs repo and deploy the change.

[analytics-dimensions]: https://gov-uk.atlassian.net/wiki/display/GOVUK/Analytics+on+GOV.UK
[cdn-configs]: https://github.digital.cabinet-office.gov.uk/gds/cdn-configs
[govuk_ab_testing]: https://github.com/alphagov/govuk_ab_testing
[configuration-file]: https://github.com/alphagov/fastly-configure/blob/master/ab_tests/ab_tests.yaml
[fastly-configure]: https://github.com/alphagov/fastly-configure

## Resources

- ["A/B testing at the edge" - Fastly blog](https://www.fastly.com/blog/ab-testing-edge)
- ["Best Practices for Using the Vary Header" - Fastly blog](https://www.fastly.com/blog/best-practices-for-using-the-vary-header)

[fastly]: https://www.fastly.com/
