---
layout: content_schema
title:  Mainstream browse page
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/mainstream_browse_page/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>internal_name</strong> <code>string</code></td> <td>An internal name for admin interfaces. Includes parent.</td></tr>
<tr><td><strong>second_level_ordering</strong> </td> <td>Allowed values: <code>alphabetical</code> or <code>curated</code></td></tr>
<tr><td><strong>ordered_second_level_browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>groups</strong> <code>array</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>mainstream_browse_page</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/mainstream_browse_page/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>top_level_browse_pages</strong> </td> <td>All top-level browse pages</td></tr>
<tr><td><strong>active_top_level_browse_page</strong> </td> <td>The top-level browse page which is active</td></tr>
<tr><td><strong>second_level_browse_pages</strong> </td> <td>All 2nd level browse pages under active_top_level_browse_page</td></tr>
<tr><td><strong>related_topics</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/mainstream_browse_page/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>internal_name</strong> <code>string</code></td> <td>An internal name for admin interfaces. Includes parent.</td></tr>
<tr><td><strong>second_level_ordering</strong> </td> <td>Allowed values: <code>alphabetical</code> or <code>curated</code></td></tr>
<tr><td><strong>ordered_second_level_browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>groups</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>top_level_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>active_top_level_browse_page</strong> </td> <td></td></tr>
<tr><td><strong>second_level_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>related_topics</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>mainstream_browse_page</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### curated_level_2_page.json
```json
{
  "content_id": "1a0ec400-632d-4af5-ad96-f18dc028d9ba",
  "base_path": "/browse/benefits/entitlement-with-list",
  "description": "When and how benefit payments are made, benefits adviser and benefit fraud",
  "details": {
    "groups": [
      {
        "name": "Fraud",
        "contents": [
          "/benefit-fraud",
          "/national-benefit-fraud-hotline",
          "/benefit-integrity-centres"
        ]
      },
      {
        "name": "Complaints",
        "contents": [
          "/complain-debt-management",
          "/complain-independent-case-examiner"
        ]
      }
    ]
  },
  "format": "mainstream_browse_page",
  "links": {
    "active_top_level_browse_page": [
      {
        "content_id": "778bb9da-db42-4855-b0a2-1470246a5568",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      }
    ],
    "top_level_browse_pages": [
      {
        "content_id": "778bb9da-db42-4855-b0a2-1470246a5568",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      },
      {
        "content_id": "05cd9691-ed36-4cb2-9576-ce7cb81e1936",
        "title": "Births, deaths, marriages and care",
        "base_path": "/browse/births-deaths-marriages",
        "description": "Parenting, civil partnerships, divorce and lasting power of attorney",
        "api_url": "https://www.gov.uk/api/content/browse/births-deaths-marriages",
        "web_url": "https://www.gov.uk/browse/births-deaths-marriages",
        "locale": "en"
      },
      {
        "content_id": "426debef-4aad-423e-8597-4851f9015b5f",
        "title": "Business and self-employed",
        "base_path": "/browse/business",
        "description": "Information about starting up and running a business in the UK, including help if you're self employed or a sole trader.",
        "api_url": "https://www.gov.uk/api/content/browse/business",
        "web_url": "https://www.gov.uk/browse/business",
        "locale": "en"
      }
    ],
    "second_level_browse_pages": [
      {
        "content_id": "1a0ec400-632d-4af5-ad96-f18dc028d9ba",
        "title": "Benefits entitlement",
        "base_path": "/browse/benefits/entitlement-with-list",
        "description": "When and how benefit payments are made, benefits adviser and benefit fraud",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/entitlement",
        "web_url": "https://www.gov.uk/browse/benefits/entitlement",
        "locale": "en"
      },
      {
        "content_id": "7fd9bd20-f18c-495b-aac4-e05489be2b87",
        "title": "Benefits for families",
        "base_path": "/browse/benefits/families",
        "description": "Includes Child Trust Funds, childcare and the Sure Start Maternity Grant",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/families",
        "web_url": "https://www.gov.uk/browse/benefits/families",
        "locale": "en"
      },
      {
        "content_id": "f6a1202c-8491-49eb-94ce-cdddb55806da",
        "title": "Carers and disability benefits",
        "base_path": "/browse/benefits/disability",
        "description": "Includes Disability Living Allowance, Carer's Allowance and Employment and Support Allowance",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/disability",
        "web_url": "https://www.gov.uk/browse/benefits/disability",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Benefits entitlement",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "mainstream_browse_page",
  "document_type": "mainstream_browse_page"
}

```

