# GOV.UK Developer Docs

> ⚠️ This project is being rebuilt and is undergoing rapid change. File an issue before opening a PR.


Live at: https://govuk-tech-docs.herokuapp.com (normal GDS username/password)

We're in the process of moving this to docs.publishing.service.gov.uk so it can be open.

## Technical documentation

This is a static site generated with Middleman.

## Tech docs template

This project uses the [tech-docs-template](https://github.com/alphagov/tech-docs-template).

This means that some of the files (like the CSS, javascripts and layouts) are
managed in the template and are not supposed to be modified here.

You can pull down the latest version of the template by running:

```
bin/update
```

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

### Building the project

Build the site with:

```
bundle exec middleman build
```

This will create a bunch of static files in `/build`.

## Licence

[MIT License](LICENCE.md)
