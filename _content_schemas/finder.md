---
layout: content_schema
title:  Finder
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/finder/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>beta</strong> <code>boolean</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>beta_message</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>document_noun</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>default_documents_per_page</strong> <code>integer</code></td> <td></td></tr>
<tr><td><strong>logo_path</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>default_order</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>filter</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>reject</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>facets</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>format_name</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>show_summaries</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>signup_link</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>summary</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>finder</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/finder/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/finder/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>beta</strong> <code>boolean</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>beta_message</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>document_noun</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>default_documents_per_page</strong> <code>integer</code></td> <td></td></tr>
<tr><td><strong>logo_path</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>default_order</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>filter</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>reject</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>facets</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>format_name</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>show_summaries</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>signup_link</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>summary</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>finder</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### aaib-reports.json
```json
{
  "content_id": "68518b2a-bb48-4807-99d6-de31d39b3810",
  "base_path": "/aaib-reports",
  "title": "Air Accidents Investigation Branch reports",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:18.202Z",
  "public_updated_at": "2015-04-29T09:22:41.000+00:00",
  "details": {
    "beta": true,
    "document_noun": "report",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Commercial - fixed wing",
            "value": "commercial-fixed-wing"
          },
          {
            "label": "Commercial - rotorcraft",
            "value": "commercial-rotorcraft"
          },
          {
            "label": "General aviation - fixed wing",
            "value": "general-aviation-fixed-wing"
          },
          {
            "label": "General aviation - rotorcraft",
            "value": "general-aviation-rotorcraft"
          },
          {
            "label": "Sport aviation and balloons",
            "value": "sport-aviation-and-balloons"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "aircraft_category",
        "name": "Aircraft category",
        "preposition": "in aircraft category",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Annual safety report",
            "value": "annual-safety-report"
          },
          {
            "label": "Bulletin - Correspondence investigation",
            "value": "correspondence-investigation"
          },
          {
            "label": "Bulletin - Field investigation",
            "value": "field-investigation"
          },
          {
            "label": "Bulletin - Pre-1997 uncategorised monthly report",
            "value": "pre-1997-monthly-report"
          },
          {
            "label": "Foreign report",
            "value": "foreign-report"
          },
          {
            "label": "Formal report",
            "value": "formal-report"
          },
          {
            "label": "Special bulletin",
            "value": "special-bulletin"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "report_type",
        "name": "Report type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "date_of_occurrence",
        "name": "Date of occurrence",
        "preposition": "occurred",
        "short_name": "Occurred",
        "type": "date"
      },
      {
        "display_as_result_metadata": false,
        "filterable": false,
        "key": "aircraft_type",
        "name": "Aircraft type",
        "type": "text"
      },
      {
        "display_as_result_metadata": false,
        "filterable": false,
        "key": "location",
        "name": "Location",
        "type": "text"
      },
      {
        "display_as_result_metadata": false,
        "filterable": false,
        "key": "registration",
        "name": "Registration",
        "type": "text"
      }
    ],
    "filter": {
      "document_type": "aaib_report"
    },
    "format_name": "Air Accidents Investigation Branch report",
    "show_summaries": true
  },
  "links": {
    "email_alert_signup": [],
    "organisations": [
      {
        "content_id": "28b9541f-0414-405c-8eb0-16a6fbaa800f",
        "title": "Air Accidents Investigation Branch",
        "base_path": "/government/organisations/air-accidents-investigation-branch",
        "api_url": "https://www.gov.uk/api/content/government/organisations/air-accidents-investigation-branch",
        "web_url": "https://www.gov.uk/government/organisations/air-accidents-investigation-branch",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "68518b2a-bb48-4807-99d6-de31d39b3810",
        "title": "Air Accidents Investigation Branch reports",
        "base_path": "/aaib-reports",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/aaib-reports",
        "web_url": "https://www.gov.uk/aaib-reports",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### all_policies.json
```json
{
  "content_id": "3f68ef63-252c-4982-8569-a01a911e7397",
  "base_path": "/government/policies/all",
  "title": "All policy content",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-28T13:31:24.082Z",
  "public_updated_at": "2015-07-28T13:29:02.000+00:00",
  "phase": "alpha",
  "details": {
    "document_noun": "documents",
    "facets": [],
    "filter": {},
    "reject": {
      "policies": [
        "_MISSING"
      ]
    },
    "show_summaries": false
  },
  "links": {
    "email_alert_signup": [],
    "organisations": [],
    "related": [],
    "available_translations": [
      {
        "content_id": "3f68ef63-252c-4982-8569-a01a911e7397",
        "title": "All policy content",
        "base_path": "/government/policies/all",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/government/policies/all",
        "web_url": "https://www.gov.uk/government/policies/all",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### asylum-support-decisions.json
```json
{
  "content_id": "6a0da4c9-1969-4c2f-972c-88b5497c2b65",
  "base_path": "/asylum-support-decisions",
  "title": "First-tier Tribunal (Asylum Support) decisions",
  "description": "Find decisions by the First-tier Tribunal (Asylum Support)",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-09-02T15:56:15.163Z",
  "public_updated_at": "2015-09-02T10:06:06.000+00:00",
  "details": {
    "beta": true,
    "document_noun": "decision",
    "filter": {
      "document_type": "asylum_support_decision"
    },
    "format_name": "First-tier Tribunal (Asylum Support) decision",
    "show_summaries": true,
    "facets": [
      {
        "key": "tribunal_decision_judges",
        "name": "Judges",
        "type": "text",
        "preposition": "by judge",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Alan Ponting",
            "value": "alan-ponting"
          },
          {
            "label": "Sally Verity Smith",
            "value": "sally-verity-smith"
          }
        ]
      },
      {
        "key": "tribunal_decision_judges_name",
        "name": "Judges name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_category",
        "name": "Category",
        "type": "text",
        "preposition": "categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Section 95 (asylum-seekers)",
            "value": "section-95-asylum-seekers"
          },
          {
            "label": "Section 4(2) (failed asylum seekers)",
            "value": "section-4-2-failed-asylum-seekers"
          }
        ]
      },
      {
        "key": "tribunal_decision_category_name",
        "name": "Category name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_sub_category",
        "name": "Sub-category",
        "type": "text",
        "preposition": "sub-categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Section 95 - jurisdiction",
            "value": "section-95-jurisdiction"
          },
          {
            "label": "Section 4(2) - jurisdiction",
            "value": "section-4-2-jurisdiction"
          }
        ]
      },
      {
        "key": "tribunal_decision_sub_category_name",
        "name": "Sub-category name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_landmark",
        "name": "Landmark",
        "type": "text",
        "display_as_result_metadata": false,
        "filterable": false,
        "allowed_values": [
          {
            "label": "Not Landmark",
            "value": "not-landmark"
          },
          {
            "label": "Landmark",
            "value": "landmark"
          }
        ]
      },
      {
        "key": "tribunal_decision_landmark_name",
        "name": "Landmark name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_reference_number",
        "name": "Reference number",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_decision_date",
        "name": "Decision date",
        "short_name": "Decided",
        "type": "date",
        "preposition": "was decided",
        "display_as_result_metadata": true,
        "filterable": true
      }
    ]
  },
  "links": {
    "organisations": [],
    "related": [],
    "email_alert_signup": [],
    "available_translations": [
      {
        "content_id": "6a0da4c9-1969-4c2f-972c-88b5497c2b65",
        "title": "First-tier Tribunal (Asylum Support) decisions",
        "base_path": "/asylum-support-decisions",
        "description": "Find decisions by the First-tier Tribunal (Asylum Support)",
        "api_url": "http://content-store.dev.gov.uk/content/asylum-support-decisions",
        "web_url": "http://www.dev.gov.uk/asylum-support-decisions",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### cma-cases.json
```json
{
  "content_id": "3631309f-b9c0-4942-afe6-3ae3819fc6a1",
  "base_path": "/cma-cases",
  "title": "Competition and Markets Authority cases",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:38.225Z",
  "public_updated_at": "2015-04-30T10:41:26.000+00:00",
  "details": {
    "beta": false,
    "document_noun": "case",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "CA98 and civil cartels",
            "value": "ca98-and-civil-cartels"
          },
          {
            "label": "Criminal cartels",
            "value": "criminal-cartels"
          },
          {
            "label": "Markets",
            "value": "markets"
          },
          {
            "label": "Mergers",
            "value": "mergers"
          },
          {
            "label": "Consumer enforcement",
            "value": "consumer-enforcement"
          },
          {
            "label": "Regulatory references and appeals",
            "value": "regulatory-references-and-appeals"
          },
          {
            "label": "Reviews of orders and undertakings",
            "value": "review-of-orders-and-undertakings"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "case_type",
        "name": "Case type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Open",
            "value": "open"
          },
          {
            "label": "Closed",
            "value": "closed"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "case_state",
        "name": "Case state",
        "preposition": "which are",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Aerospace",
            "value": "aerospace"
          },
          {
            "label": "Agriculture, environment and natural resources",
            "value": "agriculture-environment-and-natural-resources"
          },
          {
            "label": "Building and construction",
            "value": "building-and-construction"
          },
          {
            "label": "Chemicals",
            "value": "chemicals"
          },
          {
            "label": "Clothing, footwear and fashion",
            "value": "clothing-footwear-and-fashion"
          },
          {
            "label": "Communications",
            "value": "communications"
          },
          {
            "label": "Defence",
            "value": "defence"
          },
          {
            "label": "Distribution and service industries",
            "value": "distribution-and-service-industries"
          },
          {
            "label": "Electronics",
            "value": "electronics-industry"
          },
          {
            "label": "Energy",
            "value": "energy"
          },
          {
            "label": "Engineering",
            "value": "engineering"
          },
          {
            "label": "Financial services",
            "value": "financial-services"
          },
          {
            "label": "Fire, police and security",
            "value": "fire-police-and-security"
          },
          {
            "label": "Food manufacturing",
            "value": "food-manufacturing"
          },
          {
            "label": "Giftware, jewellery and tableware",
            "value": "giftware-jewellery-and-tableware"
          },
          {
            "label": "Healthcare and medical equipment",
            "value": "healthcare-and-medical-equipment"
          },
          {
            "label": "Household goods, furniture and furnishings",
            "value": "household-goods-furniture-and-furnishings"
          },
          {
            "label": "Mineral extraction, mining and quarrying",
            "value": "mineral-extraction-mining-and-quarrying"
          },
          {
            "label": "Motor industry",
            "value": "motor-industry"
          },
          {
            "label": "Oil and gas refining and petrochemicals",
            "value": "oil-and-gas-refining-and-petrochemicals"
          },
          {
            "label": "Paper printing and packaging",
            "value": "paper-printing-and-packaging"
          },
          {
            "label": "Pharmaceuticals",
            "value": "pharmaceuticals"
          },
          {
            "label": "Public markets",
            "value": "public-markets"
          },
          {
            "label": "Recreation and leisure",
            "value": "recreation-and-leisure"
          },
          {
            "label": "Retail and wholesale",
            "value": "retail-and-wholesale"
          },
          {
            "label": "Telecommunications",
            "value": "telecommunications"
          },
          {
            "label": "Textiles",
            "value": "textiles"
          },
          {
            "label": "Transport",
            "value": "transport"
          },
          {
            "label": "Utilities",
            "value": "utilities"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "market_sector",
        "name": "Market sector",
        "preposition": "about",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "CA98 - no grounds for action",
            "value": "ca98-no-grounds-for-action-non-infringement"
          },
          {
            "label": "CA98 - infringement Chapter I",
            "value": "ca98-infringement-chapter-i"
          },
          {
            "label": "CA98 - infringement Chapter II",
            "value": "ca98-infringement-chapter-ii"
          },
          {
            "label": "CA98 - administrative priorities",
            "value": "ca98-administrative-priorities"
          },
          {
            "label": "CA98 - commitments",
            "value": "ca98-commitment"
          },
          {
            "label": "Criminal cartels - verdict",
            "value": "criminal-cartels-verdict"
          },
          {
            "label": "Markets - phase 1 no enforcement action",
            "value": "markets-phase-1-no-enforcement-action"
          },
          {
            "label": "Markets - phase 1 undertakings in lieu of reference",
            "value": "markets-phase-1-undertakings-in-lieu-of-reference"
          },
          {
            "label": "Markets - phase 1 referral",
            "value": "markets-phase-1-referral"
          },
          {
            "label": "Mergers - phase 1 clearance",
            "value": "mergers-phase-1-clearance"
          },
          {
            "label": "Mergers - phase 1 clearance with undertakings in lieu",
            "value": "mergers-phase-1-clearance-with-undertakings-in-lieu"
          },
          {
            "label": "Mergers - phase 1 referral",
            "value": "mergers-phase-1-referral"
          },
          {
            "label": "Mergers - phase 1 found not to qualify",
            "value": "mergers-phase-1-found-not-to-qualify"
          },
          {
            "label": "Mergers - phase 1 public interest intervention",
            "value": "mergers-phase-1-public-interest-interventions"
          },
          {
            "label": "Markets - phase 2 clearance - no adverse effect on competition",
            "value": "markets-phase-2-clearance-no-adverse-effect-on-competition"
          },
          {
            "label": "Markets - phase 2 adverse effect on competition leading to remedies",
            "value": "markets-phase-2-adverse-effect-on-competition-leading-to-remedies"
          },
          {
            "label": "Markets - phase 2 decision to dispense with procedural obligations",
            "value": "markets-phase-2-decision-to-dispense-with-procedural-obligations"
          },
          {
            "label": "Mergers - phase 2 clearance",
            "value": "mergers-phase-2-clearance"
          },
          {
            "label": "Mergers - phase 2 clearance with remedies",
            "value": "mergers-phase-2-clearance-with-remedies"
          },
          {
            "label": "Mergers - phase 2 prohibition",
            "value": "mergers-phase-2-prohibition"
          },
          {
            "label": "Mergers - phase 2 cancellation",
            "value": "mergers-phase-2-cancellation"
          },
          {
            "label": "Consumer enforcement - no formal action",
            "value": "consumer-enforcement-no-action"
          },
          {
            "label": "Consumer enforcement - court order",
            "value": "consumer-enforcement-court-order"
          },
          {
            "label": "Consumer enforcement - undertakings",
            "value": "consumer-enforcement-undertakings"
          },
          {
            "label": "Consumer enforcement - changes to business practices agreed",
            "value": "consumer-enforcement-changes-to-business-practices-agreed"
          },
          {
            "label": "Regulatory references and appeals - final determination",
            "value": "regulatory-references-and-appeals-final-determination"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "outcome_type",
        "name": "Outcome",
        "preposition": "with outcome",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": false,
        "key": "opened_date",
        "name": "Opened",
        "short_name": "Opened",
        "type": "date"
      },
      {
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "closed_date",
        "name": "Closed",
        "preposition": "closed",
        "short_name": "Closed",
        "type": "date"
      }
    ],
    "filter": {
      "document_type": "cma_case"
    },
    "format_name": "Competition and Markets Authority case",
    "show_summaries": false
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "b269c38b-6e5a-4258-9735-66389749e341",
        "title": "Competition and Markets Authority cases",
        "base_path": "/cma-cases/email-signup",
        "description": "You'll get an email each time a case is updated or a new case is published.",
        "api_url": "https://www.gov.uk/api/content/cma-cases/email-signup",
        "web_url": "https://www.gov.uk/cma-cases/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "271e858a-6b44-4c9c-9282-6f599d268895",
        "title": "Competition and Markets Authority",
        "base_path": "/government/organisations/competition-and-markets-authority",
        "api_url": "https://www.gov.uk/api/content/government/organisations/competition-and-markets-authority",
        "web_url": "https://www.gov.uk/government/organisations/competition-and-markets-authority",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "3631309f-b9c0-4942-afe6-3ae3819fc6a1",
        "title": "Competition and Markets Authority cases",
        "base_path": "/cma-cases",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/cma-cases",
        "web_url": "https://www.gov.uk/cma-cases",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### contacts.json
```json
{
  "content_id": "07ab2c1d-1a89-46a8-b96a-4a0f8065bec1",
  "base_path": "/government/organisations/hm-cheese-biscuits/contact",
  "format": "finder",
  "title": "HM Cheese & Biscuits Contacts",
  "description": "",
  "public_updated_at": "2015-03-05T16:48:34.000Z",
  "details": {
    "document_noun": "contact",
    "filter": {
      "document_type": "contact",
      "organisations": [
        "hm-cheese-biscuits"
      ]
    },
    "facets": [
      {
        "key": "contact_group",
        "name": "Topic",
        "filterable": true,
        "type": "text",
        "display_as_result_metadata": true,
        "preposition": "in topic",
        "allowed_values": [
          {
            "label": "Stinking Bishop",
            "value": "stinking-bishop"
          },
          {
            "label": "Digestives",
            "value": "digestives"
          },
          {
            "label": "Quince",
            "value": "quince"
          }
        ]
      }
    ]
  },
  "links": {
    "organisations": [
      {
        "content_id": "378d0b6a-36e5-4a74-8495-215187ab8316",
        "title": "HM Cheese & Biscuits",
        "base_path": "/government/organisations/hm-cheese-biscuits",
        "api_url": "https://www.gov.uk/api/content/government/organisations/government/organisations/hm-cheese-biscuits",
        "web_url": "https://www.gov.uk/government/organisations/government/organisations/hm-cheese-biscuits",
        "locale": "en"
      }
    ],
    "related": []
  },
  "locale": "en",
  "schema_name": "finder",
  "document_type": "finder"
}

```

### countryside-stewardship-grants.json
```json
{
  "content_id": "49e05ad1-8c76-49a1-b017-6b113a6bb7d5",
  "base_path": "/countryside-stewardship-grants",
  "title": "Countryside Stewardship grants",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:36.897Z",
  "public_updated_at": "2015-07-07T13:38:31.000+00:00",
  "details": {
    "beta": true,
    "document_noun": "grant",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Option",
            "value": "option"
          },
          {
            "label": "Capital item",
            "value": "capital-item"
          },
          {
            "label": "Supplement",
            "value": "supplement"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "grant_type",
        "name": "Grant type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Arable land",
            "value": "arable-land"
          },
          {
            "label": "Boundaries",
            "value": "boundaries"
          },
          {
            "label": "Coast",
            "value": "coast"
          },
          {
            "label": "Educational access",
            "value": "educational-access"
          },
          {
            "label": "Flood risk",
            "value": "flood-risk"
          },
          {
            "label": "Grassland",
            "value": "grassland"
          },
          {
            "label": "Historic environment",
            "value": "historic-environment"
          },
          {
            "label": "Livestock management",
            "value": "livestock-management"
          },
          {
            "label": "Organic land",
            "value": "organic-land"
          },
          {
            "label": "Priority habitats",
            "value": "priority-habitats"
          },
          {
            "label": "Trees (non-woodland)",
            "value": "trees-non-woodland"
          },
          {
            "label": "Uplands",
            "value": "uplands"
          },
          {
            "label": "Vegetation control",
            "value": "vegetation-control"
          },
          {
            "label": "Water quality",
            "value": "water-quality"
          },
          {
            "label": "Wildlife package",
            "value": "wildlife-package"
          },
          {
            "label": "Woodland",
            "value": "woodland"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "land_use",
        "name": "Land use",
        "preposition": "for",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Higher Tier",
            "value": "higher-tier"
          },
          {
            "label": "Mid Tier",
            "value": "mid-tier"
          },
          {
            "label": "Standalone capital items",
            "value": "standalone-capital-items"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "tiers_or_standalone_items",
        "name": "Tiers or standalone items",
        "preposition": "for",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Up to £100",
            "value": "up-to-100"
          },
          {
            "label": "£101 to £200",
            "value": "101-to-200"
          },
          {
            "label": "£201 to £300",
            "value": "201-to-300"
          },
          {
            "label": "£301 to £400",
            "value": "301-to-400"
          },
          {
            "label": "£401 to £500",
            "value": "401-to-500"
          },
          {
            "label": "More than £500",
            "value": "more-than-500"
          },
          {
            "label": "Up to 50% actual costs",
            "value": "up-to-50-actual-costs"
          },
          {
            "label": "More than 50% actual costs",
            "value": "more-than-50-actual-costs"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "funding_amount",
        "name": "Funding (per unit per year)",
        "preposition": "of",
        "type": "text"
      }
    ],
    "filter": {
      "document_type": "countryside_stewardship_grant"
    },
    "format_name": "Countryside Stewardship grant",
    "show_summaries": false
  },
  "links": {
    "email_alert_signup": [],
    "organisations": [
      {
        "content_id": "fc483d53-551a-4bc0-952b-6bc0d900b31b",
        "title": "Natural England",
        "base_path": "/government/organisations/natural-england",
        "api_url": "https://www.gov.uk/api/content/government/organisations/natural-england",
        "web_url": "https://www.gov.uk/government/organisations/natural-england",
        "locale": "en"
      },
      {
        "content_id": "cb135a46-9a2b-4cf4-8c60-7448ae7de751",
        "title": "Department for Environment, Food & Rural Affairs",
        "base_path": "/government/organisations/department-for-environment-food-rural-affairs",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-environment-food-rural-affairs",
        "web_url": "https://www.gov.uk/government/organisations/department-for-environment-food-rural-affairs",
        "locale": "en"
      },
      {
        "content_id": "a20c4a89-8133-4cb9-a93f-049115865524",
        "title": "Forestry Commission",
        "base_path": "/government/organisations/forestry-commission",
        "api_url": "https://www.gov.uk/api/content/government/organisations/forestry-commission",
        "web_url": "https://www.gov.uk/government/organisations/forestry-commission",
        "locale": "en"
      }
    ],
    "related": [
      {
        "content_id": "e3bd0d0b-5c06-4678-91d6-a0d18f16ae2c",
        "title": "Countryside Stewardship manual",
        "base_path": "/guidance/countryside-stewardship-manual",
        "description": "This manual provides the information needed to apply for the new Countryside Stewardship scheme.",
        "api_url": "https://www.gov.uk/api/content/guidance/countryside-stewardship-manual",
        "web_url": "https://www.gov.uk/guidance/countryside-stewardship-manual",
        "locale": "en"
      },
      {
        "content_id": "2d704772-e145-4d21-a165-d5d102732411",
        "title": "Countryside Stewardship manual and grants: print versions",
        "base_path": "/government/publications/countryside-stewardship-manual-print-version",
        "description": "Find out about the Countryside Stewardship options and capital items requirements, and how to apply.",
        "api_url": "https://www.gov.uk/api/content/government/publications/countryside-stewardship-manual-print-version",
        "web_url": "https://www.gov.uk/government/publications/countryside-stewardship-manual-print-version",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "49e05ad1-8c76-49a1-b017-6b113a6bb7d5",
        "title": "Countryside Stewardship grants",
        "base_path": "/countryside-stewardship-grants",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/countryside-stewardship-grants",
        "web_url": "https://www.gov.uk/countryside-stewardship-grants",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### drug-device-alerts.json
```json
{
  "content_id": "429bd6e5-fbdf-4e3d-b6ed-1ef6471bf749",
  "base_path": "/drug-device-alerts",
  "title": "Alerts and recalls for drugs and medical devices",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:22.124Z",
  "public_updated_at": "2015-04-30T10:41:26.000+00:00",
  "details": {
    "beta": false,
    "document_noun": "alert",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Drug alert",
            "value": "drugs"
          },
          {
            "label": "Medical device alert",
            "value": "devices"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "alert_type",
        "name": "Alert type",
        "preposition": "for",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Anaesthetics",
            "value": "anaesthetics"
          },
          {
            "label": "Cardiology",
            "value": "cardiology"
          },
          {
            "label": "Care home staff",
            "value": "care-home-staff"
          },
          {
            "label": "Cosmetic surgery",
            "value": "cosmetic-surgery"
          },
          {
            "label": "Critical care",
            "value": "critical-care"
          },
          {
            "label": "Dentistry",
            "value": "dentistry"
          },
          {
            "label": "General practice",
            "value": "general-practice"
          },
          {
            "label": "General surgery",
            "value": "general-surgery"
          },
          {
            "label": "Haematology and oncology",
            "value": "haematology-oncology"
          },
          {
            "label": "Infection prevention",
            "value": "infection-prevention"
          },
          {
            "label": "Obstetrics and gynaecology",
            "value": "obstetrics-gynaecology"
          },
          {
            "label": "Ophthalmology",
            "value": "ophthalmology"
          },
          {
            "label": "Orthopaedics",
            "value": "orthopaedics"
          },
          {
            "label": "Paediatrics",
            "value": "paediatrics"
          },
          {
            "label": "Pathology",
            "value": "pathology"
          },
          {
            "label": "Pharmacy",
            "value": "pharmacy"
          },
          {
            "label": "Physiotherapy and occupational therapy",
            "value": "physiotherapy-occupational-therapy"
          },
          {
            "label": "Radiology",
            "value": "radiology"
          },
          {
            "label": "Renal medicine",
            "value": "renal-medicine"
          },
          {
            "label": "Theatre practitioners",
            "value": "theatre-practitioners"
          },
          {
            "label": "Urology",
            "value": "urology"
          },
          {
            "label": "Vascular and cardiac surgery",
            "value": "vascular-cardiac-surgery"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "medical_specialism",
        "name": "Medical specialism",
        "preposition": "about",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "issued_date",
        "name": "Issued",
        "preposition": "issued",
        "short_name": "Issued",
        "type": "date"
      }
    ],
    "filter": {
      "document_type": "medical_safety_alert"
    },
    "format_name": "Medical safety alert",
    "show_summaries": true,
    "signup_link": "/government/organisations/medicines-and-healthcare-products-regulatory-agency/email-signup"
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "ea3bee2c-dbc6-4b55-a1bc-866e5e110f99",
        "title": "Drug alerts and medical device alerts",
        "base_path": "/drug-device-alerts/email-signup",
        "description": "You'll get an email each time an alert is updated or a new alert is published.",
        "api_url": "https://www.gov.uk/api/content/drug-device-alerts/email-signup",
        "web_url": "https://www.gov.uk/drug-device-alerts/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "399503ac-569f-40c3-8b0b-8aa5fb52da20",
        "title": "Medicines and Healthcare products Regulatory Agency",
        "base_path": "/government/organisations/medicines-and-healthcare-products-regulatory-agency",
        "api_url": "https://www.gov.uk/api/content/government/organisations/medicines-and-healthcare-products-regulatory-agency",
        "web_url": "https://www.gov.uk/government/organisations/medicines-and-healthcare-products-regulatory-agency",
        "locale": "en"
      }
    ],
    "related": [
      {
        "content_id": "97397fb6-d189-4878-9091-0e4610c3202f",
        "title": "Drug Safety Update",
        "base_path": "/drug-safety-update",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/drug-safety-update",
        "web_url": "https://www.gov.uk/drug-safety-update",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "429bd6e5-fbdf-4e3d-b6ed-1ef6471bf749",
        "title": "Alerts and recalls for drugs and medical devices",
        "base_path": "/drug-device-alerts",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/drug-device-alerts",
        "web_url": "https://www.gov.uk/drug-device-alerts",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### drug-safety-update.json
```json
{
  "content_id": "34a376eb-5a60-4a05-8d37-450660b67410",
  "base_path": "/drug-safety-update",
  "title": "Drug Safety Update",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:19.565Z",
  "public_updated_at": "2015-04-30T10:41:26.000+00:00",
  "details": {
    "beta": false,
    "document_noun": "update",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Anaesthesia and intensive care",
            "value": "anaesthesia-intensive-care"
          },
          {
            "label": "Cancer",
            "value": "cancer"
          },
          {
            "label": "Cardiovascular disease and lipidology",
            "value": "cardiovascular-disease-lipidology"
          },
          {
            "label": "Dentistry",
            "value": "dentistry"
          },
          {
            "label": "Dermatology",
            "value": "dermatology"
          },
          {
            "label": "Ear, nose and throat",
            "value": "ear-nose-throat"
          },
          {
            "label": "Endocrinology, diabetology and metabolism",
            "value": "endocrinology-diabetology-metabolism"
          },
          {
            "label": "GI, hepatology and pancreatic disorders",
            "value": "gi-hepatology-pancreatic-disorders"
          },
          {
            "label": "Haematology",
            "value": "haematology"
          },
          {
            "label": "Immunology and vaccination",
            "value": "immunology-vaccination"
          },
          {
            "label": "Immunosuppression and transplantation",
            "value": "immunosuppression-transplantation"
          },
          {
            "label": "Infectious disease",
            "value": "infectious-disease"
          },
          {
            "label": "Neurology",
            "value": "neurology"
          },
          {
            "label": "Nutrition and dietetics",
            "value": "nutrition-dietetics"
          },
          {
            "label": "Obstetrics, gynaecology and fertility",
            "value": "obstetrics-gynaecology-fertility"
          },
          {
            "label": "Ophthalmology",
            "value": "ophthalmology"
          },
          {
            "label": "Paediatrics and neonatology",
            "value": "paediatrics-neonatology"
          },
          {
            "label": "Pain management and palliation",
            "value": "pain-management-palliation"
          },
          {
            "label": "Psychiatry",
            "value": "psychiatry"
          },
          {
            "label": "Radiology and imaging",
            "value": "radiology-imaging"
          },
          {
            "label": "Respiratory disease and allergy",
            "value": "respiratory-disease-allergy"
          },
          {
            "label": "Rheumatology",
            "value": "rheumatology"
          },
          {
            "label": "Urology and nephrology",
            "value": "urology-nephrology"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "therapeutic_area",
        "name": "Therapeutic area",
        "preposition": "about",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "first_published_at",
        "name": "Published",
        "preposition": "published",
        "short_name": "Published",
        "type": "date"
      }
    ],
    "filter": {
      "document_type": "drug_safety_update"
    },
    "format_name": "Drug Safety Update",
    "show_summaries": true,
    "signup_link": "/government/organisations/medicines-and-healthcare-products-regulatory-agency/email-signup"
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "c7371680-8205-4f18-a533-fa987d4225cf",
        "title": "Drug Safety Update",
        "base_path": "/drug-safety-update/email-signup",
        "description": "The drug safety update is a monthly newsletter for healthcare professionals, bringing you information and clinical advice on the safe use of medicines.",
        "api_url": "https://www.gov.uk/api/content/drug-safety-update/email-signup",
        "web_url": "https://www.gov.uk/drug-safety-update/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "e68b064d-dfb6-46e6-91db-48df629f0162",
        "title": "Medicines and Healthcare products Regulatory Agency",
        "base_path": "/government/organisations/medicines-and-healthcare-products-regulatory-agency",
        "api_url": "https://www.gov.uk/api/content/government/organisations/medicines-and-healthcare-products-regulatory-agency",
        "web_url": "https://www.gov.uk/government/organisations/medicines-and-healthcare-products-regulatory-agency",
        "locale": "en"
      }
    ],
    "related": [
      {
        "content_id": "79f4668f-8672-4769-9323-ee00ae0dadda",
        "title": "Alerts and recalls for drugs and medical devices",
        "base_path": "/drug-device-alerts",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/drug-device-alerts",
        "web_url": "https://www.gov.uk/drug-device-alerts",
        "locale": "en"
      },
      {
        "content_id": "20c598af-8d10-4a18-8c3a-9cc52e8b7bfd",
        "title": "Drug Safety Update: monthly PDF newsletter",
        "base_path": "/government/publications/drug-safety-update-monthly-newsletter",
        "description": "Monthly PDF editions of the Drug Safety Update newsletter from MHRA and its independent advisor the Commission on Human Medicines. ",
        "api_url": "https://www.gov.uk/api/content/government/publications/drug-safety-update-monthly-newsletter",
        "web_url": "https://www.gov.uk/government/publications/drug-safety-update-monthly-newsletter",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "34a376eb-5a60-4a05-8d37-450660b67410",
        "title": "Drug Safety Update",
        "base_path": "/drug-safety-update",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/drug-safety-update",
        "web_url": "https://www.gov.uk/drug-safety-update",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### employment-appeal-tribunal-decisions.json
```json
{
  "content_id": "975cf540-6e64-40e3-b62a-df655a8c99ef",
  "base_path": "/employment-appeal-tribunal-decisions",
  "title": "Employment appeal tribunal decisions",
  "description": "Find decisions on appeals against employment tribunals heard by the Employment Appeal Tribunal.",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-10-29T14:30:59.334Z",
  "public_updated_at": "2015-10-29T12:18:39.000+00:00",
  "details": {
    "document_noun": "decision",
    "filter": {
      "document_type": "employment_appeal_tribunal_decision"
    },
    "format_name": "Employment appeal tribunal decision",
    "show_summaries": true,
    "summary": "<p>Find decisions on appeals against employment tribunals heard by the Employment Appeal Tribunal.</p><p>Includes decisions after [month year]. Find details of <a rel=\"external\" href=\"http://www.employmentappeals.gov.uk/Public/Search.aspx\">older cases.</a></p>",
    "facets": [
      {
        "key": "tribunal_decision_categories",
        "name": "Category",
        "type": "text",
        "preposition": "categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Age Discrimination",
            "value": "age-discrimination"
          },
          {
            "label": "Race Discrimination",
            "value": "race-discrimination"
          }
        ]
      },
      {
        "key": "tribunal_decision_categories_name",
        "name": "Category name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_sub_categories",
        "name": "Sub-category",
        "type": "text",
        "preposition": "sub-categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Race Discrimination - Detriment",
            "value": "race-discrimination-detriment"
          },
          {
            "label": "Race Discrimination - Direct",
            "value": "race-discrimination-direct"
          }
        ]
      },
      {
        "key": "tribunal_decision_sub_categories_name",
        "name": "Sub-category name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_landmark",
        "name": "Landmark",
        "type": "text",
        "display_as_result_metadata": false,
        "filterable": false,
        "allowed_values": [
          {
            "label": "Landmark",
            "value": "landmark"
          },
          {
            "label": "Not landmark",
            "value": "not-landmark"
          }
        ]
      },
      {
        "key": "tribunal_decision_landmark_name",
        "name": "Landmark name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_decision_date",
        "name": "Decision date",
        "short_name": "Decided",
        "type": "date",
        "display_as_result_metadata": true,
        "filterable": true
      }
    ]
  },
  "links": {
    "organisations": [],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "1f5911f4-417a-4380-a5a0-674ebff332df",
        "title": "Employment appeal tribunal decisions",
        "base_path": "/employment-appeal-tribunal-decisions/email-signup",
        "description": "You'll get an email each time a decision is updated or a new decision is published.",
        "api_url": "http://content-store.dev.gov.uk/content/employment-appeal-tribunal-decisions/email-signup",
        "web_url": "http://www.dev.gov.uk/employment-appeal-tribunal-decisions/email-signup",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "975cf540-6e64-40e3-b62a-df655a8c99ef",
        "title": "Employment appeal tribunal decisions",
        "base_path": "/employment-appeal-tribunal-decisions",
        "description": "Find decisions on appeals against employment tribunals heard by the Employment Appeal Tribunal.",
        "api_url": "http://content-store.dev.gov.uk/content/employment-appeal-tribunal-decisions",
        "web_url": "http://www.dev.gov.uk/employment-appeal-tribunal-decisions",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### employment-tribunal-decisions.json
```json
{
  "content_id": "1b5e08c8-ddde-4637-9375-f79e085ba6d5",
  "base_path": "/employment-tribunal-decisions",
  "title": "Employment tribunal decisions",
  "description": "Find decisions on Employment Tribunal cases in England, Wales and Scotland.",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-10-15T14:25:29.741Z",
  "public_updated_at": "2015-10-15T11:45:22.000+00:00",
  "details": {
    "document_noun": "decision",
    "filter": {
      "document_type": "employment_tribunal_decision"
    },
    "format_name": "Employment tribunal decision",
    "show_summaries": true,
    "summary": "<p>Find decisions on Employment Tribunal cases in England, Wales and Scotland.</p>",
    "facets": [
      {
        "key": "tribunal_decision_country",
        "name": "Country",
        "type": "text",
        "preposition": "by country",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "England and Wales",
            "value": "england-and-wales"
          },
          {
            "label": "Scotland",
            "value": "scotland"
          }
        ]
      },
      {
        "key": "tribunal_decision_country_name",
        "name": "Country name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_categories",
        "name": "Jurisdiction code",
        "type": "text",
        "preposition": "by jurisdiction",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Age Discrimination",
            "value": "age-discrimination"
          },
          {
            "label": "Agency Workers",
            "value": "agency-workers"
          }
        ]
      },
      {
        "key": "tribunal_decision_categories_name",
        "name": "Jurisdiction code name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_decision_date",
        "name": "Decision date",
        "short_name": "Decided",
        "type": "date",
        "display_as_result_metadata": true,
        "filterable": true
      }
    ]
  },
  "links": {
    "organisations": [],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "6d7ace06-f437-4fb3-b948-8534ff34540f",
        "title": "Employment tribunal decisions",
        "base_path": "/employment-tribunal-decisions/email-signup",
        "description": "You'll get an email each time a decision is updated or a new decision is published.",
        "api_url": "http://content-store.dev.gov.uk/content/employment-tribunal-decisions/email-signup",
        "web_url": "http://www.dev.gov.uk/employment-tribunal-decisions/email-signup",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "1b5e08c8-ddde-4637-9375-f79e085ba6d5",
        "title": "Employment tribunal decisions",
        "base_path": "/employment-tribunal-decisions",
        "description": "Find decisions on Employment Tribunal cases in England, Wales and Scotland.",
        "api_url": "http://content-store.dev.gov.uk/content/employment-tribunal-decisions",
        "web_url": "http://www.dev.gov.uk/employment-tribunal-decisions",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### european-structural-investment-funds.json
```json
{
  "content_id": "5057413b-82ea-4172-af10-18c307f98012",
  "base_path": "/european-structural-investment-funds",
  "title": "European Structural and Investment Funds (ESIF)",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:30.149Z",
  "public_updated_at": "2015-07-16T10:13:18.000+00:00",
  "details": {
    "beta": true,
    "default_order": "-closing_date",
    "document_noun": "call",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Open",
            "value": "open"
          },
          {
            "label": "Closed",
            "value": "closed"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "fund_state",
        "name": "Fund state",
        "preposition": "which are",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Access to employment",
            "value": "access-to-work"
          },
          {
            "label": "Business support",
            "value": "business-support"
          },
          {
            "label": "Climate change",
            "value": "climate-change"
          },
          {
            "label": "Environment",
            "value": "environment"
          },
          {
            "label": "IT and broadband",
            "value": "it-and-broadband"
          },
          {
            "label": "Learning and skills",
            "value": "learning-and-skills"
          },
          {
            "label": "Low carbon",
            "value": "low-carbon"
          },
          {
            "label": "Renewable energy",
            "value": "renewable-energy"
          },
          {
            "label": "Research and innovation",
            "value": "research-and-innovation"
          },
          {
            "label": "Social inclusion",
            "value": "social-inclusion"
          },
          {
            "label": "Transport",
            "value": "transport"
          },
          {
            "label": "Technical assistance",
            "value": "techincal-assistance"
          },
          {
            "label": "Tourism",
            "value": "tourism"
          }
        ],
        "display_as_result_metadata": false,
        "filterable": true,
        "key": "fund_type",
        "name": "Type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "North East",
            "value": "north-east"
          },
          {
            "label": "North West",
            "value": "north-west"
          },
          {
            "label": "Yorkshire and Humber",
            "value": "yorkshire-and-humber"
          },
          {
            "label": "East Midlands",
            "value": "east-midlands"
          },
          {
            "label": "West Midlands",
            "value": "west-midlands"
          },
          {
            "label": "East of England",
            "value": "east-of-england"
          },
          {
            "label": "South East",
            "value": "south-east"
          },
          {
            "label": "South West",
            "value": "south-west"
          },
          {
            "label": "London",
            "value": "london"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "location",
        "name": "Location",
        "preposition": "in",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "European Social Fund",
            "value": "european-social-fund"
          },
          {
            "label": "European Regional Development Fund",
            "value": "european-regional-development-fund"
          },
          {
            "label": "European Agricultural Fund for Rural Development",
            "value": "european-agricoltural-fund-for-rural"
          }
        ],
        "display_as_result_metadata": false,
        "filterable": true,
        "key": "funding_source",
        "name": "Funding source",
        "preposition": "from",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": false,
        "key": "closing_date",
        "name": "Closing date",
        "type": "date"
      }
    ],
    "filter": {
      "document_type": "european_structural_investment_fund"
    },
    "format_name": "ESIF call for proposals",
    "show_summaries": false,
    "summary": "<p>Applies to: England (see guidance for <a rel=\"external\" href=\"http://www.scotland.gov.uk/Topics/Business-Industry/support/17404\">Scotland</a>, <a rel=\"external\" href=\"http://wefo.wales.gov.uk/programmes/post2013/?skip=1&amp;lang=en\">Wales</a> and <a rel=\"external\" href=\"http://www.dfpni.gov.uk/index/finance/european-funding/content_-_european_funding-future-funding.htm\">Northern Ireland</a>)</p><p>Apply to run projects backed by the European Stuctural and Investment Fund (ESIF). ESIF includes money from the European Social Fund (ESF), European Regional Development Fund (ERDF) and European Agricultural Fund for Rural Development (EAFRD).</p>"
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "af366ed4-2ff5-45e2-b694-cc13c5a4e887",
        "title": "European Structural and Investment Funds (ESIF)",
        "base_path": "/european-structural-investment-funds/email-signup",
        "description": "You'll get an email each time a fund is updated or a new fund is published.",
        "api_url": "https://www.gov.uk/api/content/european-structural-investment-funds/email-signup",
        "web_url": "https://www.gov.uk/european-structural-investment-funds/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "b1e4e105-c157-43ae-899c-4bccca45b336",
        "title": "Department for Communities and Local Government",
        "base_path": "/government/organisations/department-for-communities-and-local-government",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-communities-and-local-government",
        "web_url": "https://www.gov.uk/government/organisations/department-for-communities-and-local-government",
        "locale": "en"
      },
      {
        "content_id": "b2f980f7-eca3-4bc8-aaa3-a40788a72e52",
        "title": "Department for Environment, Food & Rural Affairs",
        "base_path": "/government/organisations/department-for-environment-food-rural-affairs",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-environment-food-rural-affairs",
        "web_url": "https://www.gov.uk/government/organisations/department-for-environment-food-rural-affairs",
        "locale": "en"
      },
      {
        "content_id": "3d7941fc-e5d6-4309-b5f9-eeee0e9f1109",
        "title": "Department for Business, Innovation & Skills",
        "base_path": "/government/organisations/department-for-business-innovation-skills",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-business-innovation-skills",
        "web_url": "https://www.gov.uk/government/organisations/department-for-business-innovation-skills",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "5057413b-82ea-4172-af10-18c307f98012",
        "title": "European Structural and Investment Funds (ESIF)",
        "base_path": "/european-structural-investment-funds",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/european-structural-investment-funds",
        "web_url": "https://www.gov.uk/european-structural-investment-funds",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### finder.json
```json
{
  "content_id": "23ec51f6-b1a1-41a7-97bc-59e18041e2e7",
  "base_path": "/mosw-reports",
  "title": "Ministry of Silly Walks reports",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-02-20T10:31:55.529Z",
  "public_updated_at": "2015-02-11T14:13:29.000+00:00",
  "details": {
    "document_noun": "report",
    "filter": {
      "document_type": "mosw_report"
    },
    "show_summaries": true,
    "summary": "The Ministry of Silly Walks researchs silly walks being developed by the British public",
    "facets": [
      {
        "key": "walk_type",
        "name": "Walk type",
        "type": "text",
        "preposition": "of type",
        "display_as_result_metadata": true,
        "filterable": true,
        "allowed_values": [
          {
            "value": "backward",
            "label": "Backward"
          },
          {
            "value": "hopscotch",
            "label": "Hopscotch"
          },
          {
            "value": "start-and-stop",
            "label": "Start-and-stop"
          }
        ]
      },
      {
        "key": "place_of_origin",
        "name": "Place of origin",
        "type": "text",
        "preposition": "from",
        "display_as_result_metadata": true,
        "filterable": true,
        "allowed_values": [
          {
            "value": "england",
            "label": "England"
          },
          {
            "value": "northern-ireland",
            "label": "Northern Ireland"
          },
          {
            "value": "scotland",
            "label": "Scotland"
          },
          {
            "value": "wales",
            "label": "Wales"
          }
        ]
      },
      {
        "key": "date_of_introduction",
        "name": "Date of Introduction",
        "short_name": "Introduced",
        "type": "date",
        "preposition": "introduced",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "creator",
        "name": "Creator",
        "type": "text",
        "filterable": false,
        "display_as_result_metadata": false
      }
    ]
  },
  "links": {
    "organisations": [
      {
        "content_id": "3338f283-64a1-4062-842e-677f520c1f15",
        "title": "Ministry of Silly Walks",
        "base_path": "/government/organisations/ministry-of-silly-walks",
        "api_url": "https://www.gov.uk/api/content/government/organisations/government/organisations/ministry-of-silly-walks",
        "web_url": "https://www.gov.uk/government/organisations/government/organisations/ministry-of-silly-walks",
        "locale": "en"
      }
    ],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "5c35b119-aebc-4ec8-9413-370bd01c24b3",
        "title": "Ministry of Silly Walks reports",
        "base_path": "/mosw-reports/email-signup",
        "api_url": "https://www.gov.uk/api/content/mosw-reports/email-signup",
        "web_url": "https://www.gov.uk/mosw-reports/email-signup",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "23ec51f6-b1a1-41a7-97bc-59e18041e2e7",
        "title": "Ministry of Silly Walks reports",
        "base_path": "/mosw-reports",
        "api_url": "https://www.gov.uk/api/content/mosw-reports",
        "web_url": "https://www.gov.uk/mosw-reports",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### international-development-funding.json
```json
{
  "content_id": "1e0784fb-0a81-442e-82a0-efa678d76b4d",
  "base_path": "/international-development-funding",
  "title": "International development funding",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:24.830Z",
  "public_updated_at": "2015-04-30T10:41:26.000+00:00",
  "details": {
    "beta": false,
    "document_noun": "fund",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Open",
            "value": "open"
          },
          {
            "label": "Closed",
            "value": "closed"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "fund_state",
        "name": "Funds",
        "preposition": "which are",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Afghanistan",
            "value": "afghanistan"
          },
          {
            "label": "Bangladesh",
            "value": "bangladesh"
          },
          {
            "label": "Burma",
            "value": "burma"
          },
          {
            "label": "Democratic Republic of Congo",
            "value": "democratic-republic-of-congo"
          },
          {
            "label": "Ethiopia",
            "value": "ethiopia"
          },
          {
            "label": "Ghana",
            "value": "ghana"
          },
          {
            "label": "India",
            "value": "india"
          },
          {
            "label": "Kenya",
            "value": "kenya"
          },
          {
            "label": "Kyrgyzstan",
            "value": "kyrgyzstan"
          },
          {
            "label": "Liberia",
            "value": "liberia"
          },
          {
            "label": "Malawi",
            "value": "malawi"
          },
          {
            "label": "Mozambique",
            "value": "mozambique"
          },
          {
            "label": "Nepal",
            "value": "nepal"
          },
          {
            "label": "Nigeria",
            "value": "nigeria"
          },
          {
            "label": "The Occupied Palestinian Territories",
            "value": "the-occupied-palestinian-territories"
          },
          {
            "label": "Pakistan",
            "value": "pakistan"
          },
          {
            "label": "Rwanda",
            "value": "rwanda"
          },
          {
            "label": "Sierra Leone",
            "value": "sierra-leone"
          },
          {
            "label": "Somalia",
            "value": "somalia"
          },
          {
            "label": "South Africa",
            "value": "south-africa"
          },
          {
            "label": "Sudan",
            "value": "sudan"
          },
          {
            "label": "South Sudan",
            "value": "south-sudan"
          },
          {
            "label": "Tajikistan",
            "value": "tajikistan"
          },
          {
            "label": "Tanzania",
            "value": "tanzania"
          },
          {
            "label": "Uganda",
            "value": "uganda"
          },
          {
            "label": "Yemen",
            "value": "yemen"
          },
          {
            "label": "Zambia",
            "value": "zambia"
          },
          {
            "label": "Zimbabwe",
            "value": "zimbabwe"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "location",
        "name": "Countries",
        "preposition": "for",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Agriculture",
            "value": "agriculture"
          },
          {
            "label": "Climate change",
            "value": "climate-change"
          },
          {
            "label": "Disabilities",
            "value": "disabilities"
          },
          {
            "label": "Education",
            "value": "education"
          },
          {
            "label": "Empowerment and accountability",
            "value": "empowerment-and-accountability"
          },
          {
            "label": "Environment",
            "value": "environment"
          },
          {
            "label": "Girls and women",
            "value": "girls-and-women"
          },
          {
            "label": "Health",
            "value": "health"
          },
          {
            "label": "Humanitarian emergencies/disasters",
            "value": "humanitarian-emergencies-disasters"
          },
          {
            "label": "Livelihoods",
            "value": "livelihoods"
          },
          {
            "label": "Peace and access to justice",
            "value": "peace-and-access-to-justice"
          },
          {
            "label": "Private sector/business",
            "value": "private-sector-business"
          },
          {
            "label": "Technology",
            "value": "technology"
          },
          {
            "label": "Trade",
            "value": "trade"
          },
          {
            "label": "Water and sanitation",
            "value": "water-and-sanitation"
          }
        ],
        "display_as_result_metadata": false,
        "filterable": true,
        "key": "development_sector",
        "name": "Sector",
        "preposition": "for",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Non-governmental organisations (NGOs)",
            "value": "non-governmental-organisations"
          },
          {
            "label": "UK-based non-profit organisations",
            "value": "uk-based-non-profit-organisations"
          },
          {
            "label": "UK-based small and diaspora organisations",
            "value": "uk-based-small-and-diaspora-organisations"
          },
          {
            "label": "Companies",
            "value": "companies"
          },
          {
            "label": "Local government",
            "value": "local-government"
          },
          {
            "label": "Educational institutions",
            "value": "educational-institutions"
          },
          {
            "label": "Individuals",
            "value": "individuals"
          },
          {
            "label": "Humanitarian relief organisations",
            "value": "humanitarian-relief-organisations"
          }
        ],
        "display_as_result_metadata": false,
        "filterable": true,
        "key": "eligible_entities",
        "name": "Eligible organisations",
        "preposition": "open to",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Up to £100,000",
            "value": "up-to-100000"
          },
          {
            "label": "£100,001 to £500,000",
            "value": "100001-500000"
          },
          {
            "label": "£500,001 to £1,000,000",
            "value": "500001-to-1000000"
          },
          {
            "label": "More than £1,000,000",
            "value": "more-than-1000000"
          }
        ],
        "display_as_result_metadata": false,
        "filterable": true,
        "key": "value_of_funding",
        "name": "Value of funding",
        "preposition": "with value",
        "type": "text"
      }
    ],
    "filter": {
      "document_type": "international_development_fund"
    },
    "format_name": "International development funding",
    "show_summaries": true
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "420b6a4a-7399-4763-b82d-2e54f6583ef9",
        "title": "International development funding",
        "base_path": "/international-development-funding/email-signup",
        "description": "You'll get an email each time a fund is updated or a new fund is published.",
        "api_url": "https://www.gov.uk/api/content/international-development-funding/email-signup",
        "web_url": "https://www.gov.uk/international-development-funding/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "ee825e42-e3a4-4168-919c-56c8fbc313c9",
        "title": "Department for International Development",
        "base_path": "/government/organisations/department-for-international-development",
        "api_url": "https://www.gov.uk/api/content/government/organisations/department-for-international-development",
        "web_url": "https://www.gov.uk/government/organisations/department-for-international-development",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "1e0784fb-0a81-442e-82a0-efa678d76b4d",
        "title": "International development funding",
        "base_path": "/international-development-funding",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/international-development-funding",
        "web_url": "https://www.gov.uk/international-development-funding",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### maib-reports.json
