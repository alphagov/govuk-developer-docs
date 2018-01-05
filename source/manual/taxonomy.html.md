---
title: Topic Taxonomy
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "#taxonomy"
last_reviewed_on: 2017-11-27
review_in: 3 months
related_applications: [content-tagger]
---

The Topic Taxonomy is a classification scheme for organising and
finding content on GOV.UK, based on its subject area.

Not to be confused with the Topics published throught Collections
Publisher.

## Editing the Topic Taxonomy

The taxonomy is managed in [content-tagger][edit-taxonomy]. Users must
have the "GDS Editor" permission in content-tagger in order to see the
relevent pages.

The topics in the taxonomy (we call them "taxons" in code) are
persisted in the publishing-api as content items. For an example [see
the "Education" taxon][education-taxon].

This means that taxons inherit the publishing-api workflow, and can be
in either draft state or published.

The link type `parent_taxons` is used to store the relationship
between taxons. A [reverse link][reverse-link-config] called
`child_taxons` is setup through the publishing-api.

[reverse-link-config]: https://github.com/alphagov/publishing-api/blob/master/lib/expansion_rules.rb#L29

## Tagging

There is no technical limit in what can be tagged to the taxonomy, but
not every type of content in the publishing-api is suitable for
tagging to the taxonomy.

Content Tagger has a generic interface for tagging content to the
taxonomy.

Pages that belong to selected organisations (like those related to the
education theme) can be tagged to the taxonomy in
[Whitehall][whitehall].

The relationship between a page and a taxon is persisted in the
publishing-api "links hash". For example, see the [taxons link in the
content item for this guidance document][example-guidance].

## Accessing the taxonomy

The top level taxons are associated with the GOV.UK home page through
the `root_taxons` link type.

This is the content item for the top-level "Education" taxon:

[https://www.gov.uk/api/content/education][education-taxon]

You can use this to find the structure of the taxonomy by following
the `child_taxons` links.

## Accessing tagged content

You can fetch content tagged to a particular taxon from the Search API
([rummager][rummager]).

This works with a `content_id` rather than URL. To find all content
tagged to the above mentioned ["Education taxon"][education-taxon]:

[https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0](https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0)

You can also access all content tagged to a taxon and the part of the
taxonomy below it. The following will give you everything tagged to
topics in the "Education" taxonomy:

[https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&fields=title,taxons,part_of_taxonomy_tree](https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&fields=title,taxons,part_of_taxonomy_tree)

You can see the number of documents in each topic by using `taxons` as
a facet:

[https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&facet_taxons=1000&count=0](https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&facet_taxons=1000&count=0)

[education-taxon]: https://www.gov.uk/api/content/education
[example-guidance]: https://www-origin.integration.publishing.service.gov.uk/api/content/government/publications/staffing-and-employment-advice-for-schools
[edit-taxonomy]: https://content-tagger.publishing.service.gov.uk/taxon
[content-tagger]: https://content-tagger.publishing.service.gov.uk/
[whitehall]: /apps/whitehall.html
[rummager]: /apps/rummager.html
