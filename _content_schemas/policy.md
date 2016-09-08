---
layout: content_schema
title:  Policy
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/policy/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>internal_name</strong> <code>string</code></td> <td>An internal name for admin interfaces. Includes parent.</td></tr>
<tr><td><strong>document_noun</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>default_documents_per_page</strong> <code>integer</code></td> <td></td></tr>
<tr><td><strong>email_signup_enabled</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>default_order</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>filter</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>facets</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>human_readable_finder_format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>show_summaries</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>signup_link</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>summary</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>nation_applicability</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>applies_to</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>alternative_policies</strong> <code>array</code></td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>policy</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/policy/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>people</strong> </td> <td></td></tr>
<tr><td><strong>working_groups</strong> </td> <td></td></tr>
<tr><td><strong>lead_organisations</strong> </td> <td>DEPRECATED: A subset of organisations that should be emphasised in relation to this content item. All organisations specified here should also be part of the organisations array.</td></tr>
<tr><td><strong>related</strong> </td> <td></td></tr>
<tr><td><strong>email_alert_signup</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/policy/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>internal_name</strong> <code>string</code></td> <td>An internal name for admin interfaces. Includes parent.</td></tr>
<tr><td><strong>document_noun</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>default_documents_per_page</strong> <code>integer</code></td> <td></td></tr>
<tr><td><strong>email_signup_enabled</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>default_order</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>filter</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>facets</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>human_readable_finder_format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>show_summaries</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>signup_link</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>summary</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>nation_applicability</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>applies_to</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>alternative_policies</strong> <code>array</code></td> <td></td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>people</strong> </td> <td></td></tr>
<tr><td><strong>working_groups</strong> </td> <td></td></tr>
<tr><td><strong>lead_organisations</strong> </td> <td></td></tr>
<tr><td><strong>related</strong> </td> <td></td></tr>
<tr><td><strong>email_alert_signup</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr>
<tr><td><strong>taxons</strong> </td> <td></td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>topics</strong> </td> <td></td></tr>
<tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>parent</strong> </td> <td></td></tr>
<tr><td><strong>policies</strong> </td> <td></td></tr>
<tr><td><strong>policy_areas</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>policy</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### minimal_policy_area.json
```json
{
  "content_id": "2f675206-25cc-482f-9eb9-7c25a555ce7f",
  "base_path": "/government/policies/minimal-benefits-reform",
  "title": "Minimal benefits reform",
  "description": "",
  "format": "policy",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-03-10T11:55:11.570Z",
  "public_updated_at": "2015-03-10T11:55:11.066+00:00",
  "details": {
    "document_noun": "document",
    "filter": {
      "policies": [
        "benefits-reform"
      ]
    },
    "facets": []
  },
  "links": {
    "organisations": [],
    "people": [],
    "working_groups": [],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "2054b5e5-8d58-456b-8832-66c0d2b72565",
        "title": "Minimal Benefits Reform",
        "base_path": "/government/policies/minimal-benefits-reform/email-signup",
        "api_url": "https://www.gov.uk/api/content/government/policies/minimal-benefits-reform/email-signup",
        "web_url": "https://www.gov.uk/government/policies/minimal-benefits-reform/email-signup",
        "locale": "en"
      }
    ]
  },
  "schema_name": "policy",
  "document_type": "policy"
}

```

