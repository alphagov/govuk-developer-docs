# GOV.UK Developer Docs

👉 https://docs.publishing.service.gov.uk/

This is a static site generated with Middleman, using [alphagov/tech-docs-template](https://github.com/alphagov/tech-docs-template).

Some of the files (like the CSS, javascripts and layouts) are managed in the template and are not supposed to be modified here. Any project-specific
Ruby code needs to go into `/app`.

## Run the app locally

Install the dependencies:

```sh
bundle install
```

You can then start up the site with `./startup.sh` (or `govuk-docker-up` if using [govuk-docker](https://github.com/alphagov/govuk-docker)). The startup script can optionally be configured with the following ENV variables:

- `GOVUK_TOKEN=<your private token>` - token to use to make authenticated requests to GitHub's API. Authenticated requests have a much higher rate limit. *You will need to specify a `GITHUB_TOKEN` if you want to build the entire Developer Docs site*. You can [create a GitHub token](https://github.com/settings/tokens/new) (the token doesn't need any scopes).
- `SKIP_PROXY_PAGES=true` - avoid fetching remote 'docs/' for each repo (i.e. just build the docs that live within govuk-developer-docs itself). You can use this if you don't have a `GITHUB_TOKEN` or if you don't care about including the remote docs.

If using govuk-docker, you may struggle to pass ENV variables to the script. You can work around this by [editing the docker-compose.yml](https://github.com/alphagov/govuk-docker/blob/ed98d3547708286f534598c78fb5c57ee3c8d112/projects/govuk-developer-docs/docker-compose.yml#L12) to add the following to the `govuk-developer-docs-lite` entry:

```yml
   environment:
      LANG: "C.UTF-8"
      GITHUB_TOKEN: "<fill it in>"
      NO_CONTRACTS: true
```

If you just want to create the site (a `build/` directory containing a set of HTML files), but not actyally start up the application, you can do so as follows (noting that the ENV variables described above apply here too):

```sh
NO_CONTRACTS=true bundle exec middleman build --verbose
```

## Run the tests locally

```
bundle exec rake
```

## Update to the latest Tech Docs template

```sh
bin/update
```

## Deployment

We host GOV.UK Developer Docs as a static site on GitHub Pages. The [ci.yml] GitHub Actions workflow updates the site automatically:

- when a PR is merged to the default branch
- on an hourly schedule, to pick up changes to docs included from other repos

## Licence

[MIT License](LICENCE)

[ci.yml]: /.github/workflows/ci.yml
