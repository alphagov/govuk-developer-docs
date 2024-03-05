# GOV.UK Developer Docs

👉 https://docs.publishing.service.gov.uk/

This is a static site generated with Middleman, using [alphagov/tech-docs-template](https://github.com/alphagov/tech-docs-template).

Some of the files (like the CSS, javascripts and layouts) are managed in the template and are not supposed to be modified here. Any project-specific
Ruby code needs to go into `/app`.

## Build the app locally

```sh
bundle install
```

## Run the tests locally

```
bundle exec rake
```

## Run the app locally

```sh
SKIP_PROXY_PAGES=true ./startup.sh
```

## Proxy pages

The live docs site includes pages from other alphagov GitHub repositories. To test this locally, omit `SKIP_PROXY_PAGES=true` from the command above.

The app downloads these "proxy pages" at startup and this can cause GitHub to rate limit your requests. You can pass a valid GitHub API token to the app to help avoid this:

1. [Create a GitHub token](https://github.com/settings/tokens/new). The token doesn't need any scopes.

1. Store the token in a `.env` file:

    ```sh
    GITHUB_TOKEN=somethingsomething
    ```

1. Start the application:

    ```sh
    ./startup.sh
    ```

## Update to the latest Tech Docs template

```sh
bin/update
```

## Deployment

We host GOV.UK Developer Docs as a static site on GitHub Pages. The [ci.yml] GitHub Actions workflow updates the site automatically:

- when a PR is merged to the default branch
- on an hourly schedule, to pick up changes to docs included from other repos

### Build the static site locally

```sh
NO_CONTRACTS=true bundle exec middleman build
```

This will create a `build` directory containing a set of HTML files.

## Licence

[MIT License](LICENCE)

[ci.yml]: /.github/workflows/ci.yml
