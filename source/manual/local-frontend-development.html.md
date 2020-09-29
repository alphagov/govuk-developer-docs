---
owner_slack: "#govuk-developers"
title: Local frontend development
parent: "/manual.html"
layout: manual_layout
section: Frontend
type: learn
---

## Using startup scripts

If you are making changes to a frontend app and nothing else, you can view these changes by running the application's `./startup.sh` script. This example is for [government-frontend], but these instructions apply to any frontend app.

```shell
cd /govuk/government-frontend
./startup.sh --live
# Check the output to see what port the app is running on, e.g: localhost:3005
```

If you want to test changes in [govuk_publishing_components] against a frontend app, you need to edit your frontend app Gemfile and then run the startup script:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
```

```shell
bundle install
./startup.sh --live
# Check the output to see what port the app is running on, e.g: localhost:3005
```

## Using govuk-docker

This assumes that you have already installed and setup [govuk-docker]. We will use [government-frontend] as an example here, but these instructions apply to any frontend app.

If you are making changes to a frontend app and nothing else, you can view these changes by running the following:

```shell
cd /govuk/govuk-docker
make government-frontend

cd /govuk/government-frontend
govuk-docker up government-frontend-app-live # or govuk-docker-up app-live
# You can now view the app on government-frontend.dev.gov.uk
```

If you want to test changes in [govuk_publishing_components] against a frontend app, you need to edit your frontend app Gemfile first:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
```

```shell
cd /govuk/government-frontend
govuk-docker-run bundle install
govuk-docker up government-frontend-app-live
# You can now view the app on government-frontend.dev.gov.uk
```

If you want to test changes in static against a frontend app, you need to tell Docker to look at your local version of static rather than live:

```shell
cd /govuk/govuk-docker/projects/government-frontend
```

Open `government-frontend`'s `docker-compose.yml` file, then edit the live config to depend on static and remove the live static environment:

```yaml
  government-frontend-app-live:
    <<: *government-frontend-app
  depends_on:
    ...
    - static-app # This tells docker that the app relies on static running locally
  environment:
    ...
    # Comment out this line to stop pointing to live static
    #PLEK_SERVICE_STATIC_URI: assets.publishing.service.gov.uk
```

We can now run the frontend application as normal:

```shell
cd /govuk/govuk-docker
make government-frontend

cd /govuk/government-frontend
govuk-docker up government-frontend-app-live
# You can now view the app on government-frontend.dev.gov.uk
```

## Components pulled in by Static

Some components, such as the cookie banner, are pulled in by Static. To test changes to this component locally, we need to run a frontend app against both local static and local [govuk_publishing_components]. This can be done by combining the approaches above - just remember to update the Gemfile in Static too!

## Troubleshooting

### 504 Timeout Errors

Assets can load slowly, which means we get frequent timeouts when running apps locally. Some developers find that the following workaround can help:

1. Set `config.assets.debug` to `false` in the `development.rb` file in your frontend app
1. Run `bundle exec rake assets:precompile` manually
1. Start your app as normal

### Port already in use

You might sometimes find that you have something running on a port still, which stops you from starting up an app. To kill a process running on a port:

```shell
# replace [port number]
sudo fuser -k [port number]/tcp
```

[govuk_app_config]: https://github.com/alphagov/govuk_app_config
[frontend]: https://github.com/alphagov/frontend
[static]: https://github.com/alphagov/static
[govuk_publishing_components]: https://github.com/alphagov/govuk_publishing_components
[government-frontend]: https://github.com/alphagov/government-frontend
[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/docs/installation.md