### policy_area.json
```json
{
  "content_id": "f8c3682c-3a88-4f35-afba-3607384e39e6",
  "base_path": "/government/policies/benefits-reform",
  "title": "Benefits Reform",
  "description": "",
  "format": "policy",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-03-10T11:55:11.570Z",
  "public_updated_at": "2015-03-10T11:55:11.066+00:00",
  "details": {
    "document_noun": "document",
    "default_documents_per_page": 10,
    "email_signup_enabled": false,
    "filter": {
      "policies": [
        "benefits-reform"
      ]
    },
    "human_readable_finder_format": "Policy",
    "signup_link": "",
    "summary": "The government believes that the current benefits system is too complex, and there are insufficient incentives to encourage people on benefits to start paid work or increase their hours.",
    "show_summaries": false,
    "emphasised_organisations": ["a4759607-4fd8-4cf0-9d56-af9d14a71162"],
    "facets": [
      {
        "key": "is_historic",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "government_name",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "public_timestamp",
        "name": "Published",
        "short_name": "Updated",
        "type": "date",
        "display_as_result_metadata": true,
        "filterable": true
      },
      {
        "key": "organisations",
        "short_name": "From",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "display_type",
        "short_name": "Type",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      }
    ]
  },
  "links": {
    "organisations": [
      {
        "content_id": "a4759607-4fd8-4cf0-9d56-af9d14a71162",
        "title": "Department for Work and Pensions",
        "base_path": "/government/organisations/department-for-work-and-pensions",
        "api_url": "https://www.gov.uk/api/organisations/department-for-work-and-pensions",
        "web_url": "https://www.gov.uk/government/organisations/department-for-work-and-pensions",
        "locale": "en"
      }
    ],
    "people": [],
    "working_groups": [],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "69938c64-4bb3-4b4f-814b-e73cb71831ef",
        "title": "Benefits Reform",
        "base_path": "/government/policies/benefits-reform/email-signup",
        "api_url": "https://www.gov.uk/api/content/government/policies/benefits-reform/email-signup",
        "web_url": "https://www.gov.uk/government/policies/benefits-reform/email-signup",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "f8c3682c-3a88-4f35-afba-3607384e39e6",
        "title": "Benefits Reform",
        "base_path": "/government/policies/benefits-reform",
        "api_url": "https://www.gov.uk/api/content/government/policies/benefits-reform",
        "web_url": "https://www.gov.uk/government/policies/benefits-reform",
        "locale": "en"
      }
    ]
  },
  "schema_name": "policy",
  "document_type": "policy"
}

```

### policy_programme.json
```json
{
  "content_id": "6c767453-c328-4cb4-8812-fae88a250bb3",
  "base_path": "/government/policies/universal-credit",
  "title": "Universal Credit",
  "description": "",
  "format": "policy",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-03-10T11:55:11.570Z",
  "public_updated_at": "2015-03-10T11:55:11.066+00:00",
  "details": {
    "document_noun": "document",
    "email_signup_enabled": false,
    "filter": {
      "policies": [
        "universal-credit"
      ]
    },
    "human_readable_finder_format": "Policy",
    "signup_link": "",
    "summary": "Universal Credit brings together 6 benefits for people who are out of work or on a low income into a single payment. It's being introduced in stages, starting in October 2013. By the end of 2017 it's expected to be available across England and Wales.",
    "show_summaries": false,
    "emphasised_organisations": ["9417d532-a080-4856-9a0f-08b1d9d78c98"],
    "facets": [
      {
        "key": "is_historic",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "government_name",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "public_timestamp",
        "name": "Published",
        "short_name": "Updated",
        "type": "date",
        "display_as_result_metadata": true,
        "filterable": true
      },
      {
        "key": "organisations",
        "short_name": "From",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "display_type",
        "short_name": "Type",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      }
    ]
  },
  "links": {
    "organisations": [
      {
        "content_id": "9417d532-a080-4856-9a0f-08b1d9d78c98",
        "title": "Department for Work and Pensions",
        "base_path": "/government/organisations/department-for-work-and-pensions",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-work-and-pensions",
        "web_url": "https://www.gov.uk/government/organisations/department-for-work-and-pensions",
        "locale": "en"
      }
    ],
    "people": [
      {
        "content_id": "295ce3e3-a68b-4952-8f13-72ea62f5c16b",
        "title": "George Dough",
        "base_path": "/government/people/george-dough",
        "api_url": "https://www.gov.uk/api/content/government/people/george-dough",
        "web_url": "https://www.gov.uk/people/george-dough",
        "locale": "en"
      }
    ],
    "working_groups": [
      {
        "content_id": "248de49c-da2a-4142-9310-bcea244c6dce",
        "title": "Medical Advisory Group",
        "base_path": "/government/groups/medical-advisory-group",
        "api_url": "https://www.gov.uk/api/content/government/groups/medical-advisory-group",
        "web_url": "https://www.gov.uk/government/groups/medical-advisory-group",
        "locale": "en"
      }
    ],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "a0f12caf-2555-4bfc-9c85-0c8ad4c1e766",
        "title": "Universal Credit",
        "base_path": "/government/policies/universal-credit/email-signup",
        "api_url": "https://www.gov.uk/api/content/government/policies/universal-credit/email-signup",
        "web_url": "https://www.gov.uk/government/policies/universal-credit/email-signup",
        "locale": "en"
      }
    ],
    "policy_areas": [
      {
        "content_id": "848b8564-328c-4787-bebb-9e1b60ccf0d7",
        "title": "Benefits Reform",
        "base_path": "/government/policies/benefits-reform",
        "api_url": "https://www.gov.uk/api/content/government/policies/benefits-reform",
        "web_url": "https://www.gov.uk/government/policies/benefits-reform",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "6c767453-c328-4cb4-8812-fae88a250bb3",
        "title": "Unveirsal Credit",
        "base_path": "/government/policies/universal-credit",
        "api_url": "https://www.gov.uk/api/content/government/policies/universal-credit",
        "web_url": "https://www.gov.uk/government/policies/universal-credit",
        "locale": "en"
      }
    ]
  },
  "schema_name": "policy",
  "document_type": "policy"
}

```

