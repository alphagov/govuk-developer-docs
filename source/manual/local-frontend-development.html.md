---
owner_slack: "#govuk-developers"
title: Local frontend development
parent: "/manual.html"
layout: manual_layout
section: Frontend
type: learn
---

## Running applications locally

There are several ways of running applications locally when developing and you should choose the option that works best for your situation. For frontend developers, the following is recommended.

- if you are making changes in a single application, use the startup scripts
- if you are making changes in an application that relies upon a change in the components gem, use the startup scripts and point the application at your local components gem

The following sections contain specific details of these approaches.

### Using govuk-docker

This assumes that you have already installed and setup [govuk-docker]. We will use [government-frontend] as an example here, but these instructions apply to any frontend app.

If you are making changes to a frontend app and nothing else, you can view these changes by running the following:

```shell
cd ~/govuk/govuk-docker
make government-frontend

cd ~/govuk/government-frontend
govuk-docker-up app-live
# You can now view the app on government-frontend.dev.gov.uk
```

Some frontend apps can be run against integration too. For example:

```sh
cd ~/govuk/collections
govuk-docker-up app-integration
```

For `frontend`, if you wish to develop the CSV Preview functionality without having a local copy of Asset Manager, you will need to obtain a bearer token for Asset Manager from the [integration Signon](https://signon.integration.publishing.service.gov.uk/api_users), then add it as the value for `ASSET_MANAGER_BEARER_TOKEN` in `projects/frontend/docker-compose.yml`.

### Using startup scripts

If you are making changes to certain frontend apps you can also view these changes by running the application's `./startup.sh` script - if it has one. This example is for [government-frontend], but these instructions may apply to other frontend apps.

```shell
cd ~/govuk/government-frontend
./startup.sh --live
# Check the output to see what port the app is running on, e.g: localhost:3005
```

## Using a local components gem

If you want to test changes in [govuk_publishing_components] against a frontend app, you need to edit your frontend app Gemfile first:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
```

To make this change take effect when using govuk-docker, do the following.

```shell
cd [directory where application is]
govuk-docker-run bundle install
govuk-docker-up app-live
# You can now view the app on government-frontend.dev.gov.uk
```

To make this change take effect when using startup scripts, do the following.

```shell
cd [directory where application is]
bundle update govuk_publishing_components
```

## Troubleshooting

### JavaScript changes not appearing/JavaScript not working properly

Sometimes the main JavaScript files cannot be served properly when running locally. This happens when Rails automatically inserts fingerprinting into the script URLs when it is not needed e.g. `application-834y2r2hr292y9r.js` is being requested, but only `application.js` exists.

A workaround is to modify `_layout_for_public.html.erb` in your local `govuk_publishing_components` to hardcode the URLs to the broken JavaScript files (`application.js`, `load-analytics` and any others you need). For example, change:

```ruby
<%= javascript_include_tag "govuk_publishing_components/load-analytics" %>
```

to:

```ruby
<script src="/assets/static/govuk_publishing_components/load-analytics.js"></script>
```

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
[govuk_publishing_components]: https://github.com/alphagov/govuk_publishing_components
[government-frontend]: https://github.com/alphagov/government-frontend
[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/README.md

### Changes in assets don't appear

Occasionally when using govuk-docker you might find that changes made to JavaScript or Sass files aren't reflected in the browser, particularly when making changes to `govuk_publishing_components`. If this happens try the following.

- Check that all of your locally running applications are pointing at your local `govuk_publishing_components`.
- Check the `public/assets/<your app name>` directory. If it contains any pre-compiled assets try deleting them and restarting.
- Try restarting your locally running docker applications.
- If none of that works, you may have to recreate your local govuk-docker applications. Try removing all volumes, containers and images, and re-making all of your applications.
