---
layout: content_schema
title:  Case study
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/case_study/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alt_text</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>caption</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>format_display_type</strong> <code>string</code></td> <td>Allowed values: <code>case_study</code></td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>change_note</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>archive_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>archived_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>case_study</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/case_study/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related_policies</strong> </td> <td></td></tr>
<tr><td><strong>world_locations</strong> </td> <td></td></tr>
<tr><td><strong>worldwide_organisations</strong> </td> <td></td></tr>
<tr><td><strong>document_collections</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/case_study/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alt_text</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>caption</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>format_display_type</strong> <code>string</code></td> <td>Allowed values: <code>case_study</code></td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>change_note</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>archive_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>archived_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related_policies</strong> </td> <td></td></tr>
<tr><td><strong>world_locations</strong> </td> <td></td></tr>
<tr><td><strong>worldwide_organisations</strong> </td> <td></td></tr>
<tr><td><strong>document_collections</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>case_study</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### archived.json
```json
{
  "base_path": "/government/case-studies/terence-age-33-stoke-on-trent",
  "content_id": "3933c3df-9fdd-4a56-99cd-9a9351cbbf99",
  "title": "Terence, age 33, Stoke-on-Trent",
  "description": "'My experience with Shaw Trust was very positive and I received all the support I needed to get back into work.'",
  "format": "case_study",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2014-12-08T15:26:28.258Z",
  "public_updated_at": "2013-04-15T16:12:55.000+00:00",
  "withdrawn_notice": {
    "explanation": "<div class=\"govspeak\"><p>We’ve withdrawn this case study and published newer <a href=\"https://www.gov.uk/government/collections/work-programme-real-life-stories\">Work Programme real life stories</a>.</p></div>",
    "withdrawn_at": "2014-08-22T10:29:02+01:00"
  },
  "details": {
    "change_note": null,
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "body": "<div class=\"govspeak\"><p>Following the death of his wife Terence has been caring full-time for his two children, one of whom has a physical disability and medical condition and requires a lot of support.</p>\n\n<p>Terence was unemployed for over 14 years when he joined the Work Programme with Shaw Trust.</p>\n\n<p>Terence was keen to find work in the care industry but was concerned that his lack of qualifications, his childcare commitments and long period of unemployment could impact on him finding a job.</p>\n\n<p>An adviser worked with Terence so that he received tailored support with his CV to reflect the type of work he was looking for, as well as interview preparation and basic IT skills.</p>\n\n<p>Terence was delighted when he secured a permanent job as a support worker that allowed him to continue caring for his children.</p>\n\n<p>Terence found the support he received from the Shaw Trust made all the difference: </p>\n\n<blockquote>\n  <p class=\"last-child\">The fact that my adviser rang me after interviews and the ongoing support I received really helped build my confidence.</p>\n</blockquote>\n\n<p>The Work Programme is part funded by the European Social Fund.</p></div>",
    "format_display_type": "case_study",
    "first_public_at": "2013-04-15T17:12:55+01:00",
    "change_history": [
      {
        "public_timestamp": "2013-04-15T17:12:55+01:00",
        "note": "First published."
      }
    ],
    "image": {
      "url": "https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/image_data/file/6029/s300_terence-stoke-960.jpg",
      "alt_text": "Terence",
      "caption": null
    },
    "emphasised_organisations": ["dbeaa22b-fb0c-49b0-b44e-0ca6cb52b381"],
    "withdrawn_notice": {
      "explanation": "<div class=\"govspeak\"><p>We’ve withdrawn this case study and published newer <a href=\"https://www.gov.uk/government/collections/work-programme-real-life-stories\">Work Programme real life stories</a>.</p></div>",
      "withdrawn_at": "2014-08-22T10:29:02+01:00"
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "dbeaa22b-fb0c-49b0-b44e-0ca6cb52b381",
        "title": "Department for Work and Pensions",
        "base_path": "/government/organisations/department-for-work-pensions",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-work-pensions",
        "web_url": "https://www.gov.uk/government/organisations/department-for-work-pensions",
        "locale": "en"
      }
    ],
    "related_policies": [
      {
        "content_id": "155c22d4-c1f9-40fc-bbe4-4a19df82b164",
        "title": "Helping people to find and stay in work",
        "base_path": "/government/policies/helping-people-to-find-and-stay-in-work",
        "api_url": "https://www.gov.uk/api/content/government/policies/helping-people-to-find-and-stay-in-work",
        "web_url": "https://www.gov.uk/government/policies/helping-people-to-find-and-stay-in-work",
        "locale": "en"
      }
    ],
    "world_locations": [],
    "worldwide_organisations": [],
    "available_translations": [
      {
        "content_id": "3933c3df-9fdd-4a56-99cd-9a9351cbbf99",
        "title": "Terence, age 33, Stoke-on-Trent",
        "base_path": "/government/case-studies/terence-age-33-stoke-on-trent",
        "api_url": "https://www.gov.uk/api/content/government/case-studies/terence-age-33-stoke-on-trent",
        "web_url": "https://www.gov.uk/government/case-studies/terence-age-33-stoke-on-trent",
        "locale": "en"
      }
    ],
    "document_collections": [
      {
        "content_id": "19ed8498-37ed-4c8e-b0bf-accbb2cf5477",
        "title": "Work Programme real life stories",
        "base_path": "/government/collections/work-programme-real-life-stories",
        "api_url": "https://www.gov.uk/api/content/government/collections/work-programme-real-life-stories",
        "web_url": "https://www.gov.uk/government/collections/work-programme-real-life-stories",
        "locale": "en"
      }
    ]
  },
  "schema_name": "case_study",
  "document_type": "case_study"
}

```

