---
owner_slack: "#govuk-developers"
title: How the world taxonomy works
parent: "/manual.html"
layout: manual_layout
section: Publishing
type: learn
related_applications: [content-tagger]
---

GOV.UK aims to organise content with a single taxonomy, [the topic taxonomy][topic-taxonomy], however due to legacy reasons there is a disassociated branch of this taxonomy known as the world taxonomy. The world taxonomy is used to tag guidance to particular world locations, for example [Latvia: doctors][latvia-doctors] is content tagged to the [Living in Latvia][live-latvia] section of the world taxonomy. The full list of world location pages can be seen on <https://www.gov.uk/world>.

For each world location in the world taxonomy there are a number of consistent child entities such as [Passports][passports-nz], [Trade and Invest][trade-lt], [Coming to the UK][coming-uk], etc. This varies for some place, for example [Syria][syria]. There are also generic versions of the world location child pages that aren't tailored to a specific location, for example [Passports][passports] and [Trade and Invest][trade].

You can view the hierarchy of the world taxonomy in [content-tagger][taxon-tree] (requires access to content tagger on integration).

[topic-taxonomy]: https://docs.publishing.service.gov.uk/manual/taxonomy.html
[latvia-doctors]: https://www.gov.uk/government/publications/latvia-list-of-medical-facilities
[live-latvia]: https://www.gov.uk/world/living-in-latvia
[passports-nz]: https://www.gov.uk/world/passports-and-emergency-travel-documents-new-zealand
[trade-lt]: https://www.gov.uk/world/trade-and-invest-lithuania
[coming-uk]: https://www.gov.uk/world/coming-to-the-uk-algeria
[syria]: https://www.gov.uk/world/syria
[trade]: https://www.gov.uk/world/trade-and-invest
[passports]: https://www.gov.uk/world/passports-and-emergency-travel-documents
[taxon-tree]: https://content-tagger.integration.publishing.service.gov.uk/taxons/91b8ef20-74e7-4552-880c-50e6d73c2ff9

## Differences between topic taxonomy and world taxonomy

Whilst world taxons are treated in the same way as the [topic taxonomy][topic-taxonomy] on a data level, they are a separate entity and do not share the same root. All taxons within the topic taxonomy are either level one taxons (which are represented in the [Content API of the GOV.UK homepage][content-api]) or descendants of those. World taxons however are outside of this structure and are descendants of the [/world/all content item][world-all].

The two taxonomies have different shapes. The topic taxonomy has 21 top level items and these can increase in specificity for up to 5 levels (for example: _Education, training and skills > School and academy funding > Initial Teacher Training funding > Subject Knowledge Enhancement (SKE) funding_). The world taxonomy has over 200 top level items and these only have a maximum one additional level of specificity (for example: _UK help and services in Afghanistan > Passports and emergency travel documents_)

GOV.UK has approximately 4000 published taxons, of those nearly 2500 are world taxons meaning that they represent a substantial majority of all taxons.

Unlike the topic taxonomy only content associated with [specific organisations][spec-orgs] is allowed to be tagged to world taxons and only [particular document types][specific-doc-types] may be tagged to them. This is because the world pages are intended to be curation mechanisms for the Foreign Commonwealth Office and organisations that have similar concerns, rather than content tagged to a topic.

World taxons are rendered differently on the frontend to topic taxons. Compare <https://www.gov.uk/education/running-and-managing-a-school> with <https://www.gov.uk/world/yemen>.

[topic-taxonomy]: https://docs.publishing.service.gov.uk/manual/taxonomy.html
[content-api]: https://www.gov.uk/api/content
[world-all]: https://www.gov.uk/api/content/world/all
[spec-orgs]: https://github.com/alphagov/whitehall/blob/56006c6f6ba033fbe450ef91d46204499e62e337/config/worldwide_tagging_organisations.yml
[specific-doc-types]: https://github.com/alphagov/whitehall/blob/8f1b71d7faa130547a3fca621542b6f9f865034b/app/models/edition/taggable_organisations.rb#L4-L9