### policy_with_inapplicable_nations.json
```json
{
  "content_id": "c3fee553-1891-411b-8d00-4aefbe86e40a",
  "base_path": "/government/policies/keeping-northern-ireland-safe",
  "title": "Keeping Northern Ireland safe",
  "description": "",
  "format": "policy",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-03-10T11:55:11.570Z",
  "public_updated_at": "2015-03-10T11:55:11.066+00:00",
  "details": {
    "document_noun": "document",
    "email_signup_enabled": false,
    "filter": {
      "policies": [
        "keeping-northern-ireland-safe"
      ]
    },
    "human_readable_finder_format": "Policy",
    "signup_link": "",
    "summary": "While day-to-day policing and justice functions are devolved to the Northern Ireland Executive, the UK government retains responsibility for national security issues in Northern Ireland.",
    "show_summaries": false,
    "emphasised_organisations": ["8927158f-e4b2-4361-b55d-02de7599b220"],
    "facets": [
      {
        "key": "is_historic",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "government_name",
        "display_as_result_metadata": true,
        "filterable": false
      }
    ],
    "nation_applicability": {
      "applies_to": [
        "england",
        "northern_ireland"
      ],
      "alternative_policies": [
        {
          "nation": "scotland",
          "alt_policy_url": "http://www.gov.scot/"
        },
        {
          "nation": "wales",
          "alt_policy_url": "http://wales.gov.uk/"
        }
      ]
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "8927158f-e4b2-4361-b55d-02de7599b220",
        "title": "Northern Ireland Office",
        "base_path": "/government/organisations/northern-ireland-office",
        "api_url": "https://www.gov.uk/api/organisations/northern-ireland-office",
        "web_url": "https://www.gov.uk/government/organisations/northern-ireland-office",
        "locale": "en"
      }
    ],
    "people": [
      {
        "content_id": "70dc1901-2d36-4c3d-98ee-e1d5587a5ba9",
        "title": "George Dough",
        "base_path": "/government/people/george-dough",
        "api_url": "https://www.gov.uk/api/government/people/george-dough",
        "web_url": "https://www.gov.uk/people/george-dough",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "c3fee553-1891-411b-8d00-4aefbe86e40a",
        "title": "Keeping Northern Ireland safe",
        "base_path": "/government/policies/keeping-northern-ireland-safe",
        "api_url": "https://www.gov.uk/api/content/government/policies/keeping-northern-ireland-safe",
        "web_url": "https://www.gov.uk/government/policies/keeping-northern-ireland-safe",
        "locale": "en"
      }
    ]
  },
  "schema_name": "policy",
  "document_type": "policy"
}

```



