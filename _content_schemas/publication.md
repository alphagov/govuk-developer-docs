---
layout: content_schema
title:  Publication
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/publication/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>documents</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>national_applicability</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>england</strong> </td> <td></td></tr>
<tr><td><strong>northern_ireland</strong> </td> <td></td></tr>
<tr><td><strong>scotland</strong> </td> <td></td></tr>
<tr><td><strong>wales</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>previous_version</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>redirects</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>routes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>publication</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/publication/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>document_collections</strong> </td> <td></td></tr>
<tr><td><strong>ministers</strong> </td> <td></td></tr>
<tr><td><strong>related_statistical_data_sets</strong> </td> <td></td></tr>
<tr><td><strong>topical_events</strong> </td> <td></td></tr>
<tr><td><strong>world_locations</strong> </td> <td></td></tr>
<tr><td><strong>taxons</strong> </td> <td>Prototype-stage taxonomy label for this content item</td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td>Powers the /browse section of the site. These are known as sections in some legacy apps.</td></tr>
<tr><td><strong>topics</strong> </td> <td>Powers the /topic section of the site. These are known as specialist sectors in some legacy apps.</td></tr>
<tr><td><strong>organisations</strong> </td> <td>All organisations linked to this content item. This should include lead organisations.</td></tr>
<tr><td><strong>parent</strong> </td> <td>The parent content item.</td></tr>
<tr><td><strong>policies</strong> </td> <td>These are for collecting content related to a particular government policy.</td></tr>
<tr><td><strong>policy_areas</strong> </td> <td>A largely deprecated tag currently only used to power email alerts.</td></tr></table></td></tr>
<tr><td><strong>previous_version</strong> <code>string</code></td> <td></td></tr></table>

---

## Frontend schema

