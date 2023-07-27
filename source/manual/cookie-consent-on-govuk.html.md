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

GOV.UK sets 4 types of cookies: essential (also called "strictly necessary"); website usage; communications and marketing; settings. These are detailed on the [cookie settings page] on GOV.UK.

Users can manage their consent via the banner or [cookie settings page]. "Strictly necessary" cookies cannot be switched off by users as they're essential to site functionality.

Cookie consent is set to last for 1 year, after which the consent cookie will expire and users will be shown the cookie banner and prompted for consent again.

## Cookie consent mechanism

The cookie consent mechanism is made up of 4 main pieces:

* [Cookie banner component][] (see the [cookie banner code] in `govuk_publishing_components`)
* [Public layout component][] which pulls in the cookie banner (see the [public layout code] in `govuk_publishing_components`)
* [Cookie settings page][] (published as a [special route]; see the [cookie settings page code] in `frontend`)
* [Cookie details page][] (a standard help page, created in Publisher)

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

GOV.UK uses [Google Analytics](/manual/analytics.html) to track user journeys.

Unlike other cookies on GOV.UK, Google Analytics (GA) cookies are not set using our cookie helpers. GA cookies are initialised within Static. Therefore, as well as deleting the GA cookies, we also need to [wrap the initialisation of GOVUK.Analytics](https://github.com/alphagov/static/commit/5407c0d14a4eecf03619c4d7463a1097368fae4d#diff-db159f6ce52141b9dd276c2150489d59a3481f6796cf644e5b3fe95aeb749c01L1) to ensure the cookies are not recreated.

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
  window.GOVUK.cookie('please set this cookie', 'to this value')
  window.GOVUK.cookie('please fetch this cookie')
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

* Add the new cookie category by changing the [cookie settings page code]
* Add the new cookie category to the [cookie details page] using Publisher.
* Add to the default consent cookie
* Add to ‘approve all’ consent cookie function
* Add relevant cookies within the list of known cookies
* Reset the banner for all users. Otherwise the consent cookie will stay as the old value (without the new category) for people who already have the consent cookie, so setting cookies of that new type will fail for those users

## Removing a cookie category

* Remove the cookie category by changing the [cookie settings page code]
* Remove the cookie category from [cookie details page] using Publisher. Delete cookies or move to another relevant category
* Remove the cookie category from default consent cookie
* Remove the cookie category from 'approve all consent cookie' function
* Remove cookies from known list OR move to another relevant category

[cookie settings page]: https://www.gov.uk/help/cookies
[cookie settings page code]: https://github.com/alphagov/frontend/blob/master/app/views/help/cookie_settings.html.erb
[cookie banner component]: https://components.publishing.service.gov.uk/component-guide/cookie_banner
[cookie banner code]: https://github.com/alphagov/govuk_publishing_components/blob/master/app/views/govuk_publishing_components/components/_cookie_banner.html.erb
[public layout component]: https://components.publishing.service.gov.uk/component-guide/layout_for_public
[public layout code]: https://github.com/alphagov/govuk_publishing_components/blob/master/app/views/govuk_publishing_components/components/_layout_for_public.html.erb#L86
[special route]: publish_special_routes.html
[cookie details page]: https://www.gov.uk/help/cookie-details