### level_2_page.json
```json
{
  "content_id": "d086e95b-0e5e-46a3-97bc-d0672b111b7c",
  "base_path": "/browse/benefits/entitlement",
  "description": "When and how benefit payments are made, benefits adviser and benefit fraud",
  "details": {},
  "format": "mainstream_browse_page",
  "links": {
    "active_top_level_browse_page": [
      {
        "content_id": "fde24a9c-f304-4b8b-af67-39faabb3c821",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      }
    ],
    "top_level_browse_pages": [
      {
        "content_id": "fde24a9c-f304-4b8b-af67-39faabb3c821",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      },
      {
        "content_id": "2695b93d-aa9f-418a-847d-eaf63a474d75",
        "title": "Births, deaths, marriages and care",
        "base_path": "/browse/births-deaths-marriages",
        "description": "Parenting, civil partnerships, divorce and lasting power of attorney",
        "api_url": "https://www.gov.uk/api/content/browse/births-deaths-marriages",
        "web_url": "https://www.gov.uk/browse/births-deaths-marriages",
        "locale": "en"
      },
      {
        "content_id": "14a1e0fd-2ee3-4816-b700-e3640f9c4533",
        "title": "Business and self-employed",
        "base_path": "/browse/business",
        "description": "Information about starting up and running a business in the UK, including help if you're self employed or a sole trader.",
        "api_url": "https://www.gov.uk/api/content/browse/business",
        "web_url": "https://www.gov.uk/browse/business",
        "locale": "en"
      }
    ],
    "second_level_browse_pages": [
      {
        "content_id": "d086e95b-0e5e-46a3-97bc-d0672b111b7c",
        "title": "Benefits entitlement",
        "base_path": "/browse/benefits/entitlement",
        "description": "When and how benefit payments are made, benefits adviser and benefit fraud",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/entitlement",
        "web_url": "https://www.gov.uk/browse/benefits/entitlement",
        "locale": "en"
      },
      {
        "content_id": "c48318ab-26cf-4049-9c0f-3bc693cf41b7",
        "title": "Benefits for families",
        "base_path": "/browse/benefits/families",
        "description": "Includes Child Trust Funds, childcare and the Sure Start Maternity Grant",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/families",
        "web_url": "https://www.gov.uk/browse/benefits/families",
        "locale": "en"
      },
      {
        "content_id": "b8ecf6a5-ea0e-43d1-aa25-fb68bbe62554",
        "title": "Carers and disability benefits",
        "base_path": "/browse/benefits/disability",
        "description": "Includes Disability Living Allowance, Carer's Allowance and Employment and Support Allowance",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/disability",
        "web_url": "https://www.gov.uk/browse/benefits/disability",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Benefits entitlement",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "mainstream_browse_page",
  "document_type": "mainstream_browse_page"
}

```

### level_2_page_with_related_topics.json
```json
{
  "content_id": "05aadfe6-50d4-4932-bb76-5dfe315a1eb1",
  "base_path": "/browse/benefits/families",
  "description": "Includes Child Trust Funds, childcare and the Sure Start Maternity Grant",
  "details": {},
  "format": "mainstream_browse_page",
  "links": {
    "related_topics": [
      {
        "content_id": "4f67c02c-c9c5-4119-baa7-68b910516c08",
        "title": "Universal credit",
        "base_path": "/benefits/universal-credit",
        "api_url": "https://www.gov.uk/api/content/benefits/universal-credit",
        "web_url": "https://www.gov.uk/benefits/universal-credit",
        "locale": "en"
      }
    ],
    "active_top_level_browse_page": [
      {
        "content_id": "3ed5d5a0-4224-4cc7-a9b1-0c471150f69b",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      }
    ],
    "top_level_browse_pages": [
      {
        "content_id": "3ed5d5a0-4224-4cc7-a9b1-0c471150f69b",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      },
      {
        "content_id": "4fd8cfb6-95ea-4998-92e2-7f332254a89b",
        "title": "Births, deaths, marriages and care",
        "base_path": "/browse/births-deaths-marriages",
        "description": "Parenting, civil partnerships, divorce and lasting power of attorney",
        "api_url": "https://www.gov.uk/api/content/browse/births-deaths-marriages",
        "web_url": "https://www.gov.uk/browse/births-deaths-marriages",
        "locale": "en"
      },
      {
        "content_id": "15cb6f9b-2c05-487c-b716-c3a0ade38165",
        "title": "Business and self-employed",
        "base_path": "/browse/business",
        "description": "Information about starting up and running a business in the UK, including help if you're self employed or a sole trader.",
        "api_url": "https://www.gov.uk/api/content/browse/business",
        "web_url": "https://www.gov.uk/browse/business",
        "locale": "en"
      }
    ],
    "second_level_browse_pages": [
      {
        "content_id": "eaddac26-5db9-4b1b-9e88-5291b1577ed4",
        "title": "Benefits entitlement",
        "base_path": "/browse/benefits/entitlement",
        "description": "When and how benefit payments are made, benefits adviser and benefit fraud",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/entitlement",
        "web_url": "https://www.gov.uk/browse/benefits/entitlement",
        "locale": "en"
      },
      {
        "content_id": "05aadfe6-50d4-4932-bb76-5dfe315a1eb1",
        "title": "Benefits for families",
        "base_path": "/browse/benefits/families",
        "description": "Includes Child Trust Funds, childcare and the Sure Start Maternity Grant",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/families",
        "web_url": "https://www.gov.uk/browse/benefits/families",
        "locale": "en"
      },
      {
        "content_id": "c1e05eb9-98dc-4cc0-985c-0ec3ec66a4e0",
        "title": "Carers and disability benefits",
        "base_path": "/browse/benefits/disability",
        "description": "Includes Disability Living Allowance, Carer's Allowance and Employment and Support Allowance",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/disability",
        "web_url": "https://www.gov.uk/browse/benefits/disability",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Benefits for families",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "mainstream_browse_page",
  "document_type": "mainstream_browse_page"
}

```