This is the schema for what you'll get back from the content-store.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/publication/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>documents</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>national_applicability</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>england</strong> </td> <td></td></tr>
<tr><td><strong>northern_ireland</strong> </td> <td></td></tr>
<tr><td><strong>scotland</strong> </td> <td></td></tr>
<tr><td><strong>wales</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>document_collections</strong> </td> <td></td></tr>
<tr><td><strong>ministers</strong> </td> <td></td></tr>
<tr><td><strong>related_statistical_data_sets</strong> </td> <td></td></tr>
<tr><td><strong>topical_events</strong> </td> <td></td></tr>
<tr><td><strong>world_locations</strong> </td> <td></td></tr>
<tr><td><strong>taxons</strong> </td> <td></td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>topics</strong> </td> <td></td></tr>
<tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>parent</strong> </td> <td></td></tr>
<tr><td><strong>policies</strong> </td> <td></td></tr>
<tr><td><strong>policy_areas</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>publication</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### political_publication.json
```json
{
  "base_path": "/government/publications/climate-change-agreements-target-unit-tu-data-publication-discussion-paper",
  "content_id": "5d8b4b15-7631-11e4-a3cb-005056011aef",
  "title": "Climate Change Agreements: Target Unit (TU) data publication discussion paper",
  "description": "A paper outlining the data the Climate Change Agreements team intend to publish to meet the Climate Change Agreement (Administration) Regulations.",
  "format": "publication",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-12-02T10:46:57.788Z",
  "public_updated_at": "2014-09-22T09:53:36.000+00:00",
  "details": {
    "body": "<div class=\"govspeak\"><p>Government’s aims for the new CCA Scheme are to increase transparency and reduce administration costs for both industry and Government. As such, the CCA (Administration) Regulations, which came into force on 1 October 2012, require government to publish a report setting out Target Unit (TU) energy efficiency improvements and emissions reductions for each biennial reporting period and whether the sector commitment has been achieved.</p>\n\n<p>Government consulted on data publication in the following publications:</p>\n\n<ul>\n  <li>Consultation on the simplification of the Climate Change Agreements Scheme (September 2011) </li>\n  <li>Climate Change Regulations 2012 and the Scheme Administration Charge: opportunity to comment (January 2012)</li>\n  <li>Climate Change Agreements: delivering simplification in the new Scheme (March 2012).</li>\n</ul>\n\n<p>Feedback to the consultations revealed concerns that the data published would disclose commercially sensitive or confidential information. To address these concerns, this document sets out the data we intend to require the Environment Agency, as Administrator, to publish and our rationale for this.</p>\n\n<p>Given the importance of ensuring that the final position meets government aims of ensuring the maximum possible transparency without being to the detriment of CCA participants, we welcome your comments on the proposal. Where you think that the data published would reveal commercially sensitive or confidential information, please can you provide specific worked examples and evidence. Please send your comments by 6pm on Friday 8th March 2013.</p>\n\n<p><a href=\"mailto:levy.agreements@decc.gsi.gov.uk\">Comments should be sent to levy.agreements@decc.gsi.gov.uk</a>.</p>\n\n<h2 id=\"government-response\">Government response</h2>\n\n<p>Published in September 2014, the government response summaries the comments received, the government’s analysis and conclusions and the next steps. The government has decided  that data set 4 (each TU’s actual emissions) and data set 2 (a statement of whether a TU has met its targets, or has purchased a buyout) will be published alongside sector level information.</p>\n</div>",
    "documents": [
      "<section class=\"attachment embedded\" id=\"attachment_717394\">\n<div class=\"attachment-thumb\">\n<a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/128774/Data_publication_opportunity_to_comment.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/128774/thumbnail_Data_publication_opportunity_to_comment.pdf.png\"></a>\n</div>\n<div class=\"attachment-details\">\n<h2 class=\"title\"><a aria-describedby=\"attachment-717394-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/128774/Data_publication_opportunity_to_comment.pdf\">Climate Change Agreements: Target Unit (TU) data publication discussion paper </a></h2>\n<p class=\"metadata\">\n<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">58KB</span>, <span class=\"page-length\">5 pages</span>\n</p>\n\n\n<div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-717394-accessibility-help\">\n<h2>This file may not be suitable for users of assistive technology.\n<a class=\"toggler\" href=\"#attachment-717394-accessibility-request\" data-controls=\"attachment-717394-accessibility-request\" data-expanded=\"false\" role=\"button\" aria-controls=\"attachment-717394-accessibility-request\" aria-expanded=\"false\">Request a different format.</a>\n</h2>\n<p id=\"attachment-717394-accessibility-request\" class=\"js-hidden\" aria-live=\"polite\" role=\"region\">\nIf you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:correspondence@decc.gsi.gov.uk?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Climate%20Change%20Agreements%3A%20Target%20Unit%20%28TU%29%20data%20publication%20discussion%20paper%20%0A%20%20Original%20format%3A%20pdf%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Climate%20Change%20Agreements%3A%20Target%20Unit%20%28TU%29%20data%20publication%20discussion%20paper%20%27%20in%20an%20alternative%20format\">correspondence@decc.gsi.gov.uk</a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n</p>\n</div>\n</div>\n</section>",
      "<section class=\"attachment embedded\" id=\"attachment_717439\">\n<div class=\"attachment-thumb\">\n<a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/356789/appendix_b_government_response_on_cca_data_publication.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/356789/thumbnail_appendix_b_government_response_on_cca_data_publication.pdf.png\"></a>\n</div>\n<div class=\"attachment-details\">\n<h2 class=\"title\"><a aria-describedby=\"attachment-717439-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/356789/appendix_b_government_response_on_cca_data_publication.pdf\">Government response</a></h2>\n<p class=\"metadata\">\n<span class=\"references\">\nRef: <span class=\"unique_reference\">14D/332</span>\n</span>\n<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">497KB</span>, <span class=\"page-length\">14 pages</span>\n</p>\n\n\n<div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-717439-accessibility-help\">\n<h2>This file may not be suitable for users of assistive technology.\n<a class=\"toggler\" href=\"#attachment-717439-accessibility-request\" data-controls=\"attachment-717439-accessibility-request\" data-expanded=\"false\" role=\"button\" aria-controls=\"attachment-717439-accessibility-request\" aria-expanded=\"false\">Request a different format.</a>\n</h2>\n<p id=\"attachment-717439-accessibility-request\" class=\"js-hidden\" aria-live=\"polite\" role=\"region\">\nIf you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:correspondence@decc.gsi.gov.uk?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Government%20response%0A%20%20Original%20format%3A%20pdf%0A%20%20Unique%20reference%3A%2014D%2F332%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Government%20response%27%20in%20an%20alternative%20format\">correspondence@decc.gsi.gov.uk</a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n</p>\n</div>\n</div>\n</section>"
    ],
    "first_public_at": "2013-02-21T00:00:00+00:00",
    "change_history": [
      {
        "public_timestamp": "2014-09-22T10:53:36+01:00",
        "note": "Government response published."
      },
      {
        "public_timestamp": "2013-02-21T00:00:00+00:00",
        "note": "First published."
      }
    ],
    "emphasised_organisations": ["d65d4203-01f5-4920-a3b1-f614bfd8e83e"],
    "tags": {
      "browse_pages": [],
      "policies": [],
      "topics": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": true
  },
  "links": {
    "organisations": [
      {
        "content_id": "d65d4203-01f5-4920-a3b1-f614bfd8e83e",
        "title": "Department of Energy & Climate Change",
        "base_path": "/government/organisations/department-of-energy-climate-change",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-of-energy-climate-change",
        "web_url": "https://www.gov.uk/government/organisations/department-of-energy-climate-change",
        "locale": "en",
        "analytics_identifier": "D11"
      }
    ],
    "document_collections": [
      {
        "content_id": "5eb67fbf-7631-11e4-a3cb-005056011aef",
        "title": "Climate Change Agreements guidance",
        "base_path": "/government/collections/climate-change-agreements-guidance",
        "api_url": "https://www.gov.uk/api/content/government/collections/climate-change-agreements-guidance",
        "web_url": "https://www.gov.uk/government/collections/climate-change-agreements-guidance",
        "locale": "en"
      }
    ],
    "policies": [
      {
        "content_id": "5d2b69f0-7631-11e4-a3cb-005056011aef",
        "title": "Climate change impact in developing countries",
        "base_path": "/government/policies/climate-change-impact-in-developing-countries",
        "api_url": "https://www.gov.uk/api/content/government/policies/climate-change-impact-in-developing-countries",
        "web_url": "https://www.gov.uk/government/policies/climate-change-impact-in-developing-countries",
        "locale": "en"
      }
    ]
  },
  "schema_name": "publication",
  "document_type": "policy_paper"
}

```

