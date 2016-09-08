---
layout: content_schema
title:  Document collection
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/document_collection/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>collection_groups</strong> <code>array</code></td> <td>The ordered list of collection groups</td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>document_collection</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/document_collection/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>documents</strong> </td> <td>An unordered list of all documents in this collection</td></tr>
<tr><td><strong>topical_events</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/document_collection/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>collection_groups</strong> <code>array</code></td> <td>The ordered list of collection groups</td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>documents</strong> </td> <td></td></tr>
<tr><td><strong>topical_events</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>document_collection</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### document_collection.json
```json
{
  "content_id": "5eb731c7-7631-11e4-a3cb-005056011aef",
  "base_path": "/government/collections/national-driving-and-riding-standards",
  "description": "The standards set out what it takes to be a safe and responsible driver and rider and provide training to drivers and riders.",
  "public_updated_at": "2016-02-29T09:24:10.000+00:00",
  "title": "National standards for driving and riding",
  "updated_at": "2016-05-17T11:27:14.152Z",
  "schema_name": "document_collection",
  "document_type": "document_collection",
  "format": "document_collection",
  "locale": "en",
  "withdrawn_notice": {
    "explanation": "<div class=\"govspeak\"><p>This information is now out of date.</p></div>",
    "withdrawn_at": "2016-03-01T13:05:30Z"
  },
  "details": {
    "collection_groups": [
      {
        "title": "Car and light van",
        "body": "<div class=\"govspeak\">\n<p>The standard sets out what you must be able to do and what you must know and understand to be a safe and responsible car and light van driver. The syllabus sets out a way of teaching people that knowledge and those skills.</p>\n</div>",
        "documents": [
          "5e5dc1ab-7631-11e4-a3cb-005056011aef",
          "5e5dc201-7631-11e4-a3cb-005056011aef",
          "5e5dd324-7631-11e4-a3cb-005056011aef"
        ]
      },
      {
        "title": "Moped and motorcycle",
        "body": "<div class=\"govspeak\">\n<p>The standard sets out what you must be able to do and what you must know and understand to be a safe and responsible car and light van driver. The syllabus sets out a way of teaching people that knowledge and those skills.</p>\n</div>",
        "documents": [
          "5e5dc29b-7631-11e4-a3cb-005056011aef",
          "5e5ddbe8-7631-11e4-a3cb-005056011aef"
        ]
      },
      {
        "title": "Lorry",
        "body": "<div class=\"govspeak\">\n<p>The standard sets out what you must be able to do and what you must know and understand to be a safe and responsible lorry driver.</p>\n</div>",
        "documents": [
          "5e5ddb9c-7631-11e4-a3cb-005056011aef"
        ]
      },
      {
        "title": "Bus and coach",
        "body": "<div class=\"govspeak\">\n<p>The standard sets out what you must be able to do and what you must know and understand to be a safe and responsible bus and coach driver.</p>\n</div>",
        "documents": [
          "5e5ddaac-7631-11e4-a3cb-005056011aef"
        ]
      },
      {
        "title": "Driver and rider trainer",
        "body": "<div class=\"govspeak\">\n<p>The standard sets out what you must be able to do and what you must know and understand to provide training to drivers and riders.</p>\n</div>",
        "documents": [
          "5e5ddcc9-7631-11e4-a3cb-005056011aef"
        ]
      },
      {
        "title": "Developed driving competence",
        "body": "<div class=\"govspeak\">\n<p>The standard sets out what you must be able to do and what you must know and understand to show developed driving competence.</p>\n</div>",
        "documents": [
          "5e5dc159-7631-11e4-a3cb-005056011aef"
        ]
      }
    ],
    "first_public_at": "2016-02-29T09:24:10.000+00:00",
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": true,
    "emphasised_organisations": ["d39237a5-678b-4bb5-a372-eb2cb036933d"],
    "withdrawn_notice": {
      "explanation": "<div class=\"govspeak\"><p>This information is now out of date.</p></div>",
      "withdrawn_at": "2016-03-01T13:05:30Z"
    }
  },
  "links": {
    "documents": [
      {
        "content_id": "5e5dd324-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2014-02-24T15:00:02+00:00",
        "title": "Car and light van driver competence framework",
        "base_path": "/government/publications/car-and-light-van-driver-competence-framework",
        "description": "The research, statistics and professional opinions which form the basis of the 'National standard for driving cars and light vans'.",
        "api_url": "https://www.gov.uk/api/content/government/publications/car-and-light-van-driver-competence-framework",
        "web_url": "https://www.gov.uk/government/publications/car-and-light-van-driver-competence-framework",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5ddbe8-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2004-11-04T15:00:02+00:00",
        "title": "Moped and motorcycle rider competence framework",
        "base_path": "/government/publications/competence-framework-for-moped-and-motorcycle-riders",
        "description": "The research, statistics and professional opinions which form the basis of the 'National standard for riding mopeds and motorcycles'.",
        "api_url": "https://www.gov.uk/api/content/government/publications/competence-framework-for-moped-and-motorcycle-riders",
        "web_url": "https://www.gov.uk/government/publications/competence-framework-for-moped-and-motorcycle-riders",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5dc201-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2013-05-15T15:00:02+00:00",
        "title": "Car and light van driving syllabus",
        "base_path": "/government/publications/car-and-small-van-driving-syllabus",
        "description": "A way of teaching people the skills, knowledge and understanding they need to be a safe and responsible driver.",
        "api_url": "https://www.gov.uk/api/content/government/publications/car-and-small-van-driving-syllabus",
        "web_url": "https://www.gov.uk/government/publications/car-and-small-van-driving-syllabus",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5dc159-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2001-07-09T15:00:02+00:00",
        "title": "National standard for developed driving competence",
        "base_path": "/government/publications/national-standard-for-developed-driving-competence",
        "description": "What you must be able to do and what you must know and understand to show developed driving competence.",
        "api_url": "https://www.gov.uk/api/content/government/publications/national-standard-for-developed-driving-competence",
        "web_url": "https://www.gov.uk/government/publications/national-standard-for-developed-driving-competence",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5ddcc9-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2014-01-24T15:00:02+00:00",
        "title": "National standard for driver and rider training",
        "base_path": "/government/publications/national-standard-for-driver-and-rider-training",
        "description": "What you must be able to do and what you must know and understand to provide training to drivers and riders.",
        "api_url": "https://www.gov.uk/api/content/government/publications/national-standard-for-driver-and-rider-training",
        "web_url": "https://www.gov.uk/government/publications/national-standard-for-driver-and-rider-training",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5ddaac-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2010-06-12T15:00:02+00:00",
        "title": "National standard for driving buses and coaches",
        "base_path": "/government/publications/national-standard-for-driving-buses-and-coaches",
        "description": "What you must be able to do and what you must know and understand to be a safe and responsible bus or coach driver.",
        "api_url": "https://www.gov.uk/api/content/government/publications/national-standard-for-driving-buses-and-coaches",
        "web_url": "https://www.gov.uk/government/publications/national-standard-for-driving-buses-and-coaches",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5ddb9c-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2009-08-05T15:00:02+00:00",
        "title": "National standard for driving lorries",
        "base_path": "/government/publications/national-standard-for-driving-lorries",
        "description": "What you must be able to do and what you must know and understand to be a safe and responsible lorry driver.",
        "api_url": "https://www.gov.uk/api/content/government/publications/national-standard-for-driving-lorries",
        "web_url": "https://www.gov.uk/government/publications/national-standard-for-driving-lorries",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5dc29b-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "1994-01-22T15:00:02+00:00",
        "title": "National standard for riding mopeds and motorcycles",
        "base_path": "/government/publications/national-standard-for-riding-mopeds-and-motorcycles",
        "description": "What you must be able to do and what you must know and understand to be a safe and responsible moped or motorcycle rider.",
        "api_url": "https://www.gov.uk/api/content/government/publications/national-standard-for-riding-mopeds-and-motorcycles",
        "web_url": "https://www.gov.uk/government/publications/national-standard-for-riding-mopeds-and-motorcycles",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      },
      {
        "content_id": "5e5dc1ab-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2007-03-16T15:00:02+00:00",
        "title": "National standard for driving cars and light vans",
        "base_path": "/government/publications/national-standard-for-driving-cars-and-light-vans",
        "description": "What you must be able to do and what you must know and understand to be a safe and responsible car driver.",
        "api_url": "https://www.gov.uk/api/content/government/publications/national-standard-for-driving-cars-and-light-vans",
        "web_url": "https://www.gov.uk/government/publications/national-standard-for-driving-cars-and-light-vans",
        "locale": "en",
        "schema_name": "placeholder_publication",
        "document_type": "guidance",
        "analytics_identifier": null
      }
    ],
    "organisations": [
      {
        "content_id": "d39237a5-678b-4bb5-a372-eb2cb036933d",
        "title": "Driver and Vehicle Standards Agency",
        "base_path": "/government/organisations/driver-and-vehicle-standards-agency",
        "api_url": "https://www.gov.uk/api/organisations/driver-and-vehicle-standards-agency",
        "web_url": "https://www.gov.uk/government/organisations/driver-and-vehicle-standards-agency",
        "locale": "en",
        "analytics_identifier": "EA570"
      }
    ],
    "policy_areas": [
      {
        "content_id": "8034be95-4ac2-4fff-93c5-e7514ed9504a",
        "title": "Tax and revenue",
        "base_path": "/government/topics/tax-and-revenue",
        "api_url": "https://www.gov.uk/api/content/government/world/topics/tax-and-revenue",
        "web_url": "https://www.gov.uk/government/world/topics/tax-and-revenue",
        "locale": "en"
      }
    ]
  }
}

```

