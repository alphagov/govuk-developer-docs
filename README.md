# GOV.UK Developer Docs

👉 https://docs.publishing.service.gov.uk

## Technical documentation

This is a static site generated with Middleman.

## Tech docs template

This project uses [alphagov/tech-docs-template](https://github.com/alphagov/tech-docs-template).

This means that some of the files (like the CSS, javascripts and layouts) are
managed in the template and are not supposed to be modified here. Any project-specific
Ruby code needs to go into `/app`.

You can pull down the latest version of the template by running:

```sh
bin/update
```

### Dependencies

- Ruby

### Running locally

The first time you'll need to bundle:

```sh
bundle install
```

To run the app locally:

```sh
./startup.sh
```

The app will appear at [http://localhost:4567/](http://localhost:4567/)

You may need a GitHub auth token if you find yourself rate limited. You can create one here:

https://github.com/settings/tokens/new

It doesn't need any permissions.

Use it like this:

```sh
export GITHUB_TOKEN=somethingsomething
./startup.sh
```

### Building the project

Build the site with:

```sh
NO_CONTRACTS=true bundle exec middleman build
```

This will create a bunch of static files in `/build`.

### Testing

`bundle exec rake`

### Deployment

This project is hosted on GitHub Pages. It is [redeployed hourly on weekdays][actions]
(to pick up changes to external docs) and whenever a PR is merged.

## Licence

[MIT License](LICENCE.md)

[actions]: https://github.com/alphagov/govuk-developer-docs/blob/master/.github/workflows/ci.yml
