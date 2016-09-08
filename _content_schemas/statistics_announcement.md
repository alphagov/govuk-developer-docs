---
layout: content_schema
title:  Statistics announcement
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/statistics_announcement/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>cancellation_reason</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>cancelled_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>latest_change_note</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>previous_display_date</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>display_date</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>state</strong> <code>string</code></td> <td>Allowed values: <code>cancelled</code> or <code>confirmed</code> or <code>provisional</code></td></tr>
<tr><td><strong>format_sub_type</strong> <code>string</code></td> <td>Allowed values: <code>national</code> or <code>official</code></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>statistics_announcement</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/statistics_announcement/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>organisations</strong> </td> <td>All organisations linked to this content item. This should include lead organisations.</td></tr>
<tr><td><strong>policy_areas</strong> </td> <td>A largely deprecated tag currently only used to power email alerts.</td></tr>
<tr><td><strong>taxons</strong> </td> <td>Prototype-stage taxonomy label for this content item</td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td>Powers the /browse section of the site. These are known as sections in some legacy apps.</td></tr>
<tr><td><strong>topics</strong> </td> <td>Powers the /topic section of the site. These are known as specialist sectors in some legacy apps.</td></tr>
<tr><td><strong>parent</strong> </td> <td>The parent content item.</td></tr>
<tr><td><strong>policies</strong> </td> <td>These are for collecting content related to a particular government policy.</td></tr></table></td></tr>
<tr><td><strong>previous_version</strong> <code>string</code></td> <td></td></tr></table>

---

## Frontend schema

This is the schema for what you'll get back from the content-store.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/statistics_announcement/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>cancellation_reason</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>cancelled_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>latest_change_note</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>previous_display_date</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>display_date</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>state</strong> <code>string</code></td> <td>Allowed values: <code>cancelled</code> or <code>confirmed</code> or <code>provisional</code></td></tr>
<tr><td><strong>format_sub_type</strong> <code>string</code></td> <td>Allowed values: <code>national</code> or <code>official</code></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>policy_areas</strong> </td> <td></td></tr>
<tr><td><strong>taxons</strong> </td> <td></td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>topics</strong> </td> <td></td></tr>
<tr><td><strong>parent</strong> </td> <td></td></tr>
<tr><td><strong>policies</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>statistics_announcement</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### cancelled_official_statistics.json
```json
{
  "content_id": "e1553ea5-69e7-443e-a9b5-e5e8210097f5",
  "base_path": "/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015",
  "description": "The Diagnostic Imaging Dataset (DID) is a new central collection of detailed information about diagnostic imaging tests carried out on NHS patients, extracted from local Radiology Information Systems (RISs) and submitted monthly. The DID captures information about referral source and patient type, details of the test (type of test and body site), demographic information such as GP registered practice, patient postcode, ethnicity, gender and date of birth, plus items about waiting times for each diagnostic imaging event, from time of test request through to time of reporting. The Health and Social Care Information Centre collect the dataset at patient level. It is reported here in summary form.",
  "details": {
    "display_date": "20 January 2016 9:30am",
    "state": "cancelled",
    "format_sub_type": "official",
    "cancelled_at": "2016-01-17T14:19:42.460Z",
    "cancellation_reason": "Official Statistics"
  },
  "format": "statistics_announcement",
  "links": {
    "organisations": [
      {
        "content_id": "8b19c238-54e3-4e27-b0d7-60f8e2a677c9",
        "title": "NHS England",
        "base_path": "/government/organisations/nhs-commissioning-board",
        "api_url": "https://www.gov.uk/api/content/government/organisations/nhs-commissioning-board",
        "web_url": "https://www.gov.uk/government/organisations/nhs-commissioning-board",
        "locale": "en",
        "analytics_identifier": "L2"
      }
    ],
    "policy_areas": [
      {
        "content_id": "848b8564-328c-4787-bebb-9e1b60ccf0d7",
        "title": "National Health Service",
        "base_path": "/government/topics/national-health-service",
        "api_url": "https://www.gov.uk/api/content/government/topics/national-health-service",
        "web_url": "https://www.gov.uk/government/topics/national-health-service",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2016-01-17T14:19:42.460Z",
  "title": "Diagnostic imaging dataset for September 2015",
  "updated_at": "2016-01-17T14:19:42.460Z",
  "schema_name": "statistics_announcement",
  "document_type": "statistics_announcement"
}

```