### root_page.json
```json
{
  "content_id": "19ed8498-37ed-4c8e-b0bf-accbb2cf5477",
  "base_path": "/browse",
  "description": "Almost everything on GOV.UK.",
  "details": {},
  "format": "mainstream_browse_page",
  "links": {
    "top_level_browse_pages": [
      {
        "content_id": "3c0557d1-518e-4a9b-8920-78524944a28c",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      },
      {
        "content_id": "94ecd143-c60f-4981-a914-242d0c3b0bd1",
        "title": "Births, deaths, marriages and care",
        "base_path": "/browse/births-deaths-marriages",
        "description": "Parenting, civil partnerships, divorce and lasting power of attorney",
        "api_url": "https://www.gov.uk/api/content/browse/births-deaths-marriages",
        "web_url": "https://www.gov.uk/browse/births-deaths-marriages",
        "locale": "en"
      },
      {
        "content_id": "88c8dabd-ff05-4530-99ff-ecf3294a9949",
        "title": "Business and self-employed",
        "base_path": "/browse/business",
        "description": "Information about starting up and running a business in the UK, including help if you're self employed or a sole trader.",
        "api_url": "https://www.gov.uk/api/content/browse/business",
        "web_url": "https://www.gov.uk/browse/business",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Browse",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "mainstream_browse_page",
  "document_type": "mainstream_browse_page"
}

```

### top_level_page.json
```json
{
  "content_id": "bfe85c75-0526-4551-b362-8e9f06a8b36c",
  "base_path": "/browse/benefits",
  "description": "Includes tax credits, eligibility and appeals",
  "details": {
    "second_level_ordering": "alphabetical",
    "ordered_second_level_browse_pages": [
      "f91583d0-be95-4dc8-8268-c2551ff8628a",
      "c7d40a39-bda7-42c3-9287-2c080d10a2a9",
      "9592c019-1792-430d-88df-df9f560a2d08"
    ]
  },
  "format": "mainstream_browse_page",
  "links": {
    "top_level_browse_pages": [
      {
        "content_id": "bfe85c75-0526-4551-b362-8e9f06a8b36c",
        "title": "Benefits",
        "base_path": "/browse/benefits",
        "description": "Includes tax credits, eligibility and appeals",
        "api_url": "https://www.gov.uk/api/content/browse/benefits",
        "web_url": "https://www.gov.uk/browse/benefits",
        "locale": "en"
      },
      {
        "content_id": "d0caf80e-f666-41fa-b1ef-5f898014449d",
        "title": "Births, deaths, marriages and care",
        "base_path": "/browse/births-deaths-marriages",
        "description": "Parenting, civil partnerships, divorce and lasting power of attorney",
        "api_url": "https://www.gov.uk/api/content/browse/births-deaths-marriages",
        "web_url": "https://www.gov.uk/browse/births-deaths-marriages",
        "locale": "en"
      },
      {
        "content_id": "047f41dd-1ebd-4370-8878-1a851b6538db",
        "title": "Business and self-employed",
        "base_path": "/browse/business",
        "description": "Information about starting up and running a business in the UK, including help if you're self employed or a sole trader.",
        "api_url": "https://www.gov.uk/api/content/browse/business",
        "web_url": "https://www.gov.uk/browse/business",
        "locale": "en"
      }
    ],
    "second_level_browse_pages": [
      {
        "content_id": "f91583d0-be95-4dc8-8268-c2551ff8628a",
        "title": "Benefits entitlement",
        "base_path": "/browse/benefits/entitlement",
        "description": "When and how benefit payments are made, benefits adviser and benefit fraud",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/entitlement",
        "web_url": "https://www.gov.uk/browse/benefits/entitlement",
        "locale": "en"
      },
      {
        "content_id": "c7d40a39-bda7-42c3-9287-2c080d10a2a9",
        "title": "Benefits for families",
        "base_path": "/browse/benefits/families",
        "description": "Includes Child Trust Funds, childcare and the Sure Start Maternity Grant",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/families",
        "web_url": "https://www.gov.uk/browse/benefits/families",
        "locale": "en"
      },
      {
        "content_id": "9592c019-1792-430d-88df-df9f560a2d08",
        "title": "Carers and disability benefits",
        "base_path": "/browse/benefits/disability",
        "description": "Includes Disability Living Allowance, Carer's Allowance and Employment and Support Allowance",
        "api_url": "https://www.gov.uk/api/content/browse/benefits/disability",
        "web_url": "https://www.gov.uk/browse/benefits/disability",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Benefits",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "mainstream_browse_page",
  "document_type": "mainstream_browse_page"
}

```