```json
{
  "content_id": "3df5a305-2819-4125-882b-65c2f3edf6cf",
  "base_path": "/maib-reports",
  "title": "Marine Accident Investigation Branch reports",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:34.193Z",
  "public_updated_at": "2015-04-30T10:41:26.000+00:00",
  "details": {
    "beta": false,
    "document_noun": "report",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Merchant vessel 100 gross tons or over",
            "value": "merchant-vessel-100-gross-tons-or-over"
          },
          {
            "label": "Merchant vessel under 100 gross tons",
            "value": "merchant-vessel-under-100-gross-tons"
          },
          {
            "label": "Fishing vessel",
            "value": "fishing-vessel"
          },
          {
            "label": "Recreational craft - sail",
            "value": "recreational-craft-sail"
          },
          {
            "label": "Recreational craft - power",
            "value": "recreational-craft-power"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "vessel_type",
        "name": "Vessel type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Investigation report",
            "value": "investigation-report"
          },
          {
            "label": "Safety bulletin",
            "value": "safety-bulletin"
          },
          {
            "label": "Completed preliminary examination",
            "value": "completed-preliminary-examination"
          },
          {
            "label": "Overseas report",
            "value": "overseas-report"
          },
          {
            "label": "Discontinued investigation",
            "value": "discontinued-investigation"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "report_type",
        "name": "Report type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "date_of_occurrence",
        "name": "Date of occurrence",
        "preposition": "occurred",
        "short_name": "Occurred",
        "type": "date"
      }
    ],
    "filter": {
      "document_type": "maib_report"
    },
    "format_name": "Marine Accident Investigation Branch report",
    "show_summaries": true
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "21c88fa0-79f0-4ec2-8936-4b086f2ce5ed",
        "title": "Marine Accident Investigation Branch reports",
        "base_path": "/maib-reports/email-signup",
        "description": "You'll get an email each time a report is updated or a new report is published.",
        "api_url": "https://www.gov.uk/api/content/maib-reports/email-signup",
        "web_url": "https://www.gov.uk/maib-reports/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "5415d422-e3ab-4cb7-bd84-d54640be0b1c",
        "title": "Marine Accident Investigation Branch",
        "base_path": "/government/organisations/marine-accident-investigation-branch",
        "api_url": "https://www.gov.uk/api/content/government/organisations/marine-accident-investigation-branch",
        "web_url": "https://www.gov.uk/government/organisations/marine-accident-investigation-branch",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "3df5a305-2819-4125-882b-65c2f3edf6cf",
        "title": "Marine Accident Investigation Branch reports",
        "base_path": "/maib-reports",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/maib-reports",
        "web_url": "https://www.gov.uk/maib-reports",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### policies_finder.json
```json
{
  "content_id": "854c7a4a-e8bf-44df-a08a-edbb2a56a58e",
  "base_path": "/government/policies",
  "title": "Policies",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-05-14T15:39:39.405Z",
  "public_updated_at": "2015-05-14T11:04:29.000+00:00",
  "details": {
    "document_noun": "policy",
    "default_order": "title",
    "filter": {
      "document_type": "policy"
    },
    "show_summaries": false,
    "facets": [
      {
        "key": "organisations",
        "short_name": "From",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": true,
        "preposition": "from",
        "name": "Organisation"
      }
    ]
  },
  "links": {
    "organisations": [],
    "related": [],
    "available_translations": [
      {
        "content_id": "854c7a4a-e8bf-44df-a08a-edbb2a56a58e",
        "title": "Policies",
        "base_path": "/government/policies",
        "api_url": "http://content-store.dev.gov.uk/content/government/policies",
        "web_url": "http://www.dev.gov.uk/government/policies",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### raib-reports.json
```json
{
  "content_id": "bec582be-a95c-41f2-8a56-53dc19f45b76",
  "base_path": "/raib-reports",
  "title": "Rail Accident Investigation Branch reports",
  "description": "",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-07-21T12:45:27.470Z",
  "public_updated_at": "2015-04-30T10:41:26.000+00:00",
  "details": {
    "beta": false,
    "document_noun": "report",
    "facets": [
      {
        "allowed_values": [
          {
            "label": "Heavy rail",
            "value": "heavy-rail"
          },
          {
            "label": "Light rail",
            "value": "light-rail"
          },
          {
            "label": "Metros",
            "value": "metros"
          },
          {
            "label": "Heritage railways",
            "value": "heritage-railways"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "railway_type",
        "name": "Railway type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "allowed_values": [
          {
            "label": "Investigation report",
            "value": "investigation-report"
          },
          {
            "label": "Bulletin",
            "value": "bulletin"
          },
          {
            "label": "Interim report",
            "value": "interim-report"
          },
          {
            "label": "Discontinuation report",
            "value": "discontinuation-report"
          },
          {
            "label": "Safety digest",
            "value": "safety-digest"
          }
        ],
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "report_type",
        "name": "Report type",
        "preposition": "of type",
        "type": "text"
      },
      {
        "display_as_result_metadata": true,
        "filterable": true,
        "key": "date_of_occurrence",
        "name": "Date of occurrence",
        "preposition": "occurred",
        "short_name": "Occurred",
        "type": "date"
      }
    ],
    "filter": {
      "document_type": "raib_report"
    },
    "format_name": "Rail Accident Investigation Branch report",
    "show_summaries": false
  },
  "links": {
    "email_alert_signup": [
      {
        "content_id": "81e62338-4644-4520-bbfc-6378855e9e43",
        "title": "Rail Accident Investigation Branch reports",
        "base_path": "/raib-reports/email-signup",
        "description": "You'll get an email each time a report is updated or a new report is published.",
        "api_url": "https://www.gov.uk/api/content/raib-reports/email-signup",
        "web_url": "https://www.gov.uk/raib-reports/email-signup",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "7c87edb4-1b32-4da2-bce8-f67fd9bb50db",
        "title": "Rail Accident Investigation Branch",
        "base_path": "/government/organisations/rail-accident-investigation-branch",
        "api_url": "https://www.gov.uk/api/content/government/organisations/rail-accident-investigation-branch",
        "web_url": "https://www.gov.uk/government/organisations/rail-accident-investigation-branch",
        "locale": "en"
      }
    ],
    "related": [],
    "available_translations": [
      {
        "content_id": "bec582be-a95c-41f2-8a56-53dc19f45b76",
        "title": "Rail Accident Investigation Branch reports",
        "base_path": "/raib-reports",
        "description": "",
        "api_url": "https://www.gov.uk/api/content/raib-reports",
        "web_url": "https://www.gov.uk/raib-reports",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### tax-tribunal-decisions.json
```json
{
  "content_id": "632290ae-aad8-4895-b135-1e0a72a6bdeb",
  "base_path": "/tax-and-chancery-tribunal-decisions",
  "title": "Tax and Chancery tribunal decisions",
  "description": "Find decisions on tax, financial services, pensions, charity and land registration appeals to the Upper Tribunal (Tax and Chancery Chamber).",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-10-07T13:15:28.108Z",
  "public_updated_at": "2015-10-07T10:14:26.000+00:00",
  "details": {
    "document_noun": "decision",
    "filter": {
      "document_type": "tax_tribunal_decision"
    },
    "format_name": "Tax and Chancery tribunal decision",
    "show_summaries": true,
    "summary": "<p>Find decisions on tax, financial services, pensions, charity and land registration appeals to the Upper Tribunal (Tax and Chancery Chamber).</p>",
    "facets": [
      {
        "key": "tribunal_decision_category",
        "name": "Category",
        "short_name": "category",
        "type": "text",
        "preposition": "categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Banking",
            "value": "banking"
          },
          {
            "label": "Charity",
            "value": "charity"
          },
          {
            "label": "Financial Services",
            "value": "financial-services"
          },
          {
            "label": "Land Registration",
            "value": "land-registration"
          },
          {
            "label": "Pensions",
            "value": "pensions"
          },
          {
            "label": "Tax",
            "value": "tax"
          }
        ]
      },
      {
        "key": "tribunal_decision_category_name",
        "name": "Category name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_decision_date",
        "name": "Release date",
        "short_name": "Released",
        "type": "date",
        "display_as_result_metadata": true,
        "filterable": true
      }
    ]
  },
  "links": {
    "organisations": [],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "ae5afec1-30d6-4997-bdf8-7de94d2dd910",
        "title": "Tax and Chancery tribunal decisions",
        "base_path": "/tax-and-chancery-tribunal-decisions/email-signup",
        "description": "You'll get an email each time a decision is updated or a new decision is published.",
        "api_url": "http://content-store.dev.gov.uk/content/tax-and-chancery-tribunal-decisions/email-signup",
        "web_url": "http://www.dev.gov.uk/tax-and-chancery-tribunal-decisions/email-signup",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "632290ae-aad8-4895-b135-1e0a72a6bdeb",
        "title": "Tax and Chancery tribunal decisions",
        "base_path": "/tax-and-chancery-tribunal-decisions",
        "description": "Find decisions on tax, financial services, pensions, charity and land registration appeals to the Upper Tribunal (Tax and Chancery Chamber).",
        "api_url": "http://content-store.dev.gov.uk/content/tax-and-chancery-tribunal-decisions",
        "web_url": "http://www.dev.gov.uk/tax-and-chancery-tribunal-decisions",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}

```

### utaac-decisions.json
```json
{
  "content_id": "e9e7fcff-bb0d-4723-af25-9f78d730f6f8",
  "base_path": "/administrative-appeals-tribunal-decisions",
  "title": "Administrative appeals tribunal decisions",
  "description": "Find decisions on appeals to the Upper Tribunal (Administrative Appeals Chamber), including social security and child support appeals.",
  "format": "finder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-04-06T11:04:06.312Z",
  "public_updated_at": "2016-04-05T08:20:40.000+00:00",
  "details": {
    "document_noun": "decision",
    "filter": {
      "document_type": "utaac_decision"
    },
    "format_name": "Administrative appeals tribunal decision",
    "show_summaries": true,
    "summary": "<p>Find decisions on appeals to the Upper Tribunal (Administrative Appeals Chamber), including social security and child support appeals.</p><p>Includes decisions after January 2016. Find details of <a rel=\"external\" href=\"http://www.osscsc.gov.uk/Aspx/default.aspx\">older cases.</a></p>",
    "facets": [
      {
        "key": "tribunal_decision_categories",
        "name": "Categories",
        "type": "text",
        "preposition": "categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Benefits for children",
            "value": "benefits-for-children"
          },
          {
            "label": "Bereavement and death benefits",
            "value": "bereavement-and-death-benefits"
          }
        ]
      },
      {
        "key": "tribunal_decision_categories_name",
        "name": "Categories name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_sub_categories",
        "name": "Sub-categories",
        "type": "text",
        "preposition": "sub-categorised as",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Benefits for children - benefit increases for children",
            "value": "benefits-for-children-benefit-increases-for-children"
          },
          {
            "label": "Bereavement and death benefits - bereaved parents allowance",
            "value": "bereavement-and-death-benefits-bereaved-parents-allowance"
          }
        ]
      },
      {
        "key": "tribunal_decision_sub_categories_name",
        "name": "Sub-categories name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_judges",
        "name": "Judges",
        "type": "text",
        "preposition": "by judge",
        "display_as_result_metadata": false,
        "filterable": true,
        "allowed_values": [
          {
            "label": "Angus, R",
            "value": "angus-r"
          },
          {
            "label": "Bano, A",
            "value": "bano-a"
          }
        ]
      },
      {
        "key": "tribunal_decision_judges_name",
        "name": "Judges name",
        "type": "text",
        "display_as_result_metadata": true,
        "filterable": false
      },
      {
        "key": "tribunal_decision_decision_date",
        "name": "Decision date",
        "short_name": "Decided",
        "type": "date",
        "display_as_result_metadata": true,
        "filterable": true
      }
    ]
  },
  "phase": "beta",
  "analytics_identifier": null,
  "links": {
    "organisations": [],
    "related": [],
    "email_alert_signup": [
      {
        "content_id": "13e59efa-6c0d-48e8-a0b9-092b62cdc912",
        "title": "Administrative appeals tribunal decisions",
        "base_path": "/administrative-appeals-tribunal-decisions/email-signup",
        "description": "You'll get an email each time a decision is updated or a new decision is published.",
        "api_url": "http://content-store.dev.gov.uk/content/administrative-appeals-tribunal-decisions/email-signup",
        "web_url": "http://www.dev.gov.uk/administrative-appeals-tribunal-decisions/email-signup",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "e9e7fcff-bb0d-4723-af25-9f78d730f6f8",
        "title": "Administrative appeals tribunal decisions",
        "base_path": "/administrative-appeals-tribunal-decisions",
        "description": "Find decisions on appeals to the Upper Tribunal (Administrative Appeals Chamber), including social security and child support appeals.",
        "api_url": "http://content-store.dev.gov.uk/content/administrative-appeals-tribunal-decisions",
        "web_url": "http://www.dev.gov.uk/administrative-appeals-tribunal-decisions",
        "locale": "en"
      }
    ]
  },
  "schema_name": "finder",
  "document_type": "finder"
}
```



