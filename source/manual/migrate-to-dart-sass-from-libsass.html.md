---
owner_slack: "#govuk-frontenders"
title: Migrate to Dart Sass from LibSass
parent: "/manual.html"
layout: manual_layout
section: Frontend
---

## What is Dart Sass?

[Dart Sass is the primary implementation](https://sass-lang.com/dart-sass/) of [Sass](https://sass-lang.com/), which means it gets new features before any other implementation.

## Why migrate from LibSass?

LibSass is now [deprecated](https://sass-lang.com/blog/libsass-is-deprecated/).

## Installation

1. Update your `Gemfile` to replace `sassc-rails` with `dartsass-rails` and run `bundle install` (or with Docker: `govuk-docker-run bundle install`)

```diff
+ gem "dartsass-rails"
- gem "sassc-rails"
```

**Note**, some dependencies of `sassc-rails` might be needed in your application. For example, `tilt` or `sprockets-rails` in which case you should manually add these dependencies to your `Gemfile`.

## Configuration

### Create a builds folder

Create a `builds` folder: `app/assets/builds` and add a file named `.keep` in the corresponding folder.

### Ignoring files

Update `.gitignore` to ignore all files in the `builds` folder , but not `.keep`.

```diff
+ /app/assets/builds
+ !/app/assets/builds/.keep
```

### Update the manifest file

Remove references to CSS files from the Sprockets manifest file: `app/assets/config/manifest.js`.

```diff
- //= link application.css
- //= link components/_component-1.css
- //= link components/_component-2.css
- //= link components/_component-3.css
- //= link components/_component-4.css
- //= link views/_view-1.css
- //= link views/_view-2.css
- //= link views/_view-3.css
- //= link views/_view-4.css
  ...
```

Add a `link_tree` directive to link all files in all subdirectories of the `builds` folder.

```diff
+ //= link_tree ../builds
```

### Add an initializer

Add an initializer which holds all Sass entry points. The hash key is the relative path to a Sass file in `app/assets/stylesheets/` and the hash value will be the name of the file output to `app/assets/builds/`. **Note**, if your application uses [GOV.UK Publishing Components](https://github.com/alphagov/govuk_publishing_components), and the [stylesheets are individually loaded](https://github.com/alphagov/govuk_publishing_components/blob/main/docs/set-up-individual-component-css-loading.md), you will need to merge all entry points, including those from your application and those from GOV.UK Publishing Components).

```ruby
APP_STYLESHEETS = {
  "application.scss" => "application.css",
  "components/_component-1.scss" => "components/_component-1.css",
  "components/_component-2.scss" => "components/_component-2.css",
  "components/_component-3.scss" => "components/_component-3.css",
  "components/_component-4.scss" => "components/_component-4.css",
  "views/_view-1.scss" => "views/_view-1.css",
  "views/_view-2.scss" => "views/_view-2.css",
  "views/_view-3.scss" => "views/_view-3.css",
  "views/_view-4.scss" => "views/_view-4.css",
}
all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.all_stylesheets)
Rails.application.config.dartsass.builds = all_stylesheets
```

**Note**, if stylesheets are not individually loaded, there’s no need to add a `builds` initializer since [by default](https://github.com/rails/dartsass-rails#configuring-builds), `app/assets/stylesheets/application.scss` will be compiled.

### Delete unused Sass configuration

Delete Sass configuration previously added for `sassc-rails`.

```diff
- config.sass.style = :compressed
- config.sass.line_comments = false
  ...
```

## Builds

`dartsass:build` is linked to `assets:precompile`. When `assets:precompile` is run, it triggers the compilation of Sass files, which are generated in the `/app/assets/builds` directory. They are then processed by Sprockets.

## Configuring build options

See [configuring build options](https://github.com/rails/dartsass-rails#configuring-build-options) and [Dart Sass Command-Line Interface](https://sass-lang.com/documentation/cli/dart-sass/)

## Watch mode

When you're developing your application, you can run Sass in watch mode, so stylesheets are continuously updated when Sass files are changed.

1. Add `bin/dev`

   ```ruby
   #!/usr/bin/env sh
   if ! gem list foreman -i --silent; then
     echo "Installing foreman..."
     gem install foreman
   fi
   exec foreman start -f Procfile.dev "$@"
   ```

2. Add (or update) `procfile.dev`

   ```ruby
   web: bin/rails server -p 3070
   css: bin/rails dartsass:watch
   ```

  **Note**, the port number should match the one previously specified, in `startup.sh` and or `docker-compose.yml`, for running your Rails server.

3. Update `startup.sh`

   ```diff
   if [[ $1 == "--live" ]] ; then
     GOVUK_APP_DOMAIN=www.gov.uk \
     GOVUK_WEBSITE_ROOT=https://www.gov.uk \
     GOVUK_PROXY_STATIC_ENABLED=true \
     PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://www.gov.uk/api} \
     PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-https://assets.publishing.service.gov.uk} \
     PLEK_SERVICE_SEARCH_API_URI=${PLEK_SERVICE_SEARCH_API_URI-https://www.gov.uk/api} \
   - bundle exec rails s -p 3070
   + ./bin/dev
   else
     ...
   ```

4. In Docker, update `docker-compose.yml`

   ```diff
     expose:
   -  - "3000"
   - command: bin/rails s --restart
   +  - "3070"
   + command: ./bin/dev
     ...
   ```

### Digests

To see the latest stylesheet changes when developing your application, if running Sass in watch mode, you'll have to turn off digests. Update `config/environments/development.rb` to add

```ruby
  config.assets.digest = false
```

See [3.2 Turning Digests Off - The Asset Pipeline — Ruby on Rails Guides](https://guides.rubyonrails.org/asset_pipeline.html#turning-digests-off).

## Troubleshooting

See [common issues](https://github.com/rails/dartsass-rails#troubleshooting).

### Other issues

#### Globs

Any form of pattern matching added for importing Sass files will not work. Sass files needs to be imported individually.

```diff
- @import "modules/*";
+ @import "modules/module-1";
+ @import "modules/module-2";
+ @import "modules/module-3";
+ @import "modules/module-4";
  ...
```

#### Asset helpers

Asset helpers no longer work in `dartsass-rails`. Replace occurrences of the `image-url` and `asset-url` helpers with the `url()` CSS function. See [asset_url helpers don't work - issue #18 - rails/dartsass-rails](https://github.com/rails/dartsass-rails/issues/18).

```diff
.my-image {
- background-image: image-url("path/to/my/image.svg");
+ background-image: url("path/to/my/image.svg");
  background-color: transparent;
  ...
}
```

#### Asset paths

If you are using [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend) in your application you might need to add [asset handlers](https://github.com/alphagov/govuk-frontend/blob/main/packages/govuk-frontend/src/govuk/settings/_assets.scss) to ensure fonts and images are correctly referenced. See [if you have your own folder structure](https://frontend.design-system.service.gov.uk/importing-css-assets-and-javascript/#if-you-have-your-own-folder-structure).

```scss
@function app-image-url($filename) {
  @return url("#{$filename}");
}

$govuk-image-url-function: "app-image-url";
```

## Pull requests

- [GOV.UK Publishing Components](https://github.com/alphagov/govuk_publishing_components/pull/3726)
- [Email Alert Frontend](https://github.com/alphagov/email-alert-frontend/pull/1655)
- [Static](https://github.com/alphagov/static/pull/3190)
