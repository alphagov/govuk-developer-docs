---
owner_slack: "#2ndline"
title: Set up Heroku review apps for pull requests
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_at: 2016-11-20
review_in: 6 months
---

# Set up Heroku review apps for pull requests

[Review apps](https://devcenter.heroku.com/articles/github-integration-review-apps)
allow us to automatically deploy application changes into a brand
new Heroku app so that each Pull Request reviewer has a chance to see how it
looks with live data.

These are 2 examples of GOV.UK apps that have review apps enabled:
- [collections](https://github.com/alphagov/collections)
- [government-frontend](https://github.com/alphagov/government-frontend)

Follow the steps below in order to enable review apps for your GOV.UK
application.

## Create a Heroku account

If you don't have a Heroku account yet, please create one using your work email
address.

You can do so on this page: https://signup.heroku.com

## Create a new Heroku app via the UI

Login to Heroku and create a new application in the European availability zone.
Give the app a meaningful name to closely match the application name on GitHub.

## Enable your app to work on Heroku

There are 2 things needed to be configured before you can deploy your app to
Heroku:

- Add a [Procfile](https://devcenter.heroku.com/articles/procfile) that tells
heroku how to run your application;
- Add a file called `app.json` with the expected app configuration.

An example Procfile for a standard Rails application will look something like
this:

```
web: bin/rails server -p $PORT -e $RAILS_ENV
```

This is telling Heroku to run the standard Rails server on the given port and
environment, both set in the Heroku environment.

A standard `app.json` file for a Rails project will look somewhat like this:

```json
{
  "name": "govuk-app",
  "repository": "https://github.com/alphagov/govuk-app",
  "env": {
    "GOVUK_APP_DOMAIN": {
      "value": "www.gov.uk"
    },
    "GOVUK_WEBSITE_ROOT": {
      "value": "https://www.gov.uk"
    },
    "PLEK_SERVICE_CONTENT_STORE_URI": {
      "value": "https://www.gov.uk/api"
    },
    "PLEK_SERVICE_SEARCH_URI": {
      "value": "https://www.gov.uk/api"
    },
    "PLEK_SERVICE_STATIC_URI": {
      "value": "assets.digital.cabinet-office.gov.uk"
    },
    "RAILS_SERVE_STATIC_ASSETS": {
      "value": "yes"
    },
    "SECRET_KEY_BASE": {
      "generator": "secret"
    },
    "HEROKU_APP_NAME": {
      "required": true
    }
  },
  "image": "heroku/ruby",
  "buildpacks": [
    {
      "url": "https://github.com/heroku/heroku-buildpack-ruby"
    }
  ],
  "addons": []
}
```

There is more information about it on
https://devcenter.heroku.com/articles/app-json-schema.

Each GOV.UK application will have a set of dependencies, so the level of
configuration will vary. However, for most apps, you will need a number of
environment variables configured before you can successfully deploy the app to
Heroku.

Check out the `app.json` files on both
[collections](https://github.com/alphagov/collections/blob/master/app.json) and
[government-frontend](https://github.com/alphagov/government-frontend/blob/master/app.json)
for examples of necessary environment variables.

You can create the application via the `app.json` file.

You will need a successful deploy with a correct configuration before you can
deploy review apps.

If all goes well, you will be able to see your app on:
https://govuk-app.herokuapp.com

## Create a new pipeline on Heroku

Once you have a successful deployment of your app into Heroku and the `app.json`
file commited to the repository and in your master branch, you will now be able
to start using review apps.

On Heroku, create a new pipeline and enable automatic review apps when prompted.
At this point, every new Pull Request being opened on the GOV.UK application
will have a new review app being created from the `app.json` template and the
link will automatically be posted into the GitHub Pull Request.

That's it! Now try to create a new test Pull Request and verify that the
application is being deployed to a new review app.
