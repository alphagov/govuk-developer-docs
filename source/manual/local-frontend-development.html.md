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

## Using startup scripts
If you are simply making changes to a frontend app and nothing else, you can view these changes by running the application `./startup.sh` script:

```shell
cd /var/govuk/frontend
./startup.sh --live
```

If you want to test changes in [govuk_publishing_components] against a frontend app, you need to edit your frontend app Gemfile and then run the startup script:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
```

```shell
bundle install

./startup.sh --live
```

## Using govuk-docker
This assumes that you have already installed and setup [govuk-docker].

If you are simply making changes to a frontend app and nothing else, you can view these changes by running the following:

```shell
cd /var/govuk/frontend
govuk-docker up frontend-app-live
```

If you want to test changes in [govuk_publishing_components] against a frontend app, you need to edit your frontend app Gemfile first:

```ruby
gem 'govuk_publishing_components', path: '../govuk_publishing_components'
```

```shell
cd /var/govuk/frontend
bundle install
govuk-docker up frontend-app-live
```

If you want to test changes in static against a frontend app, you need to tell Docker to look at your local version of static rather than live:

```shell
cd /var/govuk/govuk-docker/projects/frontend
vim docker-compose.yml
```

Edit the docker-compose.yml live config to depend on static and remove the live static environment:

```yaml
  frontend-app-live:
    <<: *frontend-app
  depends_on:
    ...
    - static-app
  environment:
    ...
    #PLEK_SERVICE_STATIC_URI: assets.publishing.service.gov.uk
```

We can now run the frontend application as normal:

```shell
cd /var/govuk/frontend
govuk-docker up frontend-app-live
```

## Components pulled in by Static
Some components, such as the cookie banner, are pulled in by Static. To test changes to this component locally, we need to run a frontend app against both local static and local [govuk_publishing_components]. This can be done by combining the approaches above - just remember to update the Gemfile in Static too!

## Troubleshooting
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