### top_level_page_with_child_pages_in_curated_order.json
```json
{
  "content_id": "e995bd80-cb9b-48dd-bb2c-8e9b2bbefce5",
  "base_path": "/browse/visas-immigration",
  "description": "Visas, settlement, asylum and sponsorship",
  "details": {
    "second_level_ordering": "curated",
    "ordered_second_level_browse_pages": [
      "0529f318-e05a-4798-9e77-a901eedfdb37",
      "8e9576ca-8bbe-450f-9eb9-14bea6f93534",
      "ce9f6198-f7d1-4625-9ae7-9611ffc9caa7"
    ]
  },
  "format": "mainstream_browse_page",
  "links": {
    "top_level_browse_pages": [
      {
        "content_id": "c4997014-d9d7-4ef8-95b3-87049db8efce",
        "title": "Money and tax",
        "base_path": "/browse/tax",
        "description": "Includes VAT, debt and inheritance tax",
        "api_url": "https://www.gov.uk/api/content/browse/tax",
        "web_url": "https://www.gov.uk/browse/tax",
        "locale": "en"
      },
      {
        "content_id": "3b6b5aa1-7fbe-4d86-af77-5412698175fc",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": "Includes renewing passports and travel advice by country",
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en"
      },
      {
        "content_id": "e995bd80-cb9b-48dd-bb2c-8e9b2bbefce5",
        "title": "Visas and immigration",
        "base_path": "/browse/visas-immigration",
        "description": "Visas, settlement, asylum and sponsorship",
        "api_url": "https://www.gov.uk/api/content/browse/visas-immigration",
        "web_url": "https://www.gov.uk/browse/visas-immigration",
        "locale": "en"
      }
    ],
    "second_level_browse_pages": [
      {
        "content_id": "0529f318-e05a-4798-9e77-a901eedfdb37",
        "title": "Work visas",
        "base_path": "/browse/visas-immigration/work-visas",
        "description": "Paid and voluntary work visas (eg Tier 1, Tier 2, Tier 5)",
        "api_url": "https://www.gov.uk/api/content/browse/visas-immigration/work-visas",
        "web_url": "https://www.gov.uk/browse/visas-immigration/work-visas",
        "locale": "en"
      },
      {
        "content_id": "ce9f6198-f7d1-4625-9ae7-9611ffc9caa7",
        "title": "Asylum",
        "base_path": "/browse/visas-immigration/asylum",
        "description": "Claiming asylum as a refugee, the asylum process and support",
        "api_url": "https://www.gov.uk/api/content/browse/visas-immigration/asylum",
        "web_url": "https://www.gov.uk/browse/visas-immigration/asylum",
        "locale": "en"
      },
      {
        "content_id": "8e9576ca-8bbe-450f-9eb9-14bea6f93534",
        "title": "Transit visas",
        "base_path": "/browse/visas-immigration/transit-visas",
        "description": "In transit through the UK: airside, landside or the common travel area",
        "api_url": "https://www.gov.uk/api/content/browse/visas-immigration/transit-visas",
        "web_url": "https://www.gov.uk/browse/visas-immigration/transit-visas",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Benefits",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "mainstream_browse_page",
  "document_type": "mainstream_browse_page"
}

```



