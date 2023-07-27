---
owner_slack: "#govuk-developers"
title: Add an organisation's brand colour
section: Publishing
layout: manual_layout
parent: "/manual.html"
related_repos: [whitehall, government-frontend]
---

An organisation's brand colour is used to style their organisation page (such as dividing lines, icons and link text). For example see the [DCMS organisation page](https://www.gov.uk/government/organisations/department-for-digital-culture-media-sport).

The colour is set as an option under a drop down field called "brand colour" when creating or editing an [organisation page in Whitehall Publisher](https://whitehall-admin.publishing.service.gov.uk/government/admin/organisations).

[Documentation in govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components/blob/main/docs/component_branding.md) explains how brand colours work in the code, for reference.

## 1. Check the colour passes WCAG contrast requirements

If an organisation's brand colour changes or a new one is required, check that it is of a high enough contrast against a white background to be accessible. Use a tool such as the [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) to determine this.

## 2. Add the brand colour in govuk_publishing_components

If the brand colour is required urgently, follow this step to temporarily add it directly to `govuk_publishing_components`. Otherwise, skip to step 3.

Add styles to `_brand-colours.scss` as shown in this example for [10 Downing Street](https://github.com/alphagov/govuk_publishing_components/blob/cefed3993d91f375a9990d703d49b41277acb189/app/assets/stylesheets/govuk_publishing_components/components/helpers/_brand-colours.scss#L58-L78). Copy and paste these lines and modify the organisation CSS class name and colour as required.

You will then need to ready a [new release of the components gem](https://github.com/alphagov/govuk_publishing_components/blob/main/docs/publishing-to-rubygems.md) for deployment.

## 3. Add the brand colour in GOV.UK Frontend

Set up a fork of `govuk-frontend`, then add the colour to the [_colours-organisations.scss file](https://github.com/alphagov/govuk-frontend/blob/main/src/govuk/settings/_colours-organisations.scss) and update the [CHANGELOG](https://github.com/alphagov/govuk-frontend/blob/main/CHANGELOG.md).
See [updating changelog](https://github.com/alphagov/govuk-frontend/blob/main/docs/contributing/versioning.md#updating-changelog) and [example PR](https://github.com/alphagov/govuk-frontend/pull/1918) for more details.

Note that it may be some time before a new version of `govuk-frontend` is released.

## 4. Add the organisation as brand colour option in Whitehall

Add a new entry for the organisation in [app/models/organisation_brand_colour.rb](https://github.com/alphagov/whitehall/blob/main/app/models/organisation_brand_colour.rb), which will show the organisation as an option under the [brand colour drop down field](https://github.com/alphagov/whitehall/blob/52aff8f61a29b3999054b5b5c94875a5534eaf9a/app/views/admin/organisations/_form.html.erb#L25) in Whitehall. The CSS class name should match the name used earlier.

## 5. Testing your changes

If you have modified `govuk_publishing_components`:

1. Run `collections` with your local version of `govuk_publishing_components` (see [Local frontend development](/manual/local-frontend-development.html) if you need help).
2. Go to an organisation page and use Chrome's developer tools to change the brand class of an element to match, check that the required colour is applied.
3. Create a new release of `govuk_publishing_components` and get a branch of `collections` including this deployed to integration.

If you have modified `govuk-frontend`:

1. Check and approve the dependabot PR in `govuk_publishing_components` for the new version of `govuk-frontend`.
2. Include a commit to remove any styles added in section 2 of this guide.
3. Create a new release of `govuk_publishing_components` and get a branch of `collections` including this deployed to integration.

Then:

1. In integration `whitehall`, you should see the organisation as an option under the `brand colour` field (you will also need to update the `Status on GOV.UK` to `currently live` to view the page).
2. Check the relevant organisation page has the new colour.

> **Note**
>
> It may take some time for the colour to update on the page in `integration`.
> You might be able to speed up the process by running the
> `publishing_api:republish_organisation[slug]` rake task in Whitehall.
