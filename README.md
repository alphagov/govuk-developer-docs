# GOV.UK Developer Docs

👉 https://docs.publishing.service.gov.uk

This is a static site generated with Middleman, using [alphagov/tech-docs-template](https://github.com/alphagov/tech-docs-template).

Some of the files (like the CSS, javascripts and layouts) are managed in the template and are not supposed to be modified here. Any project-specific
Ruby code needs to go into `/app`.

## Technical documentation

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) to run the application and its tests with all the necessary dependencies. Follow [the usage instructions](https://github.com/alphagov/govuk-docker#usage) to get started.

**Use GOV.UK Docker to run any commands that follow.**

### Running the app

You will need to [create a GitHub auth token](https://github.com/settings/tokens/new) to build the project or run the full test suite, otherwise you will find yourself rate limited. It doesn't need any permissions.

Store the token in a `.env` file like this:

```
GITHUB_TOKEN=somethingsomething
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

[actions]: https://github.com/alphagov/govuk-developer-docs/blob/master/.github/workflows/ci.yml