### national_statistics.json
```json
{
  "content_id": "e1553ea5-69e7-443e-a9b5-e5e8210097f5",
  "base_path": "/government/statistics/announcements/uk-armed-forces-quarterly-personnel-report-october-2015",
  "description": "Quarterly statistics on strengths, requirements, intakes and outflows from the UK armed forces by service for 2015.",
  "details": {
    "display_date": "January 2016",
    "state": "provisional",
    "format_sub_type": "national"
  },
  "format": "statistics_announcement",
  "links": {
    "organisations": [
      {
        "content_id": "8b19c238-54e3-4e27-b0d7-60f8e2a677c9",
        "title": "Ministry of Defence",
        "base_path": "/government/organisations/ministry-of-defence",
        "api_url": "https://www.gov.uk/api/government/organisations/ministry-of-defence",
        "web_url": "https://www.gov.uk/government/organisations/ministry-of-defence",
        "locale": "en",
        "analytics_identifier": "L2"
      }
    ],
    "policy_areas": [
      {
        "content_id": "848b8564-328c-4787-bebb-9e1b60ccf0d7",
        "title": "Defence and armed forces",
        "base_path": "/government/topics/defence-and-armed-forces",
        "api_url": "https://www.gov.uk/api/content/government/topics/defence-and-armed-forces",
        "web_url": "https://www.gov.uk/government/topics/defence-and-armed-forces",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2014-11-17T14:19:42.460Z",
  "title": "UK armed forces quarterly personnel report: 1 October 2015",
  "updated_at": "2014-11-17T14:19:42.460Z",
  "schema_name": "statistics_announcement",
  "document_type": "statistics_announcement"
}

```

### official_statistics.json
```json
{
  "content_id": "e1553ea5-69e7-443e-a9b5-e5e8210097f5",
  "base_path": "/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015--2",
  "description": "The Diagnostic Imaging Dataset (DID) is a new central collection of detailed information about diagnostic imaging tests carried out on NHS patients, extracted from local Radiology Information Systems (RISs) and submitted monthly. The DID captures information about referral source and patient type, details of the test (type of test and body site), demographic information such as GP registered practice, patient postcode, ethnicity, gender and date of birth, plus items about waiting times for each diagnostic imaging event, from time of test request through to time of reporting. The Health and Social Care Information Centre collect the dataset at patient level. It is reported here in summary form.",
  "details": {
    "display_date": "20 January 2016 9:30am",
    "state": "confirmed",
    "format_sub_type": "official"
  },
  "format": "statistics_announcement",
  "links": {
    "organisations": [
      {
        "content_id": "8b19c238-54e3-4e27-b0d7-60f8e2a677c9",
        "title": "NHS England",
        "base_path": "/government/organisations/nhs-commissioning-board",
        "api_url": "https://www.gov.uk/api/content/government/organisations/nhs-commissioning-board",
        "web_url": "https://www.gov.uk/government/organisations/nhs-commissioning-board",
        "locale": "en",
        "analytics_identifier": "L2"
      }
    ],
    "policy_areas": [
      {
        "content_id": "848b8564-328c-4787-bebb-9e1b60ccf0d7",
        "title": "National Health Service",
        "base_path": "/government/topics/national-health-service",
        "api_url": "https://www.gov.uk/api/content/government/topics/national-health-service",
        "web_url": "https://www.gov.uk/government/topics/national-health-service",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2016-01-17T14:19:42.460Z",
  "title": "Diagnostic imaging dataset for September 2015",
  "updated_at": "2016-01-17T14:19:42.460Z",
  "schema_name": "statistics_announcement",
  "document_type": "statistics_announcement"
}

```

### release_date_changed.json
```json
{
  "content_id": "e1553ea5-69e7-443e-a9b5-e5e8210097f5",
  "base_path": "/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015--1",
  "description": "The Diagnostic Imaging Dataset (DID) is a new central collection of detailed information about diagnostic imaging tests carried out on NHS patients, extracted from local Radiology Information Systems (RISs) and submitted monthly. The DID captures information about referral source and patient type, details of the test (type of test and body site), demographic information such as GP registered practice, patient postcode, ethnicity, gender and date of birth, plus items about waiting times for each diagnostic imaging event, from time of test request through to time of reporting. The Health and Social Care Information Centre collect the dataset at patient level. It is reported here in summary form.",
  "details": {
    "display_date": "20 January 2016 9:30am",
    "state": "confirmed",
    "format_sub_type": "official",
    "previous_display_date": "19 January 2016 9:30am",
    "latest_change_note": "Amended after inputting an error."
  },
  "format": "statistics_announcement",
  "links": {
    "organisations": [
      {
        "content_id": "8b19c238-54e3-4e27-b0d7-60f8e2a677c9",
        "title": "NHS England",
        "base_path": "/government/organisations/nhs-commissioning-board",
        "api_url": "https://www.gov.uk/api/content/government/organisations/nhs-commissioning-board",
        "web_url": "https://www.gov.uk/government/organisations/nhs-commissioning-board",
        "locale": "en",
        "analytics_identifier": "L2"
      }
    ],
    "policy_areas": [
      {
        "content_id": "848b8564-328c-4787-bebb-9e1b60ccf0d7",
        "title": "National Health Service",
        "base_path": "/government/topics/national-health-service",
        "api_url": "https://www.gov.uk/api/content/government/topics/national-health-service",
        "web_url": "https://www.gov.uk/government/topics/national-health-service",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2016-01-17T14:19:42.460Z",
  "title": "Diagnostic imaging dataset for September 2015",
  "updated_at": "2016-01-17T14:19:42.460Z",
  "schema_name": "statistics_announcement",
  "document_type": "statistics_announcement"
}

```



