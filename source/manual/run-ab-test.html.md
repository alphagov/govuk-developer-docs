---
title: Run an A/B or multivariate test
parent: "/manual.html"
layout: manual_layout
section: A/B testing
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2019-01-31
review_in: 6 months
---

## 1. How to set up an A/B test

### Choose your test name

The name should begin with `ABTest-`.  You will have to put a description on
[the cookies page](https://www.gov.uk/help/cookies#multivariate-testing) so you
can keep the name quite short.

You don't need to use the `ABTest-` prefix
in [your code](https://github.com/alphagov/collections/blob/54dd7d22567ec932a16c262387ae609e9cc47aae/app/controllers/concerns/taxon_pages_testable.rb#L25)
though as [it's already configured in Fastly](https://github.com/alphagov/govuk-cdn-config/blob/955dd25e6443a8fd7142cebdb60d7bee43a067b7/vcl_templates/www.vcl.erb#L348).

### Decide how the variants should be split

A higher percentage on your B variant will reduce the time that you need to run
the test.  Your performance analyst can help here.

You may want to start with a small percentage and ramp up gradually though,
particularly if there's something a bit controversial in your test.

### Choose your cookie expiry

The cookie expiry time should be short until you have established traffic across
the desired split between your variants.

Once your variants are at the desired proportions, the cookie expiry time should
be longer than the expected test duration.  This ensures that users are kept in
the same variant for the duration of the test which allows them to get used to
whatever changes you have made.

It's good to have a margin for error, to (for example) correct faulty tracking
at the start, or perhaps run the test for a few more days at the end if you
need more data.

### Implementation

1. Get your cookie listed on the [cookies page](https://www.gov.uk/help/cookies). Raise a ticket on [GOV.UK Zendesk](https://govuk.zendesk.com) and assign it to the content team's 2nd line GOV.UK content triage. They need to know the name of the cookie that you will be using, a description and the expiry time.
1. Add your test to the [A/B test register][register].
1. If you want to use Google Analytics to monitor the A/B test, talk to a performance analyst and pick a [GA dimension][analytics-dimensions] to use for your test.
1. Configure the A/B test in [the cdn-configs repo][cdn-configs] ([see an example][dictionary-config-example]). For more details, see the [dictionaries README][dictionaries-readme].
1. Deploy the cdn-configs changes to each environment using the [Update_CDN_Dictionaries][update-cdn-dictionaries] Jenkins job. The `vhost` must be set to `www`, and the credentials are in the [govuk-secrets repo][govuk-secrets] ([pass folder][pass-folder]).
1. Add your test to the [ab_tests configuration file][configuration-file] in the [cdn-configs][cdn-configs] repo ([see an example][cdn-config-example]). The test name must match the name configured in the cdn-configs repo in step 3.
. Deploy the Fastly configuration to each environment using the [Deploy_CDN][deploy-cdn] Jenkins job. Use the same parameters as in step 4. You can test it on staging by visiting <https://www.staging.publishing.service.gov.uk>. Changes should appear almost immediately - there is no caching of the CDN config.
1. Use the [govuk_ab_testing gem][govuk_ab_testing] to serve different versions to your users. It can be configured with the analytics dimension selected in step 2.
1. To activate or deactivate the test, or to change the B percentage, update your test in [the cdn-configs repo][cdn-configs] and deploy the change.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## 2. How to tear down an A/B test

Follow these steps:

1. Remove your test from the [ab_tests configuration file][configuration-file] in the [cdn-configs][cdn-configs] repo.
2. Deploy the Fastly configuration to each environment using the [Deploy_CDN][deploy-cdn] Jenkins job. The `vhost` must be set to `www`, and the credentials are in the govuk-secrets repo.
3. Remove your test from [the cdn-configs repo][cdn-configs]. If you are removing the very last A/B test, you should replace the last test name with `[]` ([See an example of having no A/B tests][dictionary-removal-example]).
4. Deploy the cdn-configs changes to each environment using the [Update_CDN_Dictionaries][update-cdn-dictionaries] Jenkins job. Use the same parameters as in step 2.
5. Get your cookie removed from the [cookies page](https://www.gov.uk/help/cookies). Raise a ticket on [GOV.UK Zendesk](https://govuk.zendesk.com) and assign it to the content team's 2nd line GOV.UK content triage.
6. Mark the end date in [A/B test register][register].

[analytics-dimensions]: https://gov-uk.atlassian.net/wiki/display/GOVUK/Analytics+on+GOV.UK
[cdn-configs]: https://github.com/alphagov/cdn-configs
[dictionaries-readme]: https://github.com/alphagov/cdn-configs/blob/master/fastly/dictionaries/README.md
[dictionary-config-example]: https://github.com/alphagov/cdn-configs/commit/ba3ec923c0bb5bdf17bdaf02419ff4e049516fda
[govuk_ab_testing]: https://github.com/alphagov/govuk_ab_testing
[configuration-file]: https://github.com/alphagov/govuk-cdn-config/blob/master/ab_tests/ab_tests.yaml
[cdn-config-example]: https://github.com/alphagov/fastly-configure/pull/29/files
[dictionary-removal-example]: https://github.com/alphagov/cdn-configs/commit/1e98e41ef87091e6fab6881a6acfac51b046875a
[update-cdn-dictionaries]: https://deploy.publishing.service.gov.uk/job/Update_CDN_Dictionaries/
[deploy-cdn]: https://deploy.publishing.service.gov.uk/job/Deploy_CDN/
[register]: https://docs.google.com/spreadsheets/d/1voQzdoGAFO9Tnvl7Xq4ahLEAyGtkeAtvTC26SxEP6rE/edit