### case_study.json
```json
{
  "content_id": "cc717565-1290-4a22-b8d4-4b25facb3c8f",
  "base_path": "/government/case-studies/get-britain-building-carlisle-park",
  "description": "Nearly 400 homes are set to be built on the site of a former tar distillery thanks to Gleeson Homes and HCA investment.",
  "details": {
    "body": "<div class=\"govspeak\"><p>A new community of nearly 400 homes is set to be built on the site of a former tar distillery thanks to Gleeson Homes and investment from the Homes and Communities Agency (<abbr title=\"Homes and Communities Agency\">HCA</abbr>).</p>\n\n<p>The Croda Tar Distillery, on the border between Kilnhurst and Swinton, closed in the early 1990s. Over the past 2 decades the 31 acre site has lain derelict with the heavily contaminated site proving a challenge for developers.</p>\n\n<p>However in 2010 Gleeson identified the site, which is adjacent to the Sheffield &amp; South Yorkshire Navigation Canal, as having great potential for new low cost homes.</p>\n\n<p>Working with Rotherham Borough Council and remediation specialists, work is now underway to clean up the site. </p>\n\n<p>Once the clean-up has been completed Gleeson Homes will begin to transform the area into 381 new 2, 3 and 4 bedroom homes.  The developer will be making use of £2.2 million of investment from the Homes and Communities Agency’s (<abbr title=\"Homes and Communities Agency\">HCA</abbr>) Get Britain Building programme to start the first phase of 125 homes.</p>\n\n<p>Craig Johns, Area Manager at the <abbr title=\"Homes and Communities Agency\">HCA</abbr> said: </p>\n\n<p>“The development at Carlisle Park offers a real choice of quality homes to local residents where they want to live at a price they can afford. Our investment will ensure that a local firm will provide these homes which will help safeguard jobs in South Yorkshire.”</p>\n\n<p>The development will feature a mix of first time buyer and family homes, set among public open space and children’s play areas.</p>\n\n<p>Steve Gamble, Gleeson Homes Group Land Director said: </p>\n\n<p>“We are delighted that Carlisle Park is part of the Get Britain Building programme. The programme will help us to deliver the first tranche of 125 new homes which are built and priced to suit local people.  </p>\n\n<p>“The project will also have a positive effect of the wider community with the creation of new jobs, apprenticeship opportunities for local young people and investment back into the local area.”</p>\n\n<p>A recoverable investment, the Get Britain Building programme helps developers access finance, and to help bring forward marginal sites by sharing risk. </p>\n\n<p>Up to 16,000 homes on stalled sites across England will be built by March 2015 thanks to this programme.</p></div>",
    "change_note": null,
    "first_public_at": "2012-12-17T15:45:44+00:00",
    "image": {
      "alt_text": "Carlisle Park",
      "caption": "Carlisle Park",
      "url": "http://static.dev.gov.uk/government/uploads/system/uploads/image_data/file/5693/s300_Carlisle_Park_1_960x640.jpg"
    },
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "format_display_type": "case_study",
    "emphasised_organisations": ["8b19c238-54e3-4e27-b0d7-60f8e2a677c9"]
  },
  "format": "case_study",
  "links": {
    "organisations": [
      {
        "content_id": "8b19c238-54e3-4e27-b0d7-60f8e2a677c9",
        "title": "Department for International Development",
        "base_path": "/government/organisations/department-for-international-development",
        "api_url": "https://www.gov.uk/api/organisations/department-for-international-development",
        "web_url": "https://www.gov.uk/government/organisations/department-for-international-development",
        "locale": "en",
        "analytics_identifier": "L2"
      }
    ],
    "related_policies": [],
    "world_locations": [
      {
        "content_id": "456af51f-5fd3-4855-8a33-52cb32ff9985",
        "title": "Pakistan",
        "base_path": "/government/world/pakistan",
        "api_url": "https://www.gov.uk/api/content/government/world/pakistan",
        "web_url": "https://www.gov.uk/government/world/pakistan",
        "locale": "en",
        "analytics_identifier": "WL3"
      }
    ],
    "worldwide_organisations": [
      {
        "content_id": "f1ec569a-3471-4de0-947c-a4f3bcccb983",
        "title": "DFID Pakistan",
        "base_path": "/government/world/organisations/dfid-pakistan",
        "api_url": "https://www.gov.uk/api/content/government/world/organisations/dfid-pakistan",
        "web_url": "https://www.gov.uk/government/world/organisations/dfid-pakistan",
        "locale": "en",
        "analytics_identifier": "W4"
      }
    ],
    "available_translations": [
      {
        "content_id": "cc717565-1290-4a22-b8d4-4b25facb3c8f",
        "title": "Pakistan: In school for the first time",
        "base_path": "/government/case-studies/pakistan-in-school-for-the-first-time",
        "api_url": "https://www.gov.uk/api/content/government/case-studies/pakistan-in-school-for-the-first-time",
        "web_url": "https://www.gov.uk/government/case-studies/pakistan-in-school-for-the-first-time",
        "locale": "en"
      },
      {
        "content_id": "cc717565-1290-4a22-b8d4-4b25facb3c8f",
        "title": "پاکستان: اسکول میں پہلی بارداخلہ",
        "base_path": "/government/case-studies/pakistan-in-school-for-the-first-time.ur",
        "api_url": "https://www.gov.uk/api/content/government/case-studies/pakistan-in-school-for-the-first-time.ur",
        "web_url": "https://www.gov.uk/government/case-studies/pakistan-in-school-for-the-first-time.ur",
        "locale": "ur"
      }
    ],
    "document_collections": [
      {
        "content_id": "def40c5f-52d0-4dca-80ea-b0da5caeebcd",
        "title": "Work Programme real life stories",
        "base_path": "/government/collections/work-programme-real-life-stories",
        "api_url": "https://www.gov.uk/api/content/government/collections/work-programme-real-life-stories",
        "web_url": "https://www.gov.uk/government/collections/work-programme-real-life-stories",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [
    "100001",
    "100002"
  ],
  "public_updated_at": "2012-12-17T15:45:44.000+00:00",
  "title": "Get Britain Building: Carlisle Park",
  "updated_at": "2014-11-17T14:19:42.460Z",
  "schema_name": "case_study",
  "document_type": "case_study"
}

```

