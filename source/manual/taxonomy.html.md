---
owner_slack: "#govuk-developers"
title: How the topic taxonomy works
parent: "/manual.html"
layout: manual_layout
section: Publishing
type: learn
last_reviewed_on: 2020-01-23
review_in: 6 months
related_applications: [content-tagger]
---

The Topic Taxonomy is a classification scheme for organising and
finding content on GOV.UK, based on its subject area.

Not to be confused with the Topics published through Collections
Publisher.

## Editing the Topic Taxonomy

The taxonomy is managed in [content-tagger][edit-taxonomy]. Users must
have the "GDS Editor" permission in content-tagger in order to see the
relevant pages.

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

The relationship between a page and a taxon is persisted in the
publishing-api "links hash". For example, see the [taxons link in the
content item for this guidance document][example-guidance].

## Accessing the taxonomy

The level one taxons are associated with the GOV.UK home page through
the `root_taxon` link type. The GOV.UK home page in turn has a
corresponding reverse link of link type `level one taxons`.

This is the content item for the GOV.UK home page with all level one
taxons listed.

[https://www.gov.uk/api/content/][homepage-taxon]

An example of a level one taxon is the "Education" taxon:

[https://www.gov.uk/api/content/education][education-taxon]

You can use this to find the structure of the taxonomy by following
the `child_taxons` links.


## Accessing tagged content

You can fetch content tagged to a particular taxon from the Search API
([search-api][search-api]).

This is used in some GOV.UK search pages.  For example https://www.gov.uk/search/news-and-communications
has a topic/subtopic facet that allows filtering.  In addition, search pages like
https://www.gov.uk/search/guidance-and-regulation?parent=%2Feducation%2Fschools-forums&topic=57c6ba08-a31a-4a7a-9cd6-3d571e91f1ab
(which are accessed from topic pages) are prefiltered by topic.

The filter works with a `content_id` rather than URL. To find all content
tagged to the above mentioned ["Education taxon"][education-taxon]:

[https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0](https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0)

By default search-api returns a handful of fields in a search result item.
You are able to override the default fields by naming which fields you want returned.
If a content item does not have one of the named fields provided,
it will be left out of the returned item.
[See full documentation here.][override-fields]


You can filter on multiple different field names if you wish to narrow
down what you are searching for. You are able to filter by one or many
field names and multiple values can be given for each field name.
To find all `speech` content tagged to ["Education taxon"][education-taxon]:

[https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&filter_content_store_document_type[]=speech&fields[]=title,description,link,content_store_document_type,format](https://www.gov.uk/api/search.json?filter_taxons[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&filter_content_store_document_type[]=speech&fields[]=title,description,link,content_store_document_type,format)

You can also access all content tagged to a taxon and the part of the
taxonomy below it. The following will give you everything tagged to
topics in the "Education" taxonomy:

[https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&fields=title,taxons,part_of_taxonomy_tree](https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree[]=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&fields=title,taxons,part_of_taxonomy_tree)

You can see the number of documents in each topic by using `taxons` as
a facet:

[https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&facet_taxons=1000&count=0](https://www.gov.uk/api/search.json?filter_part_of_taxonomy_tree=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&facet_taxons=1000&count=0)

## Visibility

Editors can use Whitehall to tag content to the taxonomy.

Individual branches can be hidden from Editors by clearing the
`visible_to_departmental_editors` flag on level one taxons in
Content Tagger.

Additionally taxons have a 'phase', which can be 'alpha', 'beta' or 'live'.
The phase of a taxon controls its visibility on the front end apps. This
allows us to publish the entire taxonomy while making those parts which are not
considered mature enough for production harder to find.

## Taxonomy Metrics

High level metrics regarding the taxonomy are recorded in Graphite,
and can be looked at through a Grafana [dashboard].

A [rake task][record-metrics] in Content Tagger is run through the [deploy
Jenkins][record-taxonomy-metrics] every 30 minutes to push metrics to
Graphite (via StatsD).

[homepage-taxon]: https://www.gov.uk/api/content/
[education-taxon]: https://www.gov.uk/api/content/education
[example-guidance]: https://www.gov.uk/api/content/government/publications/staffing-and-employment-advice-for-schools
[edit-taxonomy]: https://content-tagger.publishing.service.gov.uk/taxons
[content-tagger]: https://content-tagger.publishing.service.gov.uk/
[whitehall]: /apps/whitehall.html
[search-api]: /apps/search-api.html
[dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/topic_taxonomy.json
[record-taxonomy-metrics]: https://deploy.publishing.service.gov.uk/job/record-taxonomy-metrics/
[override-fields]: /apis/search/search-api.html#returning-specific-document-fields
[record-metrics]: https://github.com/alphagov/content-tagger/blob/master/lib/tasks/taxonomy_metrics.rake#L27
