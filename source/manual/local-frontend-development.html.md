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
- if you are making changes that require a local static, use either govuk-docker or a combination of govuk-docker and the startup scripts

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

If you want to test changes in static against a frontend app, you need to tell Docker to look at your local version of static rather than live:

```shell
cd ~/govuk/govuk-docker/projects/government-frontend
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

### Using startup scripts and govuk-docker

If you need to run a local application with a local version of [static] it is also possible to do this with a combination of a startup script and govuk-docker.

First make and run static using govuk-docker using the instructions elsewhere on this page. Your local static should be running at `http://static.dev.gov.uk/`.

Next, modify your application's `startup.sh` script to point to this local static. Find the equivalent of the following line:

```ruby
PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-https://assets.publishing.service.gov.uk}
```

Modify it to the following and then run the startup script as normal. The first page may take a few minutes to appear.

```ruby
PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-http://static.dev.gov.uk}
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

Some components, such as the cookie banner, are pulled in by Static. To test changes to this component locally, we need to run a frontend app against both local static and local [govuk_publishing_components]. Remember to update the Gemfile in both Static and the application.

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
[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/README.md

### Changes in assets don't appear

Occasionally when using govuk-docker you might find that changes made to JavaScript or Sass files aren't reflected in the browser, particularly when running a local Static and making changes to `govuk_publishing_components`. If this happens try the following.

- Check that all of your locally running applications are pointing at your local `govuk_publishing_components`.
- Check the `static/public/assets` directory. If it contains any pre-compiled assets try deleting them and restarting.
- Try restarting your locally running docker applications.
- If none of that works, you may have to recreate your local govuk-docker applications. Try removing all volumes, containers and images, and re-making all of your applications.