### publication.json
```json
{
  "base_path": "/government/publications/d17-9ly-veolia-es-uk-limited-environmental-permit-issued",
  "content_id": "223d5519-da25-4210-8fec-52d77a7d2af6",
  "title": "D17 9LY, Veolia ES (UK) Limited: environmental permit issued",
  "description": "View the permit issued for Leeming Biogas Facility, Leeming under the Industrial Emissions Directive.",
  "format": "publication",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-05-03T14:11:53.023Z",
  "public_updated_at": "2016-05-03T14:11:50.000+00:00",
  "details": {
    "body": "<div class=\"govspeak\"><p>The Environment Agency publish permits that they issue under the Industrial Emissions Directive (IED).</p>\n\n<p>This decision includes the permit &amp; decision document for:</p>\n\n<ul>\n<li>Operator name: Veolia ES (UK) Limited</li>\n<li>Installation name: Leeming Biogas Facility</li>\n<li>Permit number: EPR/MP3730RL/A001</li>\n</ul>\n</div>",
    "documents": [
      "<section class=\"attachment embedded\" id=\"attachment_1529484\">\n<div class=\"attachment-thumb\">\n<a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/520515/Permit.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/520515/thumbnail_Permit.pdf.png\"></a>\n</div>\n<div class=\"attachment-details\">\n<h2 class=\"title\"><a aria-describedby=\"attachment-1529484-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/520515/Permit.pdf\">Permit: Veolia ES (UK) Limited</a></h2>\n<p class=\"metadata\">\n<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">521KB</span>, <span class=\"page-length\">35 pages</span>\n</p>\n\n\n<div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-1529484-accessibility-help\">\n<h2>This file may not be suitable for users of assistive technology.\n<a class=\"toggler\" href=\"#attachment-1529484-accessibility-request\" data-controls=\"attachment-1529484-accessibility-request\" data-expanded=\"false\" role=\"button\" aria-controls=\"attachment-1529484-accessibility-request\" aria-expanded=\"false\">Request a different format.</a>\n</h2>\n<p id=\"attachment-1529484-accessibility-request\" class=\"js-hidden\" aria-live=\"polite\" role=\"region\">\nIf you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:enquiries@environment-agency.gov.uk?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Permit%3A%20Veolia%20ES%20%28UK%29%20Limited%0A%20%20Original%20format%3A%20pdf%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Permit%3A%20Veolia%20ES%20%28UK%29%20Limited%27%20in%20an%20alternative%20format\">enquiries@environment-agency.gov.uk</a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n</p>\n</div>\n</div>\n</section>",
      "<section class=\"attachment embedded\" id=\"attachment_1529485\">\n<div class=\"attachment-thumb\">\n<a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/520516/Decision_document.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/520516/thumbnail_Decision_document.pdf.png\"></a>\n</div>\n<div class=\"attachment-details\">\n<h2 class=\"title\"><a aria-describedby=\"attachment-1529485-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/520516/Decision_document.pdf\">Decision document: Veolia ES (UK) Limited</a></h2>\n<p class=\"metadata\">\n<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">126KB</span>, <span class=\"page-length\">17 pages</span>\n</p>\n\n\n<div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-1529485-accessibility-help\">\n<h2>This file may not be suitable for users of assistive technology.\n<a class=\"toggler\" href=\"#attachment-1529485-accessibility-request\" data-controls=\"attachment-1529485-accessibility-request\" data-expanded=\"false\" role=\"button\" aria-controls=\"attachment-1529485-accessibility-request\" aria-expanded=\"false\">Request a different format.</a>\n</h2>\n<p id=\"attachment-1529485-accessibility-request\" class=\"js-hidden\" aria-live=\"polite\" role=\"region\">\nIf you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:enquiries@environment-agency.gov.uk?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Decision%20document%3A%20Veolia%20ES%20%28UK%29%20Limited%0A%20%20Original%20format%3A%20pdf%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Decision%20document%3A%20Veolia%20ES%20%28UK%29%20Limited%27%20in%20an%20alternative%20format\">enquiries@environment-agency.gov.uk</a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n</p>\n</div>\n</div>\n</section>"
    ],
    "first_public_at": "2016-05-03T14:11:50.000+00:00",
    "tags": {
      "browse_pages": [],
      "policies": [],
      "topics": []
    },
    "government": {
      "title": "2015 Conservative government",
      "slug": "2015-conservative-government",
      "current": true
    },
    "political": false,
    "emphasised_organisations": ["16628142-57b2-4611-bc03-5912785acee3"]
  },
  "links": {
    "organisations": [
      {
        "content_id": "16628142-57b2-4611-bc03-5912785acee3",
        "title": "Environment Agency",
        "base_path": "/government/organisations/environment-agency",
        "api_url": "https://www.gov.uk/api/content/government/organisations/environment-agency",
        "web_url": "https://www.gov.uk/government/organisations/environment-agency",
        "locale": "en",
        "analytics_identifier": "EA199"
      }
    ],
    "ministers": [
      {
        "content_id": "852925f7-c0f1-11e4-8223-005056011aef",
        "title": "The Rt Hon Sir Eric Pickles MP",
        "base_path": "/government/people/eric-pickles",
        "api_url": "https://www.gov.uk/api/content/government/people/eric-pickles",
        "web_url": "https://www.gov.uk/government/people/eric-pickles",
        "locale": "en"
      }
    ],
    "topical_events": [
      {
        "content_id": "7dbb1a8b-2149-4aba-bd87-87bd929d3635",
        "title": "Anti-Corruption Summit: London 2016",
        "base_path": "/government/topical-events/anti-corruption-summit-london-2016",
        "api_url": "https://www.gov.uk/api/content/government/topical-events/anti-corruption-summit-london-2016",
        "web_url": "https://www.gov.uk/government/topical-events/anti-corruption-summit-london-2016",
        "locale": "en"
      }
    ]
  },
  "schema_name": "publication",
  "document_type": "notice"
}

```

