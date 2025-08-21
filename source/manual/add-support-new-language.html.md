---
owner_slack: "#govuk-developers"
title: Add support for a new language on GOV.UK
parent: "/manual.html"
layout: manual_layout
section: Publishing
---

To add support for a new language on GOV.UK, two things are required before any development work can begin.

1. The correct language tag must be provided
2. Translated locale files must be provided

### Language tag

The language tag should be compatible with the [IETF Language Tag syntax][] and use correct [ISO 639][] codes (with optional [ISO 15924][] or [ISO 3166][] subtags where appropriate). This is important to ensure maximum compatibility with accessibility features such as screen readers. Some other useful reading includes [Rails Translation Manager][] and [Whitehall Internationalisation guide][].

[IETF Language Tag syntax]: https://en.wikipedia.org/wiki/IETF_language_tag#Syntax_of_language_tags
[ISO 639]: https://en.wikipedia.org/wiki/ISO_639-1
[ISO 15924]: https://en.wikipedia.org/wiki/ISO_15924
[ISO 3166]: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
[Rails Translation Manager]: https://github.com/alphagov/rails_translation_manager
[Whitehall Internationalisation guide]: https://github.com/alphagov/whitehall/blob/main/docs/internationalisation_guide.md

### Obtaining translations for internationalised strings

At the time of writing, there are four codebases where we store internationalised strings. These are:

- [Frontend](/repos/frontend.html)
- [Government-frontend](/repos/government-frontend.html)
- [Govuk-publishing-components](/repos/govuk_publishing_components.html)
- [Govuk-app-config](/repos/govuk-app-config.html)

Developers must export a csv containing all internationalised strings from frontend, government-frontend and govuk-publishing-components to be sent to the translator. Documentation on how to do this is available in [Rails translation manager](/repos/rails_translation_manager/translating-locale-files.html).

Check if the new language is already supported by the Rails framework by looking for your language tag in the [rails locale folder][]. If it's not supported, translations will also be needed for govuk-app-config. The internationalised strings that Rails requires contain a lot of interpolation, which has proved challenging for translators to understand. There is a [template csv file][] that contains instructions for translators which can be used for the govuk-app-config translations.

[rails locale folder]: https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale
[govuk-app-config Readme]: https://github.com/alphagov/govuk_app_config?tab=readme-ov-file#internationalisation
[template csv file]: https://docs.google.com/spreadsheets/d/12lhWVXz30l3c8WTakK_EIxJLUBoLJO80lekvq-treww/edit?usp=sharing

Once translations have been obtained from the translators, publishing and rendering applications can be updated via the following steps:

> Do not complete steps 3, 4 and 5 before steps 1 and 2 have been completed. This can cause failures in our CI/CD when the frontend rendering applications are asked to render content for all the locales publishable by whitehall.

### 1. Add support for your new language to the frontend rendering applications

At the time of writing, Whitehall content is rendered by either Frontend or Government Frontend. So both applications must be updated.

[Example PR in government](https://github.com/alphagov/government-frontend/pull/1382)

1. Add the new language tag to `config/application.rb` and `config/locales/en.yml` in alphabetical order
2. From within frontend, or government frontend, create a folder `tmp/locale_file`
3. Add your csv from the translator to this folder. The name of the csv should be in the format: `<new_locale>.csv`, eg `ky.csv`
4. Run the following commands to import your csv, and create a new locale file.

    ```bash
    $ rake translation:import:all
    ```

3. In `config/locales/<new_locale>.yml` add the language translation under the `language_names` key.

    For example:

     ```yaml
     it:
       language_names:
         it: italiano
     ```

### 2. Add support for your new language to govuk-publishing-components

Follow steps 2, 3 and 4 from the [previous section](#1-add-support-for-your-new-language-to-the-frontend-rendering-applications) from within the govuk-publishing-components repo.

### 3. Add support for your new language to govspeak

Add a new locale file to [the `locales` directory](https://github.com/alphagov/govspeak/tree/main/locales) containing translations for this language. Use the `en.yml` file as a template for obtaining the keys.

After making this change, [release a new version the gem](/manual/publishing-a-ruby-gem.html#releasing-gem-versions) then update Whitehall and Publishing API to use the new version of the gem.

### 4. Update Whitehall

[Example PR](https://github.com/alphagov/whitehall/pull/9856)

You will need the language's:

- English name (e.g. Welsh)
- Native name (e.g. Cymraeg)
- Text direction (ltr or rtl)

### 5. Update Publishing API

[Example PR](https://github.com/alphagov/publishing-api/pull/3104)

1. Edit `content_schemas/formats/shared/definitions/locale.jsonnet` and `config/application.rb` in alphabetical order
2. Run `rake build_schemas` to generate all the schemas

### 6. Update Content Store

[Example PR](https://github.com/alphagov/content-store/pull/1383)

- Add the locale key to `config/application.rb` in alphabetical order

### 7. Get the guidance updated

Inform the [#govuk-guidance](https://gds.slack.com/archives/CKPMRB8UB) Slack channel that support for a new language has been added, so that they can update the relevant guidance.
