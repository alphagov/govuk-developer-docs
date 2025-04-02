# GOV.UK Developer Docs

👉 https://docs.publishing.service.gov.uk/

This is a static site generated with Middleman, using [alphagov/tech-docs-template](https://github.com/alphagov/tech-docs-template).

Some of the files (like the CSS, javascripts and layouts) are managed in the template and are not supposed to be modified here. Any project-specific Ruby code needs to go into `/app`.

## Run the app locally

Run govuk-developer-docs either inside or outside govuk-docker, configuring its behaviour with the ENV variables below.

### ENV variables

- `GITHUB_TOKEN=<your private token>` - token to use to make authenticated requests to GitHub's API. Authenticated requests have a much higher rate limit. *You _will_ need to specify a `GITHUB_TOKEN` if you want to build the entire Developer Docs site*. [Create the token on GitHub](https://github.com/settings/tokens/new) (the token doesn't need any scopes).
- `SKIP_PROXY_PAGES=true` - avoid fetching remote 'docs/' for each repo (i.e. just build the docs that live within govuk-developer-docs itself). You can use this if you don't have a `GITHUB_TOKEN` or if you don't care about including the remote docs.
- `NO_CONTRACTS=true` - [recommended setting](https://github.com/alphagov/govuk-developer-docs/commit/4b624a72761490c8e9b99a1aa7a10371415381e6) for speeding up the site build process

### Run with govuk-docker

govuk-docker doesn't have great support for passing ENV vars into the application startup. You'll need to [edit the docker-compose.yml](https://github.com/alphagov/govuk-docker/blob/ed98d3547708286f534598c78fb5c57ee3c8d112/projects/govuk-developer-docs/docker-compose.yml#L12-L17) to add the necessary ENV vars (e.g. `GITHUB_TOKEN`) under the `environment` property for both the `govuk-developer-docs-app` and `govuk-developer-docs-lite` groups, eg:

```yml
   environment:
      GITHUB_TOKEN: "<fill it in>"
```

1. In govuk-docker:
  1. Edit `govuk-docker/projects/govuk-developer-docs/docker-compose.yml` as above
  1. [make the project](https://docs.publishing.service.gov.uk/repos/govuk-docker.html#usage)
1. In govuk-developer-docs:
  1. Install the dependencies (`govuk-docker-run bundle install`)
  1. Run the application (`govuk-docker-up`)
  1. Wait until all the GitHub API calls have completed (you'll see `Inspect your site configuration at` in the output). This can take a few minutes.
1. Visit <http://govuk-developer-docs.dev.gov.uk/>

### Run without govuk-docker

1. Install the dependencies (`bundle install`)
1. Start up the site with `./startup.sh` (passing ENV vars on the CLI if necessary)

## Building the project, and running tests

If you just want to create the site (a `build/` directory containing a set of HTML files), but not actually start up the application, you can do so as follows (again, the ENV variables described above apply here too):

```sh
NO_CONTRACTS=true bundle exec middleman build --verbose
```

To run the tests:

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

## List markup

The Tech Docs template uses Redcarpet as its [Markdown engine][], which is quite
particular about how to nest lists and different types of content within them.
The gem has an infrequent release cadence and many known [issues with list
parsing][].

A different number of line breaks and spaces (for indentation) are needed for
different types/combinations of content, and existing code is not guaranteed to
be 'correct' as far as Redcarpet is concerned, so be sure to pay attention to
how lists get rendered by running the app locally or deploying to integration
before merging changes. Formatters like Prettier are unlikely format lists in a
Redcarpet-compliant way.

Example of addressing list parsing issues:

- 75666849c773549572decedf883cea1e8f1743ee
- 897595e7704e96fc302a58b913e7b3f5a0594953

[issues with list parsing]:
  https://github.com/vmg/redcarpet/issues?q=is%3Aissue%20state%3Aopen%20list
[Markdown engine]:
  https://github.com/alphagov/tech-docs-gem/blob/3720daadaf3f8e4693fe74c1c591493fe567b7fc/lib/govuk_tech_docs.rb#L56

## Licence

[MIT License](LICENCE)

[ci.yml]: /.github/workflows/ci.yml