### statistics_publication.json
```json
{
  "base_path": "/government/statistics/affordable-housing-supply-in-england-2011-to-2012",
  "content_id": "5c83187f-7631-11e4-a3cb-005056011aef",
  "title": "Affordable housing supply in England: 2011 to 2012",
  "description": "This release presents data on affordable housing supply in England.",
  "format": "publication",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-12-02T10:47:58.310Z",
  "public_updated_at": "2012-11-01T00:00:00.000+00:00",
  "details": {
    "body": "<div class=\"govspeak\"><p>The latest statistics on gross affordable housing supply in England were released on Thursday 1 November 2012.</p>\n\n<p>The key points were:</p>\n\n<ul>\n  <li>A total of 57,950 gross additional affordable homes were supplied in England in 2011-12. This is a decrease of 4% on the 60,430 (revised) affordable homes supplied in 2010-11.</li>\n  <li>37,540 new affordable homes were provided for social rent in 2011-12, a decrease of 3% on 2010-11. A further 930 new affordable homes were provided for affordable rent in 2011-12, the first year for which this scheme has run.</li>\n  <li>19,490 homes were provided through intermediate housing schemes, including shared ownership and shared equity, down by 10% on 2010-11.</li>\n  <li>There were 52,880 new build affordable homes provided in 2011-12, representing 91% of all affordable homes provided in 2011-12 compared to 88% of total supply in 2010-11. This was the highest percentage reported since before 1991-92.</li>\n  <li>In 2011-12, 88% of affordable homes were in receipt of funding through the Homes and Communities Agency (excluding homes delivered under Section 106 without grant), a reduction from 92% in 2010-11. Around 92% of these were new build homes.</li>\n</ul>\n\n<p>Please note: These statistics were assessed by the United Kingdom Statistics Authority in June 2011 (Report 117). We have addressed the requirements relating to these statistics to the satisfaction of the UK Statistics Authority and they are now accredited as National Statistics.</p>\n</div>",
    "documents": [
      "<section class=\"attachment embedded\" id=\"attachment_23432\">\n<div class=\"attachment-thumb\">\n<a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/14664/2247515.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/14664/thumbnail_2247515.pdf.png\"></a>\n</div>\n<div class=\"attachment-details\">\n<h2 class=\"title\"><a aria-describedby=\"attachment-23432-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/14664/2247515.pdf\">Affordable Housing Supply, England, 2011-2012</a></h2>\n<p class=\"metadata\">\n<span class=\"references\">\nRef: ISBN <span class=\"isbn\">9781409836872</span>\n</span>\n<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">340KB</span>, <span class=\"page-length\">17 pages</span>\n</p>\n\n\n<div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-23432-accessibility-help\">\n<h2>This file may not be suitable for users of assistive technology.\n<a class=\"toggler\" href=\"#attachment-23432-accessibility-request\" data-controls=\"attachment-23432-accessibility-request\" data-expanded=\"false\" role=\"button\" aria-controls=\"attachment-23432-accessibility-request\" aria-expanded=\"false\">Request a different format.</a>\n</h2>\n<p id=\"attachment-23432-accessibility-request\" class=\"js-hidden\" aria-live=\"polite\" role=\"region\">\nIf you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:alternativeformats@communities.gsi.gov.uk?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Affordable%20Housing%20Supply%2C%20England%2C%202011-2012%0A%20%20Original%20format%3A%20pdf%0A%20%20ISBN%3A%209781409836872%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Affordable%20Housing%20Supply%2C%20England%2C%202011-2012%27%20in%20an%20alternative%20format\">alternativeformats@communities.gsi.gov.uk</a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n</p>\n</div>\n</div>\n</section>"
    ],
    "first_public_at": "2012-11-01T00:00:00.000+00:00",
    "tags": {
      "browse_pages": [],
      "policies": [],
      "topics": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": false,
    "emphasised_organisations": ["2e7868a8-38f5-4ff6-b62f-9a15d1c22d28"],
    "national_applicability": {
      "england": {
        "label": "England",
        "applicable": true
      },
      "northern_ireland": {
        "label": "Northern Ireland",
        "applicable": false,
        "alternative_url": "http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm"
      },
      "scotland": {
        "label": "Scotland",
        "applicable": false,
        "alternative_url": "http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS"
      },
      "wales": {
        "label": "Wales",
        "applicable": false,
        "alternative_url": "http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en"
      }
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "2e7868a8-38f5-4ff6-b62f-9a15d1c22d28",
        "title": "Department for Communities and Local Government",
        "base_path": "/government/organisations/department-for-communities-and-local-government",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-communities-and-local-government",
        "web_url": "https://www.gov.uk/government/organisations/department-for-communities-and-local-government",
        "locale": "en",
        "analytics_identifier": "D4"
      }
    ],
    "document_collections": [
      {
        "content_id": "5eb622a8-7631-11e4-a3cb-005056011aef",
        "title": "Affordable housing supply",
        "base_path": "/government/collections/affordable-housing-supply",
        "api_url": "https://www.gov.uk/api/content/government/collections/affordable-housing-supply",
        "web_url": "https://www.gov.uk/government/collections/affordable-housing-supply",
        "locale": "en"
      }
    ],
    "related_statistical_data_sets": [
      {
        "content_id": "5c81d7b6-7631-11e4-a3cb-005056011aef",
        "title": "Live tables on affordable housing supply",
        "base_path": "/government/statistical-data-sets/live-tables-on-affordable-housing-supply",
        "api_url": "https://www.gov.uk/api/content/government/statistical-data-sets/live-tables-on-affordable-housing-supply",
        "web_url": "https://www.gov.uk/government/statistical-data-sets/live-tables-on-affordable-housing-supply",
        "locale": "en"
      }
    ]
  },
  "schema_name": "publication",
  "document_type": "national_statistics"
}

```

