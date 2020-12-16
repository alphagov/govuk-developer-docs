---
owner_slack: "#govuk-developers"
title: Add support for a new translation in Whitehall
parent: "/manual.html"
layout: manual_layout
section: Publishing
---

Useful links:

- [List of ISO 639-1 codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
- [Rails Translation Manager](https://github.com/alphagov/rails_translation_manager)
- [Internationalisation guide](https://github.com/alphagov/whitehall/blob/master/docs/internationalisation_guide.md)

### 1. Update Government Frontend

[Example PR](https://github.com/alphagov/government-frontend/pull/1382)

In [Government Frontend](https://github.com/alphagov/government-frontend):

1. Add the new locale to `config/application.rb` and `config/locales/en.yml` in alphabetical order
2. Run the following commands to generate the locale files from the English template:

    ```bash
    $ export LOCALE=<new_locale>
    $ rake "translation:export[tmp/locale_csv,en,${LOCALE}]"
    $ rake "translation:import[${LOCALE},tmp/locale_csv/${LOCALE}.csv]"
    ```

3. In `config/locales/<new_locale>.yml` add the language translation under the `language_names` key.

    For example:

     ```yaml
     it:
       language_names:
         it: italiano
     ```

### 2. Update Whitehall

[Example PR](https://github.com/alphagov/whitehall/pull/4861)

In [Whitehall](https://github.com/alphagov/whitehall):

1. Add the new locale to `lib/whitehall.rb` and `config/locales/en.yml` in alphabetical order
2. Run the following commands to generate the locale files from the English template:

    ```bash
    $ export LOCALE=<new_locale>
    $ rake "translation:export[tmp/locale_csv,en,${LOCALE}]"
    $ rake "translation:import[${LOCALE},tmp/locale_csv/${LOCALE}.csv]"
    ```

3. In `config/locales/<new_locale>.yml` add:
  - the language direction under the `i18n.direction` key
  - the appropriate boolean under the `i18n.latin_script?` key
  - the language translation under the `language_names` key

    For example:

     ```yaml
     it:
       i18n:
         direction: ltr
         latin_script?: true
       language_names:
         it: Italiano
     ```

### 3. Update GOV.UK Content Schemas

[Example PR](https://github.com/alphagov/govuk-content-schemas/pull/906)

In [GOV.UK Content Schemas](https://github.com/alphagov/govuk-content-schemas):

1. Edit `formats/shared/definitions/locale.jsonnet` to include the new locale in alphabetical order
2. Run `rake` to generate all the schemas

### 4. Update Content Store

[Example PR](https://github.com/alphagov/content-store/pull/580)

In [Content Store](https://github.com/alphagov/content-store):

- Add the locale key to `config/application.rb` in alphabetical order

### 5. Update Publishing API

[Example PR](https://github.com/alphagov/publishing-api/pull/1524)

In [Publishing API](https://github.com/alphagov/publishing-api):

- Add the locale key to `config/application.rb` in alphabetical order