## Problems with world taxonomy

The world taxonomy is not a well known part of GOV.UK and has a number of quirks that can make it problematic for developers working on GOV.UK. These quirks can produce a number of hard to diagnose problems.

Any application that either tags content to taxons or pulls taxons out of the Publishing API has to consider them. Tagging to taxons requires an application to consider whether they will be accidentally overwriting any tagging to the world taxonomy. Pulling taxons from the Publishing API requires determining whether each item is part of the topic taxonomy or the world taxonomy.

The rules regarding which departments and document types world taxons apply to are only enforced by Whitehall, not by content-tagger, meaning that these rules are not applied uniformly.

There is a [world location][world-location] format that was the predecessor to the world taxon pages. This is still used for a number of things ([atom feed][atom-feed], tagging in Whitehall, rendering the [world page][world-page]) therefore we have two similar coupled concepts that are needed to be kept in sync.

Content associated with a world location is tagged to the previous concept of a world location rather than a world taxon. For example [Information and events for UK nationals living in Portugal][portugal-info] has [no links][] to [Portugal][] and instead is linked to the now defunct Portugal world location. The consequence of this is that web links need to be [created based on the old world location concepts title][create-link] (which is a fragile process that needs manual overrides when it breaks) and that these content relationships cannot be mapped in data-science tooling without understanding this quirk.

World taxons are treated the same as topic taxons in content tagger, the only clue a user has that they are dealing with something different is the /world part of their path.

The structure of the world taxonomy is dense and repetitive. This results in a poor user experience for anyone tagging to it via Whitehall for example.

The [/world][] page is unconventional for GOV.UK as it is not represented by a content item and it is instead only represented in router while being [rendered by Whitehall][]. There is a content item at [/world/all][] which redirects to /world, however the data from this content item is not used to render /world.

[world-location]: https://github.com/alphagov/govuk-content-schemas/blob/0c6097e6afa6c7679b97aa4331b5d1fdd75fcdc3/formats/world_location.jsonnet
[atom-feed]: https://www.gov.uk/world/yemen.atom
[world-page]: https://www.gov.uk/world
[portugal-info]: https://www.gov.uk/government/news/information-and-events-for-uk-nationals-living-in-portugal
[no links]: https://www.gov.uk/api/content/government/news/information-and-events-for-uk-nationals-living-in-portugal
[Portugal]: https://www.gov.uk/world/portugal
[create-link]: https://github.com/alphagov/govuk_publishing_components/blob/5f72ddaf40948c0dbbc26438fb958fd5f693ee72/lib/govuk_publishing_components/presenters/related_navigation_helper.rb#L150-L156
[/world]: https://gov.uk/world
[rendered by Whitehall]: https://github.com/alphagov/whitehall/blob/79515433a97f799a5f78f3410f5d598004bd91f2/config/routes.rb#L56
[/world/all]: https://gov.uk/api/content/world/all

## History

The world taxonomy is a product of the work done by the [Worldwide Publishing][worldwide-publishing] team in Q1 2017. The work brought consistent information structure to the 229 countries represented on the world pages.

This project occurred around 2 years after work had begun on the GOV.UK taxonomy which was under active development at the time. It’s unclear whether the intention was for this to be a part of the single taxonomy or always intended to be separate.

[worldwide-publishing]: https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/131111686/Worldwide+Publishing

## Future

The future for the world taxonomy is unclear. It is considered an undesirable part of the GOV.UK stack due to its close coupling to the topic taxonomy yet with an information structure that does not lend itself to classification, thus not really a taxonomy. However there is not a drive towards separating it or clear decisions on what should replace it, which therefore means it may remain a part of GOV.UK for the foreseeable future.

## Editing the world taxonomy

Taxons within the world taxonomy can be edited via the same means as [editing topic taxons][edit-taxons].

[edit-taxons]: https://docs.publishing.service.gov.uk/manual/taxonomy.html#editing-the-topic-taxonomy
