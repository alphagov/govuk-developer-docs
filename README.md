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

This project is re-deployed by a Jenkins task every hour (to pick up external
changes). It is [hosted on S3][terraform].

## Pre-commit hooks

There are pre-commit hooks available to help when creating or editing markdown.

Install [pre-commit][]:

Homebrew:

```sh
brew install pre-commit
pre-commit install
```

Pip:

```sh
pip install pre-commit
```

Install [vale][] linter:

Homebrew:

```sh
brew tap ValeLint/vale
brew install vale
```

Install the binary:

Download the [latest release](https://github.com/valelint/vale/releases).

```sh
wget https://github.com/ValeLint/vale/releases/download/0.9.0/vale_0.9.0_Linux_64-bit.tar.gz
tar zxvf vale_0.9.0_Linux_64-bit.tar.gz
chmod +x vale && mv vale /usr/local/bin/vale
```

## Licence

[MIT License](LICENCE.md)

[terraform]: https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/developer_docs/resources
[pre-commit]: https://github.com/pre-commit/pre-commit
[vale]: https://github.com/ValeLint/vale
