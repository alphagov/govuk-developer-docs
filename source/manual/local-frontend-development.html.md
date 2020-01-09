---
title: Local frontend development
parent: "/manual.html"
layout: manual_layout
section: Frontend
type: learn
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2019-12-27
review_in: 6 months
---

## Using startup scripts
If you are making changes to a frontend app and nothing else, you can view these changes by running the application `./startup.sh` script:

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

This assumes that you have already installed and setup [govuk-docker]. We will use [government-frontend] as an example here, but these instructions apply to any frontend app.

If you are making changes to a frontend app and nothing else, you can view these changes by running the following:

```shell
cd /var/govuk-docker
make government-frontend

cd /var/govuk/government-frontend
govuk-docker up government-frontend-app-live
```

If you want to test changes in static against a frontend app, you need to tell Docker to look at your local version of static rather than live:

1. Repoint static and frontend to the local version of `govuk_app_config`:

  ```ruby
  gem 'govuk_app_config', path: '../govuk_app_config'
  ```

2. Repoint frontend to local `govuk_publishing_components` if you are making changes there:

  ```ruby
  gem 'govuk_publishing_components', path: '../govuk_publishing_components'
  ```

3. Update in `govuk_app_config` the file `govuk_content_security_policy.rb` to allow all domains:

  ```ruby
  GOVUK_DOMAINS = [
  '.publishing.service.gov.uk',
  ".#{ENV['GOVUK_APP_DOMAIN_EXTERNAL'] || ENV['GOVUK_APP_DOMAIN'] || 'dev.gov.uk'}",
  ".dev.gov.uk",
  ""
  ].uniq.freeze
  ```

4. Set `config.assets.debug` to `false` in `development.rb` for static and frontend
5. Run from govuk-docker directory:

  ```shell
  $ make frontend
  $ govuk-docker-up frontend-app
  ```

  (or you can run the last command from the frontend directory as just `govuk-docker-up`)
6. Changes should be ok for http://frontend.dev.gov.uk/help

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
[govuk-docker]: https://github.com/alphagov/govuk-docker/blob/master/docs/installation.md
