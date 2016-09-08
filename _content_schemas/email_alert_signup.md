---
layout: content_schema
title:  Email alert signup
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/email_alert_signup/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>subscriber_list</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>countries</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td>The document_type used to match subscribers lists</td></tr></table></td></tr>
<tr><td><strong>email_alert_type</strong> <code>string</code></td> <td>Allowed values: <code>topics</code> or <code>policies</code> or <code>countries</code></td></tr>
<tr><td><strong>summary</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>breadcrumbs</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>govdelivery_title</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>email_alert_signup</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/email_alert_signup/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/email_alert_signup/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>subscriber_list</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>countries</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td>The document_type used to match subscribers lists</td></tr></table></td></tr>
<tr><td><strong>email_alert_type</strong> <code>string</code></td> <td>Allowed values: <code>topics</code> or <code>policies</code> or <code>countries</code></td></tr>
<tr><td><strong>summary</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>breadcrumbs</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>govdelivery_title</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>email_alert_signup</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### policy_email_alert_signup.json
```json
{
  "content_id": "2ac1ff8b-2869-445d-9268-d90c96f3f67c",
  "base_path": "/government/policies/employment/email-signup",
  "title": "Employment",
  "description": "",
  "format": "email_alert_signup",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-04-14T13:11:45.809Z",
  "public_updated_at": "2015-04-14T10:56:00.000+00:00",
  "details": {
    "email_alert_type": "policies",
    "subscriber_list": {
      "tags": {
        "policies": [
          "employment"
        ]
      }
    },
    "breadcrumbs": [
      {
        "title": "Employment",
        "link": "https://www.gov.uk/government/policies/employment"
      }
    ],
    "summary": "You'll get an email each time any information on this policy is published or updated.",
    "govdelivery_title": "Employment policy"
  },
  "links": {
    "parent": [
      {
        "content_id": "f8c3682c-3a88-4f35-afba-3607384e39e6",
        "title": "Benefits Reform",
        "base_path": "/government/policies/benefits-reform",
        "locale": "en"
      }
    ]
  },
  "schema_name": "email_alert_signup",
  "document_type": "email_alert_signup"
}

```

### travel_advice_country_email_alert_signup.json
```json
{
  "analytics_identifier": null,
  "base_path": "/foreign-travel-advice/afghanistan/email-signup",
  "content_id": "46a855db-51ff-4bf2-b31b-a61bceb9ab43",
  "description": "Afghanistan travel advice Email Alert Signup",
  "details": {
    "breadcrumbs": [
      {
        "link": "/foreign-travel-advice/afghanistan",
        "title": "Afghanistan travel advice"
      }
    ],
    "govdelivery_title": "Afghanistan travel advice",
    "subscriber_list": {
      "document_type": "travel_advice",
      "links": {
        "countries": [
          "5a292f20-a9b6-46ea-b35f-584f8b3d7392"
        ]
      }
    },
    "summary": "You'll get an email each time Afghanistan travel advice is updated."
  },
  "format": "email_alert_signup",
  "links": { },
  "locale": "en",
  "need_ids": [],
  "phase": "live",
  "public_updated_at": "2016-03-09T10:13:52.000+00:00",
  "title": "Afghanistan travel advice",
  "updated_at": "2016-03-09T10:13:52.428Z",
  "schema_name": "email_alert_signup",
  "document_type": "email_alert_signup"
}

```

### travel_advice_index_email_alert_signup.json
```json
{
  "analytics_identifier": null,
  "base_path": "/foreign-travel-advice/email-signup",
  "content_id": "1aebfc97-7723-4cb6-82f4-434639efc185",
  "description": "Foreign travel advice email alert signup",
  "details": {
    "breadcrumbs": [
      {
        "link": "/foreign-travel-advice",
        "title": "Foreign travel advice"
      }
    ],
    "govdelivery_title": "Foreign travel advice",
    "subscriber_list": {
      "document_type": "travel_advice"
    },
    "summary": "You'll get an email each time a country is updated."
  },
  "format": "email_alert_signup",
  "links": {},
  "locale": "en",
  "need_ids": [],
  "phase": "live",
  "public_updated_at": "2016-03-09T10:13:07.000+00:00",
  "title": "Foreign travel advice",
  "updated_at": "2016-03-09T10:13:07.444Z",
  "schema_name": "email_alert_signup",
  "document_type": "email_alert_signup"
}

```



