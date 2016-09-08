---
layout: content_schema
title:  HMRC manual
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/hmrc_manual/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>child_section_groups</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_notes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>topics</strong> <code>array</code></td> <td>Slugs of the Manual's topics. An example of a topic slug is 'business-tax/vat'.</td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>hmrc_manual</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/hmrc_manual/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>taxons</strong> </td> <td>Prototype-stage taxonomy label for this content item</td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/hmrc_manual/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>child_section_groups</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_notes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>topics</strong> <code>array</code></td> <td>Slugs of the Manual's topics. An example of a topic slug is 'business-tax/vat'.</td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>taxons</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>hmrc_manual</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### vat-government-public-bodies.json
```json
{
  "content_id": "e5c19314-6746-4141-9d11-5fbd449a9b2e",
  "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies",
  "title": "VAT Government and Public Bodies",
  "description": "Guidance on VAT as it applies to local authorities and other government and public bodies.",
  "format": "hmrc_manual",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-03-05T15:16:29.904Z",
  "public_updated_at": "2015-02-11T13:45:00.000+00:00",
  "details": {
    "child_section_groups": [
      {
        "child_sections": [
          {
            "section_id": "VATGPB1000",
            "title": "Introduction: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000"
          },
          {
            "section_id": "VATGPB2000",
            "title": "Bodies governed by public law: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb2000"
          },
          {
            "section_id": "VATGPB3000",
            "title": "Non-business activities: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000"
          },
          {
            "section_id": "VATGPB4000",
            "title": "Section 33 bodies: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb4000"
          },
          {
            "section_id": "VATGPB5000",
            "title": "Police authorities: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5000"
          },
          {
            "section_id": "VATGPB6000",
            "title": "Local government partnership programmes: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb6000"
          },
          {
            "section_id": "VATGPB7000",
            "title": "Local authority education services: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb7000"
          },
          {
            "section_id": "VATGPB8000",
            "title": "Other local authority activities: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb8000"
          },
          {
            "section_id": "VATGPB9000",
            "title": "Government departments and health authorities: contents",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb9000"
          }
        ]
      },
      {
        "child_sections": [
          {
            "section_id": "VATGPBUPDATE001",
            "title": "VAT Government and public bodies: update index",
            "description": "",
            "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpbupdate001"
          }
        ],
        "title": "Historic updates"
      }
    ],
    "change_notes": [
      {
        "change_note": "Updated content",
        "section_id": "VATGPB5390",
        "title": "Police authorities: summary of activities: liabilities T to Z",
        "published_at": "2015-03-05T15:16:20+00:00",
        "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5390"
      },
      {
        "change_note": "Updated content",
        "section_id": "VATGPB5370",
        "title": "Police authorities: summary of activities: liabilities P",
        "published_at": "2015-03-05T15:14:29+00:00",
        "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5370"
      },
      {
        "change_note": "Updated content",
        "section_id": "VATGPB5360",
        "title": "Police authorities: summary of activities: liabilities N to O",
        "published_at": "2015-03-05T15:12:55+00:00",
        "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5360"
      },
      {
        "change_note": "Updated content",
        "section_id": "VATGPB5350",
        "title": "Police authorities: summary of activities: liabilities I to M",
        "published_at": "2015-03-05T15:11:32+00:00",
        "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5350"
      }
    ],
    "organisations": [
      {
        "title": "HM Revenue & Customs",
        "abbreviation": "HMRC",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs"
      }
    ]
  },
  "links": {
    "available_translations": [
      {
        "content_id": "e5c19314-6746-4141-9d11-5fbd449a9b2e",
        "title": "VAT Government and Public Bodies",
        "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies",
        "api_url": "https://content-store.preview.alphagov.co.uk/content/hmrc-internal-manuals/vat-government-and-public-bodies",
        "web_url": "https://www.preview.alphagov.co.uk/hmrc-internal-manuals/vat-government-and-public-bodies",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
        "title": "HM Revenue & Customs",
        "base_path": "/government/organisations/hm-revenue-customs",
        "api_url": "https://www.gov.uk/api/content/government/organisations/hm-revenue-customs",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs",
        "locale": "en"
      }
    ]
  },
  "schema_name": "hmrc_manual",
  "document_type": "hmrc_manual"
}

```