### translated.json
```json
{
  "content_id": "394f8be4-175b-4fb8-8470-35049451b1c7",
  "base_path": "/government/case-studies/doing-business-in-spain.es",
  "description": "Los negocios y las inversiones de las empresas españolas en el exterior tienen éxito y, al mismo tiempo, empresas extranjeras siguen identificando atractivas oportunidades de negocio que ofrece España.",
  "details": {
    "body": "<div class=\"govspeak\"><p>Los equipos de  UK Trade &amp; Investment (Departamento gubernamental británico de negocios e inversiones) de Madrid, Barcelona y Bilbao, contribuyen a que el número de empresas británicas que hacen negocios en España sea cada vez mayor; así como a impulsar la inversión española en el Reino Unido.</p>\n\n<p>Martin Phelan, director de UKTI Iberia, explica con más detalle que ofrece España a la empresa británica.</p>\n\n<p><a rel=\"external\" href=\"http://www.youtube.com/watch?v=C-O59O0_DOY&amp;list=UUWl6ZVke4P2GYpk6eq4BPIQ&amp;index=21\">Martin Phelan</a></p>\n\n<p>London School of Economics y la empresa británica Tunstall hablan de su experiencia en el mercado español y cómo UKTI ha contribuido a su éxito.</p>\n\n<p><a rel=\"external\" href=\"http://www.youtube.com/watch?v=reDxB4wpi2o&amp;list=UUWl6ZVke4P2GYpk6eq4BPIQ&amp;index=23\">Adam Austerfield</a></p>\n\n<p><a rel=\"external\" href=\"http://www.youtube.com/watch?v=WSo0LJ_c1-I\">Joe Killen</a></p>\n\n<p>A pesar de la actual situación económica en España, existe una gran actividad empresarial internacional y nacional. El país es la cuarta mayor economía de la zona del euro y la 13 a nivel mundial. España ha mantenido el crecimiento de sus exportaciones, que aumentaron un 18% entre 2010 y 2012.</p>\n\n<p>En España es fácil hacer negocios. El país representa un mercado muy diverso para los bienes y servicios de Reino Unido, y su valor supera los 15 mil millones de libras anuales. La percepción de las empresas británicas es claramente positiva y a sus homólogos españoles les gusta hacer negocios con ellas.</p>\n\n<p>Existen oportunidades en todo el país en sectores como la sanidad y las ciencias de la vida, en educación y en el sector aeroespacial. El Gobierno español ha llevado a cabo una importante reforma del sector público y han surgido oportunidades a través de contratos de prestación de servicios.</p>\n\n<p>En España se encuentran algunas de mayores las empresas globales, incluyendo cuatro de los mayores grupos de infraestructuras del mundo. Ocho empresas (Santander, Telefónica, Repsol, BBVA, Iberdrola, ACS, Gas Natural y Mapfre) se encuentran en la lista Fortune Global 500 de 2012, que recoge las empresas líderes internacionales por su cifra de ingresos.</p>\n\n<p>España es el segundo fabricante de coches más grande de Europa, detrás de Alemania. En el sector turístico, el país ocupa igualmente el segundo puesto mundial en ingresos, detrás de Estados Unidos.</p>\n\n<p>La experiencia de UK Trade &amp; Investment en los sectores industrial y privado, y los enlaces con los principales sectores de la industria, hacen de UKTI el mejor proveedor de asesoramiento empresarial a la empresa.</p>\n\n<p>Contacte con nuestros expertos en asuntos comerciales para más información: </p>\n\n<h3 id=\"madrid\">Madrid</h3>\n<p>UK Trade &amp; Investment \nBritish Embassy\nPaseo de la Castellana, 259-D Torre Espacio - 28046 Madrid\nTel: +34 917 146 412  Email: uktimadrid@fco.gov.uk</p>\n\n<h3 id=\"barcelona\">Barcelona</h3>\n<p>UK Trade &amp; Investment \nBritish Consulate-General \nAvda Diagonal, 477-13º Edificio Torre de Barcelona - 08036 Barcelona\nTel.: +34 93 366 6207  Email: uktibarcelona@fco.gov.uk</p>\n\n<h3 id=\"bilbao\">Bilbao</h3>\n<p>UK Trade &amp; Investment \nBritish Consulate-General \nAlameda de Urquijo, 2-8 - 48008 Bilbao\nTel.: +34 91 334 47 67   Email: british.consulate@fco.gov.uk</p></div>",
    "change_history": [
      {
        "note": "Added translation",
        "public_timestamp": "2013-03-21T13:21:50+00:00"
      }
    ],
    "change_note": "Added translation",
    "first_public_at": "2013-03-21T13:20:50+00:00",
    "format_display_type": "case_study",
    "image": {
      "alt_text": "UKTI Spain",
      "caption": "UKTI Spain",
      "url": "https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/image_data/file/7633/s300_foto_UKTI-1.jpg"
    },
    "emphasised_organisations": ["8449fbe1-bffe-46cf-a141-07df52c530b7"],
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    }
  },
  "format": "case_study",
  "links": {
    "available_translations": [
      {
        "content_id": "394f8be4-175b-4fb8-8470-35049451b1c7",
        "api_url": "https://www.gov.uk/api/content/government/case-studies/doing-business-in-spain",
        "base_path": "/government/case-studies/doing-business-in-spain",
        "locale": "en",
        "title": "Doing business in Spain",
        "web_url": "https://www.gov.uk/government/case-studies/doing-business-in-spain"
      },
      {
        "content_id": "394f8be4-175b-4fb8-8470-35049451b1c7",
        "api_url": "https://www.gov.uk/api/content/government/case-studies/doing-business-in-spain.es",
        "base_path": "/government/case-studies/doing-business-in-spain.es",
        "locale": "es",
        "title": "¿Qué puede hacer UKTI por tí?",
        "web_url": "https://www.gov.uk/government/case-studies/doing-business-in-spain.es"
      },
      {
        "content_id": "394f8be4-175b-4fb8-8470-35049451b1c7",
        "api_url": "https://www.gov.uk/api/content/government/case-studies/doing-business-in-spain.ar",
        "base_path": "/government/case-studies/doing-business-in-spain.ar",
        "locale": "ar",
        "title": "البحرين - تحديث دراسة حالة دولة",
        "web_url": "https://www.gov.uk/government/case-studies/doing-business-in-spain.ar"
      }
    ],
    "organisations": [
      {
        "content_id": "8449fbe1-bffe-46cf-a141-07df52c530b7",
        "api_url": "https://www.gov.uk/api/content/government/organisations/uk-trade-investment",
        "base_path": "/government/organisations/uk-trade-investment",
        "locale": "en",
        "title": "UK Trade & Investment",
        "web_url": "https://www.gov.uk/government/organisations/uk-trade-investment"
      }
    ],
    "world_locations": [
      {
        "content_id": "1a47d8eb-36e8-4a9e-8a05-ca33184c2f86",
        "api_url": "https://www.gov.uk/api/content/government/world/spain.es",
        "base_path": "/government/world/spain.es",
        "locale": "es",
        "title": "España",
        "web_url": "https://www.gov.uk/government/world/spain.es"
      }
    ],
    "worldwide_organisations": []
  },
  "locale": "es",
  "need_ids": [],
  "public_updated_at": "2013-03-21T13:21:50.000+00:00",
  "title": "¿Qué puede hacer UKTI por tí?",
  "updated_at": "2014-12-02T14:59:55.613Z",
  "schema_name": "case_study",
  "document_type": "case_study"
}

```