### withdrawn_publication.json
```json
{
  "base_path": "/government/publications/a-guide-for-pig-keepers",
  "content_id": "5d3866dd-7631-11e4-a3cb-005056011aef",
  "title": "A guide for pig keepers",
  "description": "Guidance for pig keepers on registering, identifying and moving your pigs.",
  "format": "publication",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-12-02T10:43:02.887Z",
  "public_updated_at": "2013-09-06T09:11:28.000+00:00",
  "withdrawn_notice": {
    "explanation": "<div class=\"govspeak\"><p>This information is now out of date. For our current guidance please read <a href=\"https://www.gov.uk/government/collections/guidance-for-keepers-of-sheep-goats-and-pigs\">guidance for keepers of sheep, goats and pigs</a>.</p></div>",
    "withdrawn_at": "2015-01-13T13:05:30Z"
  },
  "details": {
    "body": "<div class=\"govspeak\"><p>This guide provides information for pig keepers on registering, identifying and moving your pigs.</p>\n\n<p>Whether you keep one pet pig or a commercial herd you must by law be registered as a pig keeper with the <a rel=\"external\" href=\"http://www.defra.gov.uk/ahvla-en/\">Animal Health and Veterinary Laboratories Agency (<abbr title=\"Animal Health and Veterinary Laboratories Agency\">AHVLA</abbr>)</a>. </p>\n\n<p>In the event of a disease outbreak, knowing the precise location of all livestock is essential for effective measures to control and eradicate disease. You place both your own and other livestock in the area at risk if you do not register your holding or <a href=\"http://www.dev.gov.uk/guidance/disease-notification-duties-of-farmers\">report notifiable diseases</a>.</p>\n\n<h2 id=\"further-information\">Further information</h2>\n\n<ul>\n  <li><a href=\"http://www.dev.gov.uk/guidance/pigs-identification-registration-and-movement\">Pigs: identification, registration and movement</a></li>\n</ul>\n\n</div>",
    "documents": [
      "<section class=\"attachment embedded\" id=\"attachment_871896\">\n<div class=\"attachment-thumb\">\n<a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/394915/pb13647-new-pig-keepers-guide.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/394915/thumbnail_pb13647-new-pig-keepers-guide.pdf.png\"></a>\n</div>\n<div class=\"attachment-details\">\n<h2 class=\"title\"><a aria-describedby=\"attachment-871896-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/394915/pb13647-new-pig-keepers-guide.pdf\">A guide for pig keepers</a></h2>\n<p class=\"metadata\">\n<span class=\"references\">\nRef: <span class=\"unique_reference\">PB13985</span>\n</span>\n<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">1.15MB</span>, <span class=\"page-length\">21 pages</span>\n</p>\n\n\n<div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-871896-accessibility-help\">\n<h2>This file may not be suitable for users of assistive technology.\n<a class=\"toggler\" href=\"#attachment-871896-accessibility-request\" data-controls=\"attachment-871896-accessibility-request\" data-expanded=\"false\" role=\"button\" aria-controls=\"attachment-871896-accessibility-request\" aria-expanded=\"false\">Request a different format.</a>\n</h2>\n<p id=\"attachment-871896-accessibility-request\" class=\"js-hidden\" aria-live=\"polite\" role=\"region\">\nIf you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:defra.helpline@defra.gsi.gov.uk?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20A%20guide%20for%20pig%20keepers%0A%20%20Original%20format%3A%20pdf%0A%20%20Unique%20reference%3A%20PB13985%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27A%20guide%20for%20pig%20keepers%27%20in%20an%20alternative%20format\">defra.helpline@defra.gsi.gov.uk</a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n</p>\n</div>\n</div>\n</section>"
    ],
    "first_public_at": "2011-09-29T01:00:00+01:00",
    "change_history": [
      {
        "public_timestamp": "2013-09-06T10:11:28+01:00",
        "note": "Published updated pig keepers guide."
      },
      {
        "public_timestamp": "2011-09-29T01:00:00+01:00",
        "note": "First published."
      }
    ],
    "tags": {
      "browse_pages": [],
      "policies": [],
      "topics": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": false,
    "emphasised_organisations": ["de4e9dc6-cca4-43af-a594-682023b84d6c"],
    "withdrawn_notice": {
      "explanation": "<div class=\"govspeak\"><p>This information is now out of date. For our current guidance please read <a href=\"https://www.gov.uk/government/collections/guidance-for-keepers-of-sheep-goats-and-pigs\">guidance for keepers of sheep, goats and pigs</a>.</p></div>",
      "withdrawn_at": "2015-01-13T13:05:30Z"
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "de4e9dc6-cca4-43af-a594-682023b84d6c",
        "title": "Department for Environment, Food & Rural Affairs",
        "base_path": "/government/organisations/department-for-environment-food-rural-affairs",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-environment-food-rural-affairs",
        "web_url": "https://www.gov.uk/government/organisations/department-for-environment-food-rural-affairs",
        "locale": "en",
        "analytics_identifier": "D7"
      }
    ]
  },
  "schema_name": "publication",
  "document_type": "guidance"
}

```



