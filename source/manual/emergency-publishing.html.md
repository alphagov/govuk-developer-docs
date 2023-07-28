---
owner_slack: "#govuk-2ndline-tech"
title: Deploy an emergency banner
parent: "/manual.html"
layout: manual_layout
section: Publishing
important: true
---

In emergencies, GOV.UK can display important information in a banner at the top
of each page of the website.

> There is also [a non-emergency sitewide banner](/manual/global-banner.html),
> used to convey important information on GOV.UK which is not deemed
> emergency-level information.

## When to deploy an emergency banner

GOV.UK publishes an emergency banner when there is:

- a notable death
- a national emergency
- a local emergency

The [GOV.UK Programme Team
on-call](https://governmentdigitalservice.pagerduty.com/schedules/PCK3XB2)
(also known as the Senior Management Team escalations contact) will tell you if
you need to deploy an emergency banner. This could happen outside normal office
hours if you are on-call.

## Deploy an emergency banner

### 1. Obtain the content for the banner

The GOV.UK Programme Team on-call will give you:

- the [type of emergency banner](#types-of-emergency-banners):
  `notable-death`, `national-emergency` or `local-emergency`
- text for the heading

They may optionally also give you:

- text for the 'short description' (a sentence displayed under the heading)
- a URL for users to find more information (a relative URL if it's on www.gov.uk)
- alternative link text for the "More information" link

### 2. Deploy the banner

1. Set the banner content as environment variables in your shell.

    > You may need to escape certain characters (including `,` and `"`) with a
    > backslash. For example `\,` or `\"`.

    ```bash
    CAMPAIGN_CLASS="notable-death|national-emergency|local-emergency"
    HEADING="replace with heading"
    SHORT_DESCRIPTION="replace with description"
    LINK="replace with link"
    LINK_TEXT="replace with link text"
    ```

1. Run the Rake task, passing it the environment variables.

    ```bash
    kubectl -n apps exec deploy/static -- rake "emergency_banner:deploy[$CAMPAIGN_CLASS,$HEADING,$SHORT_DESCRIPTION,$LINK,$LINK_TEXT]"
    ```

### 3. Check that the banner works

Most GOV.UK pages have a cache `max-age` of 5 minutes. After deploying the
emergency banner you should expect to see the banner on all GOV.UK pages within
10 minutes.

Once the banner deployment completes:

1. Wait 1 minute to allow frontend application caches to expire.
1. Visit a page and add a cache-bust query string (a question mark followed by
   some random string of your choice) to the URL.
1. Don't forget to change the URL to reflect the environment (staging,
   production) that you are checking.
1. Wait 10 minutes, then check that the emergency banner is visible without the
   cache-bust string.

You must check that:

- the banner displays as expected
- the header, short description and link text are correct
- the link (if applicable) works
- the banner is the right colour: black for notable death, red for national
  emergency, green for local emergency

If the banner doesn't show, see [Troubleshoot the emergency banner](#troubleshoot-the-emergency-banner).

#### Some example pages to check

- [https://www.gov.uk/](https://www.gov.uk/) ([staging](https://www-origin.staging.publishing.service.gov.uk/))
- [https://www.gov.uk/financial-help-disabled](https://www.gov.uk/financial-help-disabled) ([staging](https://www-origin.staging.publishing.service.gov.uk/financial-help-disabled))
- [https://www.gov.uk/government/organisations/hm-revenue-customs](https://www.gov.uk/government/organisations/hm-revenue-customs) ([staging](https://www-origin.staging.publishing.service.gov.uk/government/organisations/hm-revenue-customs))
- [https://www.gov.uk/search](https://www.gov.uk/search) ([staging](https://www-origin.staging.publishing.service.gov.uk/search))

## Remove an emergency banner

Run the `emergency_banner:remove` Rake task.

```bash
kubectl -n apps exec deploy/static -- rake emergency_banner:remove
```

---

## Troubleshoot the emergency banner

### Background

- The information for the emergency banner is stored in a Redis key as a Ruby
  hash (key-value map).
- A [Rake task in
  Static](https://github.com/alphagov/static/blob/main/lib/tasks/emergency_banner.rake)
  sets or removes the Redis key.
- Static is responsible for reading the data from Redis and rendering a partial
  page from a template.
- Frontend rendering apps retrieve this partial page from Static via the
  Slimmer library, which caches the response for up to 60 seconds.

### The banner is not showing / not clearing

Usually this is because some cached content has not yet expired. This could be
in frontend rendering apps, in Static, or in your browser.

1. Double-check that you are looking at the right environment.
1. Use a fresh private/Incognito window so that your testing is not affected by
   browser state such as cookies or cache.
1. Check whether the banner appears on www-origin
   ([staging](https://www-origin.staging.publishing.service.gov.uk),
   [production](https://www-origin.production.publishing.service.gov.uk)). If
   the banner works on origin but not on www.gov.uk, wait 5 minutes then try
   again.
   - It is possible to [flush pages from the CDN
     cache](/manual/purge-cache). This
     should not be necessary unless there is a bug or misconfiguration in
     GOV.UK.
1. Check the banner is present in the page template from Static
   ([staging](https://assets.staging.publishing.service.gov.uk/templates/gem_layout_homepage.html.erb),
   [production](https://assets.publishing.service.gov.uk/templates/gem_layout_homepage.html.erb)).
1. [Inspect the Redis key](#inspect-the-redis-key) to check whether the Rake
   task stored the banner data successfully.
1. Try forcing a [rollout of Static](/manual/deploy-static.html), to eliminate
   any temporary state stored in Static.
1. Try clearing the frontend memcache. Log into the AWS web console for the
   appropriate environment, find [frontend-memcached-govuk under Elasticache,
   Memcached
   clusters](https://eu-west-1.console.aws.amazon.com/elasticache/home?region=eu-west-1#/memcached/frontend-memcached-govuk)
   and press the Reboot button. The UI will ask you to confirm the request.

[Slimmer cache]: https://github.com/search?q=repo%3Aalphagov%2Fslimmer%20CACHE_TTL&type=code

### Inspect the Redis key

You can query Redis to check whether the banner data has been stored.

1. Open a Rails console for Static.

    ```bash
    kubectl -n apps exec -it deploy/static -- rails c
    ```

1. Retrieve the value of the Redis key.

    ```rb
    Redis.new.hgetall("emergency_banner")
    ```

    If an emergency banner is active, the value should look similar to:

    ```rb
    => {"campaign_class"=>"notable-death", "heading"=>"The heading", "short_description"=>"The short description", "link"=>"https://www.gov.uk", "link_text"=>"More information about the emergency"}
    ```

    If there is no banner, the value should be empty:

    ```rb
    => {}
    ```

---

## Types of emergency banners

### Death of a notable person

A large **black** banner is displayed on all GOV.UK pages, including the homepage.

The wording to use in the template will be the official title of the
deceased and the years of their life, for example 'His Royal Highness Henry VIII
1491 to 1547'. The text should link to their official biography.

#### GOV.UK Homepage

![Banner with large, bold, white heading text on a black background, above the the usual Welcome to GOV.UK heading](images/emergency_publishing/notable-death-homepage.png)

#### Other pages

![Banner with small, bold heading text on a black background, above the breadcrumb bar and ordinary page title](images/emergency_publishing/notable-death.png)

### National emergency (level 1 or category 2)

A large **red** banner is displayed on all GOV.UK pages, including the homepage.

#### GOV.UK Homepage

![Banner with large, bold, white heading text on a red background, above the usual Welcome to GOV.UK heading](images/emergency_publishing/national-emergency-homepage.png)

#### Other pages

![Banner with small, bold heading text on a red background, above the breadcrumb bar and ordinary page title](images/emergency_publishing/national-emergency.png)

### Localised large-scale emergency (level 2 or category 1)

A large **green** banner is displayed on all GOV.UK pages, including the homepage.

These incidents will not be processed outside of business hours.

#### GOV.UK Homepage

![Banner with large, bold, white heading text on a green background, above the the usual Welcome to GOV.UK heading](images/emergency_publishing/local-emergency_homepage.png)

#### Other pages

![Banner with small, bold heading text on a green background, above the breadcrumb bar and ordinary page title](images/emergency_publishing/local-emergency.png)
