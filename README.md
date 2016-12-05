# GOV.UK Developer Docs

> ⚠️ This project is being rebuilt and is undergoing rapid change. File an issue before opening a PR.


Live at: https://govuk-tech-docs.herokuapp.com (normal GDS username/password)

## Technical documentation

This is a static site generated with Middleman.

### Dependencies

- Ruby

### Running locally

The first time you'll need to bundle:

```
bundle install
```

To run the app locally:

```
./startup.sh
```

The app will appear at [http://localhost:4567/](http://localhost:4567/)

You may need a GitHub auth token if you find yourself rate limited. You can create one here:

https://github.com/settings/tokens/new

It doesn't need any permissions.

Use it like this:

```
export GITHUB_TOKEN=somethingsomething
./startup.sh
```

### Deployment

This site is currently hosted on https://alphagov.github.io/govuk-developers/

GitHub is configured to host the `/docs` directory. A Jenkins job rebuilds the
site every hour during work hours on weekdays.

### Building the project

Build the site with:

```
bundle exec middleman build
```

This will create a bunch of static files in `/build`.

## Licence

[MIT License](LICENCE.md)
