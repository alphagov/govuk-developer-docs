# GOV.UK Developer Docs

Spike into generating GOV.UK developer documentation by pulling in existing documentation.

### Dependencies

- Ruby 2.3.1
- Graphviz (`brew install graphviz`)
- `gds-api-adapters` in a sibling directory
- `govuk-content-schemas` in a sibling directory

### Running locally

The first time you'll need to bundle:

```
bundle install
```

To run the app locally:

```
bundle exec jekyll serve --watch
```

The app will appear at http://127.0.0.1:4000/govuk-developers/

### Data generation

```
bundle exec rake build
```

You may need a GitHub auth token if you find yourself rate limited. You can create one here:

https://github.com/settings/tokens/new

It doesn't need any permissions.

Use it like this:

```
GITHUB_TOKEN=somethingsomething rake build_data
```

### Building the project

Build the site with:

```
bundle exec jekyll build
```

This will create a bunch of static files in `/build`.

### Deployment

This site is hosted on GitHub pages. It will build the master branches automatically.

A [Jenkins job is set up](https://deploy.publishing.service.gov.uk/job/govuk-developers/) to refresh the data periodically.

## Licence

[MIT License](LICENCE.md)
