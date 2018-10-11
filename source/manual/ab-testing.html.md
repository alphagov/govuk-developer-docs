---
title: Run an A/B or multivariate test
parent: "/manual.html"
layout: manual_layout
section: A/B testing
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2018-07-03
review_in: 6 months
---

## 1. Overview

GOV.UK uses our [Content Delivery Network (Fastly)][cdn] to run A/B and multivariate tests.

For a general introduction to A/B testing from a content design perspective, see the [Confluence Wiki](https://bit.ly/AB-testing-GOVUK).

[cdn]: https://docs.publishing.service.gov.uk/manual/cdn.html

## 2. How it works

![](https://docs.google.com/drawings/d/e/2PACX-1vR67bcDfNDaa4buyKGKQev0xUsjcD9RzjNCjWGhr0HJtXRmSNaltPJotXjwmKUmZj0ZH_B2xAymEYbV/pub?w=1330&h=517)

_Source: [GOV.UK Architecture Google Drive](https://docs.google.com/drawings/d/1rx4brKZBzj-9q3evkiUw2MbqwqTYWkc0Lku6u3cLXqU/edit)_

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

## 3. How to set up an A/B test

Follow these steps:

1. Get your cookie listed on the [cookies page](https://www.gov.uk/help/cookies). Raise a ticket on [GOV.UK Zendesk](https://govuk.zendesk.com) and assign it to the content team's 2nd line GOV.UK content triage. They need to know the name of the cookie that you will be using, a description and the expiry time.
2. Add your test to the [A/B test register][register].
3. If you want to use Google Analytics to monitor the A/B test, talk to a performance analyst and pick a [GA dimension][analytics-dimensions] to use for your test.
4. Configure the A/B test in [the cdn-configs repo][cdn-configs] ([see an example][dictionary-config-example]). For more details, see the [dictionaries README][dictionaries-readme].
5. Deploy the cdn-configs changes to staging and production using the [Update_CDN_Dictionaries][update-cdn-dictionaries] Jenkins job. The `vhost` must be set to `www`, and the credentials are in the [govuk-secrets repo][govuk-secrets] ([pass folder][pass-folder]).
6. Add your test to the [ab_tests configuration file][configuration-file] in the [fastly-configure][fastly-configure] repo ([see an example][fastly-configure-example]). The test name must match the name configured in the cdn-configs repo in step 3.
7. Deploy the Fastly configuration to staging and production using the [Deploy_CDN][deploy-cdn] Jenkins job. Use the same parameters as in step 4. You can test it on staging by visiting <https://www.staging.publishing.service.gov.uk>. Changes should appear almost immediately - there is no caching of the CDN config.
8. Use the [govuk_ab_testing gem][govuk_ab_testing] to serve different versions to your users. It can be configured with the analytics dimension selected in step 2.
9. To activate or deactivate the test, or to change the B percentage, update your test in [the cdn-configs repo][cdn-configs] and deploy the change.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## 4. How to tear down an A/B test

Follow these steps:

1. Remove your test from the [ab_tests configuration file][configuration-file] in the [fastly-configure][fastly-configure] repo.
2. Deploy the Fastly configuration to staging and production using the [Deploy_CDN][deploy-cdn] Jenkins job. The `vhost` must be set to `www`, and the credentials are in the govuk-secrets repo.
3. Remove your test from [the cdn-configs repo][cdn-configs]. If you are removing the very last A/B test, you should replace the last test name with `[]` ([See an example of having no A/B tests][dictionary-removal-example]).
4. Deploy the cdn-configs changes to staging and production using the [Update_CDN_Dictionaries][update-cdn-dictionaries] Jenkins job. Use the same parameters as in step 2.
5. Get your cookie removed from the [cookies page](https://www.gov.uk/help/cookies). Raise a ticket on [GOV.UK Zendesk](https://govuk.zendesk.com) and assign it to the content team's 2nd line GOV.UK content triage.
6. Mark the end date in [A/B test register][register].

[analytics-dimensions]: https://gov-uk.atlassian.net/wiki/display/GOVUK/Analytics+on+GOV.UK
[cdn-configs]: https://github.com/alphagov/cdn-configs
[dictionaries-readme]: https://github.com/alphagov/cdn-configs/blob/master/fastly/dictionaries/README.md
[dictionary-config-example]: https://github.com/alphagov/cdn-configs/commit/ba3ec923c0bb5bdf17bdaf02419ff4e049516fda
[govuk_ab_testing]: https://github.com/alphagov/govuk_ab_testing
[configuration-file]: https://github.com/alphagov/fastly-configure/blob/master/ab_tests/ab_tests.yaml
[fastly-configure]: https://github.com/alphagov/fastly-configure
[fastly-configure-example]: https://github.com/alphagov/fastly-configure/pull/29/files
[dictionary-removal-example]: https://github.com/alphagov/cdn-configs/commit/1e98e41ef87091e6fab6881a6acfac51b046875a
[update-cdn-dictionaries]: https://deploy.publishing.service.gov.uk/job/Update_CDN_Dictionaries/
[deploy-cdn]: https://deploy.publishing.service.gov.uk/job/Deploy_CDN/
[register]: https://docs.google.com/spreadsheets/d/1voQzdoGAFO9Tnvl7Xq4ahLEAyGtkeAtvTC26SxEP6rE/edit

## 5. Further reading

- ["A/B testing at the edge" - Fastly blog](https://www.fastly.com/blog/ab-testing-edge)
- ["Best Practices for Using the Vary Header" - Fastly blog](https://www.fastly.com/blog/best-practices-for-using-the-vary-header)

[fastly]: https://www.fastly.com/
[pass-folder]: https://github.com/alphagov/govuk-secrets/tree/master/pass
