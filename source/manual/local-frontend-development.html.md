---
title: Local frontend development
parent: "/manual.html"
layout: manual_layout
section: Frontend
type: learn
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2019-07-08
review_in: 6 months
---

Make the following changes to your setup if you are making changes to frontend apps and need to view those changes locally.

In the instructions below we are running the [frontend] app, but this would work for any of the other frontend apps such as [government-frontend].

## Running just a frontend app against live data

```shell
cd /var/govuk/frontend
./startup.sh --live
```

## Running a frontend app against changes in `govuk_publishing_components`

Update the Gemfile for the frontend app to point to your local `govuk_publishing_components` gem:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
```

Then run your frontend app again pointing to live:

```shell
./startup.sh --live
```

## Running a frontend app against changes in `static`

Make changes to the Gemfile of the frontend app you're working on as per [changes to govuk_publishing_components above](#running-a-frontend-app-against-changes-in-govuk_publishing_components), then set in `development.rb`:

```ruby
...
config.assets.debug = false
...
```

If you're making changes to the [govuk_publishing_components] gem that affect [static] and are likely things across the whole site, e.g: cookie banner (and survey banner possibly), update the Gemfile of [static] to point to the gem:

```ruby
...
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
...
```

Run up static:

```shell
cd /var/govuk/static
govuk_setenv static ./startup.sh --live
```

Run up frontend against local static (the `--live` flag means the rest runs against live data):

```shell
PLEK_SERVICE_STATIC_URI=localhost:3013 ./startup.sh --live
```

And you can see frontend running up locally with the right local dependencies:

[http://frontend.dev.gov.uk/](http://frontend.dev.gov.uk/)

> Note: You might sometimes find that you have something running on a port still, which stops you from starting up an app. To kill a process running on a port:

```shell
# replace [port number]
sudo fuser -k [port number]/tcp
```

[govuk_app_config]: https://github.com/alphagov/govuk_app_config
[frontend]: https://github.com/alphagov/frontend
[static]: https://github.com/alphagov/static
[govuk_publishing_components]: https://github.com/alphagov/govuk_publishing_components
[government-frontend]: https://github.com/alphagov/government-frontend
