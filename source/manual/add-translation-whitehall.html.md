---
owner_slack: "#govuk-developers"
title: Add support for a new translation in Whitehall
parent: "/manual.html"
layout: manual_layout
section: Publishing
last_reviewed_on: 2020-01-27
review_in: 9 months
---

Useful links: 
  - [List of ISO 639-1 codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
  - [Rails Translation Manager](https://github.com/alphagov/rails_translation_manager)
  - [Internationalisation guide](https://github.com/alphagov/whitehall/blob/master/docs/internationalisation_guide.md)

### 1. Update GOV.UK Content Schemas

[Example PR](https://github.com/alphagov/govuk-content-schemas/pull/906)


In [GOV.UK Content Schemas](https://github.com/alphagov/govuk-content-schemas):

1. Edit `formats/shared/definitions/locale.jsonnet` to include the new locale
2. Run `rake` to generate all the schemas

### 2. Update Content Store

[Example PR](https://github.com/alphagov/content-store/pull/580)

In [Content Store](https://github.com/alphagov/content-store):

* Add the locale key to `config/application.rb`

### 3. Update Publishing API

[Example PR](https://github.com/alphagov/publishing-api/pull/1524)

In [Publishing API](https://github.com/alphagov/publishing-api):

* Add the locale key to `config/application.rb`

### 4. Update Government Frontend

[Example PR](https://github.com/alphagov/government-frontend/pull/1382)

In [Government Frontend](https://github.com/alphagov/government-frontend):

1. Add the new locale to `config/application.rb` and `config/locales/en.yml`
2. Run `rake translation:regenerate` to regenerate all translations from the EN locale
3. Run `rake translation:import[locale,path]` to import a specific locale CSV to YAML within the app. You can also use `rake translation:import:all[directory]` to import all locales but there's no timeline for how frequently this is done, so you can expect many translation values to be missing in non EN locales.
4. In `config/locales/<new_locale>.yml` add the language translation under the `language_names` key

### 5. Update Whitehall

[Example PR](https://github.com/alphagov/whitehall/pull/4861)

In [Whitehall](https://github.com/alphagov/whitehall):

1. Add the new locale to `lib/whitehall.rb` and `config/locales/en.yml`
2. Run `rake translation:regenerate` to regenerate all translations from the EN locale
3. Run `rake translation:import[locale,path]` to import a specific locale CSV to YAML within the app. You can also use `rake translation:import:all[directory]` to import all locales but there's no timeline for how frequently this is done, so you can expect many translation values to be missing in non EN locales.
4. In `config/locales/<new_locale>.yml` add the language translation under the `language_names` key
