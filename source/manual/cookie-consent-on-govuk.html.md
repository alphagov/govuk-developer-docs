---
owner_slack: "#govuk-developers"
title: Cookie consent on GOV.UK
parent: "/manual.html"
layout: manual_layout
type: learn
section: Cookies
---

This is technical documentation for the [GOV.UK](https://www.gov.uk/) team in the [Government Digital Service (GDS)](https://gds.blog.gov.uk/about/).

## Overview

GOV.UK sets 4 types of cookies: essential (also called "strictly necessary"); website usage; communications and marketing; settings. These are detailed on the [cookie settings page on GOV.UK][cookie settings page].

Users can manage their consent via the banner or [cookie settings page]. "Strictly necessary" cookies cannot be switched off by users as they're essential to site functionality.

Cookie consent is set to last for 1 year, after which the consent cookie will expire and users will be shown the cookie banner and prompted for consent again.

## Cookie consent mechanism

The cookie consent mechanism is made up of 4 main pieces:

* [Cookie banner component]
* [Page template which pulls in the cookie banner]
* [Cookie settings page][cookie settings page]. This is published as a [special route]. See the [Cookie settings page in Frontend GitHub repo].
* [Cookie details page]. This is a standard help page, created in Publisher.

When a user first lands on GOV.UK, they are given a default consent cookie that looks like this:

```javascript
cookies_policy = { "essential": true, "settings": false, "usage": false, "campaigns": false }
```

This cookies_policy cookie is the key to the GOV.UK cookie consent mechanism. If any of these values read as false, cookies of that type will not be set.

For example, the below cookie will result in Google Analytics tracking being disabled for that user:

```javascript
cookies_policy = { "essential": true, "settings": true, "usage": false, "campaigns": true }
```

If the user clicks “Accept cookies” within the cookie banner or changes their cookie settings on the settings page, they get an additional cookie that ensures they don’t see the cookie banner again:

```javascript
cookies_preferences_set
```

Users can still change their consent via the [cookie settings page].

## Special Cases

### Google Analytics

GOV.UK uses [Google Analytics](https://docs.publishing.service.gov.uk/manual/analytics.html) to track user journeys.

Unlike other cookies on GOV.UK, Google Analytics (GA) cookies are not set using our cookie helpers. GA cookies are initialised within Static. Therefore, as well as deleting the GA cookies, we also need to [wrap the initialisation of GOVUK.Analytics](https://github.com/alphagov/static/blob/master/app/assets/javascripts/analytics/static-analytics.js#L21) to ensure the cookies are not recreated.

We also set the following property to disable tracking:

```javascript
window['ga-disable-UA-26179049-1'] = true
```

This is the [recommended approach](https://developers.google.com/analytics/devguides/collection/analyticsjs/user-opt-out) by Google for user opt-out of tracking.

### Youtube

Some pages on GOV.UK contain embedded Youtube videos. On these pages, Youtube sets third-party cookies which we are unable to delete.

If a user does not consent to campaign cookies, we [swap the embedded video for a link to the video on Youtube](https://govuk-publishing-components.herokuapp.com/component-guide/govspeak/with_youtube_embed_disabled). This means that Youtube does not set any third-party cookies because the video is no longer embedded.

### No Javascript

If Javascript is turned off, the “accept” button is removed from the banner and the cookie settings form is removed. A message is shown instead.

## Adding a new cookie

If your cookie is set using Javascript:

1. Decide which category the cookie falls into
2. Add the cookie to the [list of known cookies](https://github.com/alphagov/govuk_publishing_components/blob/master/app/assets/javascripts/govuk_publishing_components/lib/cookie-functions.js#L14)
3. When reading and setting the cookie, make sure you use the cookie helper functions within govuk_publishing_components, e.g:

  ```javascript
  window.GOVUK.cookie(‘please set this cookie’, ‘to this value’)
  window.GOVUK.cookie(‘please fetch this cookie’)
  ```

Regardless of how your cookie is set, you need to update the cookie details page to list the new cookie. A content designer should be able to help with that.

## Changing a cookie’s category

If your cookie is set using Javascript:

1. Decide which category the cookie falls into
2. Change the category the cookie is associated with, in the [list of known cookies](https://github.com/alphagov/govuk_publishing_components/blob/master/app/assets/javascripts/govuk_publishing_components/lib/cookie-functions.js#L14)

Regardless of how your cookie is set, you need to do the following:

* update the cookie details page to list the cookie under the correct section. A content designer should be able to help with that.
* Update the category descriptions on the cookie settings page if they are no longer correct
* Reset the banner for all users. Otherwise the consent cookie will stay as the old value reflecting the user’s previous decision, which could change given the new category.

## Adding a cookie category

* Add the new cookie category to the [Cookie settings page in Frontend GitHub repo]
* Add the new cookie category to the [Cookie details page] using Publisher.
* Add to the default consent cookie
* Add to ‘approve all’ consent cookie function
* Add relevant cookies within the list of known cookies
* Reset the banner for all users. Otherwise the consent cookie will stay as the old value (without the new category) for people who already have the consent cookie, so setting cookies of that new type will fail for those users

## Removing a cookie category

* Remove the cookie category from [Cookie settings page in Frontend GitHub repo]
* Remove the cookie category from [Cookie details page] using Publisher. Delete cookies or move to another relevant category
* Remove the cookie category from default consent cookie
* Remove the cookie category from 'approve all consent cookie' function
* Remove cookies from known list OR move to another relevant category

[cookie settings page]: https://www.gov.uk/help/cookies
[Cookie settings page in Frontend GitHub repo]: https://github.com/alphagov/frontend/blob/master/app/views/help/cookie_settings.html.erb
[Page template which pulls in the cookie banner]: https://github.com/alphagov/static/blob/54706a6eddcf71e2d6cd36b3239798293530d4e6/app/views/layouts/govuk_template.html.erb#L50
[Cookie banner component]: https://govuk-publishing-components.herokuapp.com/component-guide/cookie_banner
[special route]: publish_special_routes.html
[Cookie details page]: https://www.gov.uk/help/cookie-details
