---
layout: content_schema
title:  Fatality notice
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/fatality_notice/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>fatality_notice</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/fatality_notice/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>field_of_operation</strong> </td> <td></td></tr>
<tr><td><strong>ministers</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/fatality_notice/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>field_of_operation</strong> </td> <td></td></tr>
<tr><td><strong>ministers</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>fatality_notice</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### fatality_notice.json
```json
{
  "base_path": "/government/fatalities/sir-george-pomeroy-colley-killed-in-boer-war",
  "content_id": "8537348f-c0f1-11e4-8234-005056011aef",
  "title": "Sir George Pomeroy Colley killed in Boer War",
  "description": "It is with great sadness that the Ministry of Defense must confirm that Sir George Pomeroy Colley, died in battle in Zululand on 27 February 1881.",
  "format": "fatality_notice",
  "need_ids": [],
  "locale": "en",
  "updated_at": "1881-03-23T14:00:00.023Z",
  "public_updated_at": "1881-05-17T14:00:00.023Z",
  "details": {
    "body": "<div class=\"govspeak\">\n<h2 id=\"sir-george-pomeroy-colley\">Sir George Pomeroy Colley</h2>\n<figure class=\"image embedded\">\n<div class=\"img\"><img alt=\"Photograph of Sir George Pomeroy Colley posed standing\" src=\"https://assets.digital.cabinet-office.gov.uk/media/573f2c49ed915d05fd000000/colley.jpg\"></div>\n<figcaption>Sir George Pomeroy Colley (All rights reserved.)</figcaption>\n</figure>\n<p>Colley served nearly all of his military and administrative career in British South Africa, but he played a significant part in the Second Anglo-Afghan War as military secretary and then private secretary to the governor-general of India, Lord Lytton. The war began in November 1878 and ended in May 1879 with the Treaty of Gandamak.</p>\n<p>After the war Colley returned to South Africa, became high commissioner for South Eastern Africa in 1880... and died a year later at the Battle of Majuba Hill during the First Boer War.</p>\n<p>A british officer had the following to say</p>\n<blockquote>\n  <p>Major General Colley was an exceptional talent, and it is with great sadness that we have learned about this loss. His contribution to Britain through his efforts in the Boer War will not be forgotten.</p>\n</blockquote>\n</div>",
    "first_public_at": "1881-03-23T14:00:00.023Z",
    "government": {
      "title": "1880 to 1885 Liberal government",
      "slug": "1880-to-1885-liberal-government",
      "current": false
    },
    "political": false,
    "emphasised_organisations": ["d994e55c-48c9-4795-b872-58d8ec98af12"],
    "change_history": [
      {
        "public_timestamp": "1881-05-17T14:00:00.023Z",
        "note": "Add comment from British officer"
      },
      {
        "public_timestamp": "1881-03-23T14:00:00.023Z",
        "note": "First published."
      }
    ]
  },
  "links": {
    "organisations": [
      {
        "content_id": "d994e55c-48c9-4795-b872-58d8ec98af12",
        "title": "Ministry of Defence",
        "base_path": "/government/organisations/ministry-of-defence",
        "api_url": "https://www.gov.uk/api/content/government/organisations/ministry-of-defence",
        "web_url": "https://www.gov.uk/government/organisations/ministry-of-defence",
        "locale": "en",
        "analytics_identifier": "D17"
      }
    ],
    "ministers": [
      {
        "content_id": "8537348f-c0f1-11e4-8223-005056011aef",
        "title": "William Ewart Gladstone",
        "base_path": "/government/people/william-ewart-gladstone",
        "api_url": "https://www.gov.uk/api/content/government/people/william-ewart-gladstone",
        "web_url": "https://www.gov.uk/government/people/william-ewart-gladstone",
        "locale": "en"
      }
    ],
    "field_of_operation": [
      {
        "content_id": "8537348f-c0f1-11e4-9312-005056011aef",
        "title": "Zululand",
        "base_path": "/government/fields-of-operation/zululand",
        "api_url": "https://www.gov.uk/api/content/government/fields-of-operation/zululand",
        "web_url": "https://www.gov.uk/government/fields-of-operation/zululand",
        "locale": "en"
      }
    ]
  },
  "schema_name": "fatality_notice",
  "document_type": "notice"
}

```



