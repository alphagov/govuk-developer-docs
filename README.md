# GOV.UK Developer Docs

👉 https://docs.publishing.service.gov.uk

This is a static site generated with Middleman, using [alphagov/tech-docs-template](https://github.com/alphagov/tech-docs-template).

Some of the files (like the CSS, javascripts and layouts) are managed in the template and are not supposed to be modified here. Any project-specific
Ruby code needs to go into `/app`.

## Technical documentation

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) to run the application and its tests with all the necessary dependencies. Follow [the usage instructions](https://github.com/alphagov/govuk-docker#usage) to get started.

**Use GOV.UK Docker to run any commands that follow.**

### Running the app

The docs include pages pulled from other GitHub repositories. By default, these are loaded eagerly by Middleman.

You can skip eager loading of resources by setting a `SKIP_PROXY_PAGES` variable.

If you do not do this, you will need to create a GitHub auth token to avoid getting rate limited.

#### Skipping proxied pages from other repositories

```
SKIP_PROXY_PAGES=true ./startup.sh
```

Note that `middleman server` will still try to load these pages lazily on some pages (e.g. the docs homepage, or the applications list), so you'll either need to avoid these pages or use a GitHub auth token.

#### Using a GitHub auth token

[Create a GitHub auth token](https://github.com/settings/tokens/new) (the token doesn't need any permissions). Store the token in a `.env` file like this:

```
GITHUB_TOKEN=somethingsomething
```
Example start up commands:
```
govuk-docker-up env GITHUB_TOKEN=$(cat ~/github_token.txt)
GITHUB_TOKEN=$(cat ~/github_token.txt) ./startup.sh
```

### Testing the app

```
bundle exec rake
```

### Updating the template

You can pull down the latest version of the Tech Docs template by running:

```sh
bin/update
```

### Deployment

This project is hosted on GitHub Pages. It is [redeployed hourly on weekdays][actions]
(to pick up changes to external docs) and whenever a PR is merged.

As part of the deployment, we build a static set of pages to minimise the response time
and potential issues with remote API calls.

```sh
NO_CONTRACTS=true bundle exec middleman build
```

This will create a bunch of static files in `/build`.

## Licence

[MIT License](LICENCE.md)

[actions]: https://github.com/alphagov/govuk-developer-docs/blob/main/.github/workflows/ci.yml
