---
title: Taxonomy
parent: /manual.html
layout: manual_layout
section: Publishing
owner_slack: "#taxonomy"
review_by: 2017-09-01
---

# Taxonomy

GOV.UK's "single subject taxonomy" will describe all content on GOV.UK. It is being developed theme-by-theme, starting with education.

## 1. Editing taxonomy

The taxonomy is managed in [content-tagger][edit-taxonomy].

The topics in the taxonomy (we call them "taxons" in code) are persisted in the publishing-api as content items. For an example [see the "Education" taxon][education-taxon].

The link type `parent_taxons` is used to store the relationship between taxons. Link expansion makes sure that the taxons will have a `child_taxons` link type too.

## 2. Tagging

All pages can be tagged to the taxonomy, currently in [content-tagger][content-tagger] too.

Pages that belong to selected organisations (like those related to the education theme) can be tagged to the taxonomy in [Whitehall][whitehall].

The relationship between a page and a taxon is persisted in the publishing-api "links hash". For example, see the [taxons link in the content item for this guidance document][example-guidance].

## 3. Accessing the taxonomy

This is the content item for the top-level "Education" taxon:

[https://www.gov.uk/api/content/education][education-taxon]

It is visible on [gov.uk/education](https://www.gov.uk/education)

You can use this to find the structure of the taxonomy by following the `child_taxons` links.

## 4. Accessing tagged content

All content tagged to a particular taxon you fetch from the search API ([rummager][rummager]).

This works with a `content_id` rather than URL. To find all content tagged to the above mentioned ["Education taxon"][education-taxon]:

[https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0](https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0)

You can also access all content tagged to a taxon and the part of the taxonomy below it. The following will give you everything tagged to topics in the "Education" taxonomy:

[https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&fields=title,taxons,part_of_taxonomy_tree](https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&fields=title,taxons,part_of_taxonomy_tree)

You can see the number of documents in each topic by using `taxons` as a facet:

[https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&facet_taxons=1000&count=0](https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&facet_taxons=1000&count=0)

[education-taxon]: https://www.gov.uk/api/content/education
[example-guidance]: https://www-origin.integration.publishing.service.gov.uk/api/content/government/publications/managing-staff-employment-in-schools
[edit-taxonomy]: https://content-tagger.publishing.service.gov.uk/taxon
[content-tagger]: https://content-tagger.publishing.service.gov.uk/
[whitehall]: /apps/whitehall.html
[rummager]: /apps/rummager.html