### document_collection_with_body.json
```json
{
  "content_id": "5eb851bc-7631-11e4-a3cb-005056011aef",
  "base_path": "/government/collections/financial-sanctions-regime-specific-consolidated-lists-and-releases",
  "description": "This document series contains details of all regimes currently subject to financial sanctions.",
  "public_updated_at": "2016-02-08T17:36:26.000+00:00",
  "title": "Financial sanctions: Regime-specific lists and releases",
  "updated_at": "2016-05-17T12:21:21.185Z",
  "schema_name": "document_collection",
  "document_type": "document_collection",
  "format": "document_collection",
  "locale": "en",
  "details": {
    "body": "<div class=\"govspeak\"><p>Each regime page provides a current list of asset freeze targets designated by the United Nations (UN), European Union and United Kingdom, under legislation relating to current financial sanctions regimes.</p>\n\n<h2 id=\"consolidated-list\">Consolidated list</h2>\n\n<p>The <a rel=\"external\" href=\"https://www.gov.uk/government/publications/financial-sanctions-consolidated-list-of-targets\">current consolidated list of asset freeze targets</a> designated by the United Nations, European Union and United Kingdom, under legislation relating to current financial sanctions regimes, is also available.</p>\n\n<h3 id=\"subscribing-to-financial-sanctions-mailing-list\">Subscribing to financial sanctions mailing list</h3>\n\n<p><a rel=\"external\" href=\"http://engage.hm-treasury.gov.uk/fin-sanc-subscribe/\">Subscribe to our free e-mail alerts</a> for information on updates to the Treasury’s consolidated list of targets of financial sanctions in effect in the UK.</p>\n\n<p>Enquiries relating to asset freezing or other financial sanctions should be submitted to HM Treasury either by email to <a href=\"mailto:financialsanctions@hmtreasury.gsi.gov.uk\">financialsanctions@hmtreasury.gsi.gov.uk</a> or by post to Financial Sanctions, HM Treasury, 1 Horse Guards Road, London SW1A 2HQ.</p>\n\n<h3 id=\"further-information\">Further information</h3>\n\n<p>For further information on financial sanctions see the <a href=\"https://www.gov.uk/sanctions-embargoes-and-restrictions\">guide to sanctions, embargoes and restrictions.</a></p>\n</div>",
    "collection_groups": [
      {
        "title": "Documents",
        "documents": [
          "841f225a-80b2-44d5-ba13-a36c7a82b859",
          "5e2fd762-7631-11e4-a3cb-005056011aef",
          "5e2fd5e9-7631-11e4-a3cb-005056011aef"
        ]
      }
    ],
    "first_public_at": "2013-10-11T17:12:00+01:00",
    "change_history": [
      {
        "public_timestamp": "2016-02-08T17:36:26+00:00",
        "note": "Liberia removed - Council Regulation (EC) No 872/2004 imposing financial sanctions against Liberia has been repealed with effect from 6 October 2015."
      },
      {
        "public_timestamp": "2016-01-22T12:36:47+00:00",
        "note": "Updated to add - Financial Sanctions, UK freezing orders"
      },
      {
        "public_timestamp": "2014-12-23T10:17:01+00:00",
        "note": "Updated to include Yemen in collection"
      },
      {
        "public_timestamp": "2014-07-15T16:24:28+01:00",
        "note": "Updated to reflect latest HM Treasury notices, 15/07/14 Sudan (Reg 747/2014) and 15/07/14 South Sudan (Reg 748/2014)"
      },
      {
        "public_timestamp": "2014-03-18T12:36:37+00:00",
        "note": "added 'Financial sanctions, Ukraine (Sovereignty and Territorial Integrity)' to collection"
      },
      {
        "public_timestamp": "2014-03-12T15:33:27+00:00",
        "note": "added Central African Republic"
      },
      {
        "public_timestamp": "2014-02-21T16:59:49+00:00",
        "note": "added publication 'Financial sanctions, Ukraine'"
      },
      {
        "public_timestamp": "2013-10-11T17:12:00+01:00",
        "note": "First published."
      }
    ],
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": false,
    "emphasised_organisations": ["1994e0e4-bd19-4966-bbd7-f293d6e90a6b"]
  },
  "links": {
    "documents": [
      {
        "content_id": "5e2fd5e9-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2014-08-24T15:00:02+00:00",
        "title": "Financial sanctions, Somalia",
        "base_path": "/government/publications/financial-sanctions-somalia",
        "description": "Somalia is currently subject to financial sanctions. This document contains the current list of designated persons.",
        "api_url": "https://www.gov.uk/api/content/government/publications/financial-sanctions-somalia",
        "web_url": "https://www.gov.uk/government/publications/financial-sanctions-somalia",
        "locale": "en",
        "document_type": "guidance"
      },
      {
        "content_id": "5e2fd762-7631-11e4-a3cb-005056011aef",
        "public_updated_at": "2004-11-04T15:00:02+00:00",
        "title": "Current list of designated persons, terrorism and terrorist financing",
        "base_path": "/government/publications/current-list-of-designated-persons-terrorism-and-terrorist-financing",
        "description": "This document provides a current list of designated persons currently subject to financial sanctions for believed involvement in terrorist activity.",
        "api_url": "https://www.gov.uk/api/content/government/publications/current-list-of-designated-persons-terrorism-and-terrorist-financing",
        "web_url": "https://www.gov.uk/government/publications/current-list-of-designated-persons-terrorism-and-terrorist-financing",
        "locale": "en",
        "document_type": "guidance"
      },
      {
        "content_id": "841f225a-80b2-44d5-ba13-a36c7a82b859",
        "public_updated_at": "2007-12-15T15:00:02+00:00",
        "title": "Financial Sanctions, UK freezing orders",
        "base_path": "/government/publications/financial-sanctions-uk-freezing-orders",
        "description": "Somalia is currently subject to financial sanctions. This document contains the current list of designated persons.",
        "api_url": "https://www.gov.uk/api/content/government/publications/financial-sanctions-uk-freezing-orders",
        "web_url": "https://www.gov.uk/government/publications/financial-sanctions-uk-freezing-orders",
        "locale": "en",
        "document_type": "guidance"
      }
    ],
    "organisations": [
      {
        "content_id": "1994e0e4-bd19-4966-bbd7-f293d6e90a6b",
        "title": "HM Treasury",
        "base_path": "/government/organisations/hm-treasury",
        "api_url": "https://www.gov.uk/api/organisations/hm-treasury",
        "web_url": "https://www.gov.uk/government/organisations/hm-treasury",
        "locale": "en",
        "analytics_identifier": "D15"
      },
      {
        "content_id": "e82999a0-79f0-4c77-a8f1-39135e7a123c",
        "title": "Office of Financial Sanctions Implementation",
        "base_path": "/government/organisations/office-of-financial-sanctions-implementation",
        "api_url": "https://www.gov.uk/api/organisations/office-of-financial-sanctions-implementation",
        "web_url": "https://www.gov.uk/government/organisations/office-of-financial-sanctions-implementation",
        "locale": "en",
        "analytics_identifier": "OT1187"
      }
    ],
    "policy_areas": [
      {
        "content_id": "8034be95-4ac2-4fff-93c5-e7514ed9504a",
        "title": "Tax and revenue",
        "base_path": "/government/topics/tax-and-revenue",
        "api_url": "https://www.gov.uk/api/content/government/world/topics/tax-and-revenue",
        "web_url": "https://www.gov.uk/government/world/topics/tax-and-revenue",
        "locale": "en"
      }
    ]
  }
}

```



