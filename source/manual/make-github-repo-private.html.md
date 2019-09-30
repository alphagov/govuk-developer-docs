---
title: Make a GitHub repo private
parent: /manual.html
layout: manual_layout
section: GitHub
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2019-08-08
review_in: 6 months
---

In cases of politically sensitive changes, we want to work in private rather than public. We can do this by creating a private fork of the repo, but this can be challenging if we need to deploy before the code can be made public. Another option is to make the repo private for a short period of time while we're working on it.

The following steps need to be completed to make a repo private. No changes should be needed for the release app or deployment process.

## 1. Set up authentication on Heroku apps
You will need to add the following to your `app.json` config within the application to require basic auth:

```json
"BASIC_AUTH_USERNAME": {
  "required": true
},
"BASIC_AUTH_PASSWORD": {
  "required": true
},
"REQUIRE_BASIC_AUTH": "true"
```

And add the following to `application_controller.rb`:

```ruby
if ENV["REQUIRE_BASIC_AUTH"]
  http_basic_authenticate_with(
    name: ENV.fetch("BASIC_AUTH_USERNAME"),
    password: ENV.fetch("BASIC_AUTH_PASSWORD")
  )
end
```

To define the username and password, you will need [access to the shared Heroku account](https://docs.publishing.service.gov.uk/manual/heroku.html).

On the [Heroku dashboard](https://dashboard.heroku.com/), locate the relevant pipeline for your application. Add the authentication to the production deployment Heroku app by browsing to Settings -> Config Vars and adding a `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD`. This will cascade down to review apps.

## 2. Update the application in the developer docs

Mark the application as being in a private repo by adding `private_repo: true` to the relevant application within [`applications.yml`](https://github.com/alphagov/govuk-developer-docs/blob/master/data/applications.yml).

## 3. Make sure the developer docs still work

The developer docs might pull in data directly from the repo using `ExternalDoc`. Make sure that those things are removed, as the Jenkins job doesn't have access to this repos.

## 4. Make the repository private

Within GitHub, navigate to Settings. The option to 'Mark this repository private' should appear at the bottom of the page, within the 'Danger Zone'.
