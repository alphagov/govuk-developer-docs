---
owner_slack: "#govuk-searchandnav"
title: What data we expose as schema.org structured data
parent: "/manual.html"
layout: manual_layout
type: learn
section: Publishing
---

[Schema.org](https://schema.org/) is a community driven vocabulary (founded by Google, Microsoft et al) that allows us to add structured data to content.

Search engines such as Google and Bing use some schemas in order to process and [present results](https://developers.google.com/search/docs/data-types/article) [in different ways](https://www.bing.com/webmaster/help/marking-up-your-site-with-structured-data-3a93e731). It's also possible for other consumers such as [Google Assistant to use these](https://developers.google.com/assistant/content/faq), so it's about more than just conventional SEO.

We've implemented a few of these schemas on GOV.UK and have quite a bit of scope for going further.

## Testing tools

You can inspect the structured data on a page by using the following tools:

- [Google's structured data testing tool](https://search.google.com/structured-data/testing-tool/u/0/)
- [Google's rich result testing tool](https://search.google.com/test/rich-results)
- [Bing's markup validator](https://www.bing.com/toolbox/markup-validator)

The structured data testing tool is linked to from the [GOV.UK browser extension](https://github.com/alphagov/govuk-browser-extension/pull/133) to help exploration of our implementations.

The rich result testing tool is occasionally stricter in its requirements than the others because it checks that markup has everything required for Google to present a specially formatted result.

## Schemas

We implement most of our schemas as part of [the machine readable metadata component](https://components.publishing.service.gov.uk/component-guide/machine_readable_metadata) [in GOV.UK publishing components](https://github.com/alphagov/govuk_publishing_components/blob/master/lib/govuk_publishing_components/presenters/schema_org.rb).  This allows us to create a template and share it across all the frontend applications.

Some other schemas are implemented directly in frontend apps. This is usually when:

- the schema is specialised to a particular GOV.UK content type
- or we're starting to explore a new schema, and iterating using the gem is unnecessary overhead

It is possible to nest schemas within one another. In practice, we don't often do this (preferring links to other content), but we may want to explore de-normalising things in future.

### Article

[The Article schema](https://schema.org/Article) was the first to be implemented on GOV.UK.  We tend to use it as a fallback when there isn't a more specialised schema.

Google indicates that [Article pages may be displayed as a rich result](https://developers.google.com/search/docs/data-types/article) or in a carousel. In practice, I don't think we've seen much difference over standard results for this.  This is possibly because we only supply default images (such as the GOV.UK logo) with the default schema.

### Breadcrumb

This is implemented within [the Breadcrumb component](https://github.com/alphagov/govuk_publishing_components/blob/c0a1add0a222ab105a08133967f0d362e86b5604/app/views/govuk_publishing_components/components/_breadcrumbs.html.erb#L11). This is often shown in Google results, indicating the hierarchy of the site structure leading to the page.

### Dataset

[The Dataset schema](https://schema.org/Dataset) is implemented on [transparency](https://www.gov.uk/government/publications/latest-figures-show-millions-benefitting-from-treasury-coronavirus-support-schemes), [statistical data set](https://www.gov.uk/government/statistical-data-sets/unclaimed-estates-list), and [statistics](https://www.gov.uk/government/statistics/labour-market-in-the-regions-of-the-uk-may-2020) pages to expose a list of attachments.  This is shown in the [Google Dataset Search](https://datasetsearch.research.google.com/search?query=site%3Awww.gov.uk).

### FAQPage

[The FAQPage schema](https://schema.org/FAQPage) is implemented on [guides](https://www.gov.uk/universal-credit), [answers](https://www.gov.uk/benefits-calculators) and [a transaction](https://www.gov.uk/register-to-vote).

They are intended for use on [FAQ pages (which we famously don't have)](https://gds.blog.gov.uk/2013/07/25/faqs-why-we-dont-have-them/), where there are a set of questions and answers. They are equally good (luckily for us) when used with titles and body markup, because Google can match the intent of the query with the body of the page without the need for actual questions.

Google presents these results in a special concertinaed treatment (see the GOV.UK answers for [how to vote](https://www.google.com/search?q=how+to+vote)).

This is still quite new, and we've only user-tested it once.  We found that people understood the difference between the FAQPage answer and the "People also ask" section on Google results. They tended to use the result as a signpost, or for orientation rather than expecting the answer to contain all the information.

[Google also makes FAQPage content available as answers in Google assistant](https://developers.google.com/assistant/content/faq)

We have a few different implementations of this right now, because it's very new and we wanted to be able to explore its use in different document types.  They are:

- [The schema used on answers in GOV.UK publishing components](https://github.com/alphagov/govuk_publishing_components/blob/master/lib/govuk_publishing_components/presenters/machine_readable/faq_page_schema.rb)
- [The schema used on most guides in Government Frontend](https://github.com/alphagov/government-frontend/blob/master/app/presenters/machine_readable/guide_faq_page_schema_presenter.rb)
- [The schema used on "how to vote" also in Government Frontend](https://github.com/alphagov/government-frontend/blob/master/app/presenters/machine_readable/yaml_faq_page_schema_presenter.rb)
- [The schema used for transactions in Frontend](https://github.com/alphagov/frontend/blob/master/app/presenters/machine_readable/transaction_faq_page_schema.rb)

We may consolidate these at some point!

### GovernmentOrganization

We use [the GovernmentOrganization schema](https://schema.org/GovernmentOrganization) on [organisation pages](https://www.gov.uk/government/organisations/government-digital-service).

GOV.UK is the source of info on UK government organisations (we have an API which is used to power the register).

### HowTo

[The HowTo schema](https://schema.org/HowTo) is used on step by step pages. We use this particularly because it can result in a rich result on mobile [displaying each step with a thumbnail image](https://search.google.com/test/rich-results?utm_campaign=devsite&utm_medium=jsonld&utm_source=how-to&id=5DXkD7BHHFDFj-QuPvlQvQ&view=search-preview).

Pages using this schema appear in [the How-to "enhancements" section within the Google search console](https://search.google.com/search-console/how-to?resource_id=https%3A%2F%2Fwww.gov.uk%2F) which allows us to track whether errors have cropped up in the schema on specific pages.  This is useful because it means we don't have to manually check all the pages when we tweak things.

[Google's requirements for pages that implement the HowTo schema](https://developers.google.com/search/docs/data-types/how-to).

You should always use the [rich results testing tool](https://search.google.com/test/rich-results) to check changes to this schema.

[The Howto schema's implemented in Collections](https://github.com/alphagov/collections/blob/master/app/models/schemas/how_to.rb)

### NewsArticle

[The NewsArticle schema](https://schema.org/NewsArticle) is implemented (surprise surprise) on [news articles](https://github.com/alphagov/government-frontend/blob/11dfc12b47ede18897be28350db31ca23743c46c/app/views/content_items/news_article.html.erb#L3).

This seems more effective in generating rich results than Article, probably because GOV.UK news articles tend to have relevant images associated with them.
