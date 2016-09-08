---
layout: content_schema
title:  Topic
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/topic/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>internal_name</strong> <code>string</code></td> <td>An internal name for admin interfaces. Includes parent.</td></tr>
<tr><td><strong>beta</strong> <code>boolean</code> or <code>null</code></td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>topic</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/topic/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>children</strong> </td> <td>Any child topics</td></tr>
<tr><td><strong>linked_items</strong> </td> <td>Includes all content ids referenced in 'details'. This is a temporary measure to expand content ids for frontends which is planned to be replaced by a dependency resolution service.</td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/topic/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>internal_name</strong> <code>string</code></td> <td>An internal name for admin interfaces. Includes parent.</td></tr>
<tr><td><strong>beta</strong> <code>boolean</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>groups</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>children</strong> </td> <td></td></tr>
<tr><td><strong>linked_items</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>topic</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### curated_subtopic.json
```json
{
  "content_id": "e8238ae7-39a7-47c4-bc3a-501da0b55afe",
  "base_path": "/topic/oil-and-gas/offshore",
  "description": "A page about offshore oil and gas",
  "details": {
    "groups": [
      {
        "name": "Oil rigs",
        "contents": [
          "/oil-rig-safety-requirements",
          "/oil-rig-staffing"
        ]
      },
      {
        "name": "Piping",
        "contents": [
          "/undersea-piping-restrictions"
        ]
      }
    ]
  },
  "format": "topic",
  "links": {
    "parent": [
      {
        "content_id": "9d7a445f-7451-4ef8-815e-ae66676a240b",
        "base_path": "/topic/oil-and-gas",
        "title": "Oil and gas",
        "api_url": "https://www.gov.uk/api/content/topic/oil-and-gas",
        "web_url": "https://www.gov.uk/topic/oil-and-gas",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Offshore",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "topic",
  "document_type": "topic"
}

```

### topic-in-beta.json
```json
{
  "content_id": "88df090f-8d1c-4629-b2f5-1f573b72b44e",
  "base_path": "/topic/oil-and-gas-beta",
  "description": "",
  "details": {
    "beta": true
  },
  "format": "topic",
  "links": {
    "children": []
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Oil and gas",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "topic",
  "document_type": "topic"
}

```

### topic.json
```json
{
  "content_id": "63d98739-fc60-4e28-a65f-edb56000fd39",
  "base_path": "/topic/oil-and-gas",
  "description": "",
  "details": {},
  "format": "topic",
  "links": {
    "children": [
      {
        "content_id": "f6eef5ca-be55-41b2-98be-f72b3e649b84",
        "base_path": "/topic/oil-and-gas/fields-and-wells",
        "title": "Fields and wells",
        "api_url": "https://www.gov.uk/api/content/topic/oil-and-gas/fields-and-wells",
        "web_url": "https://www.gov.uk/topic/oil-and-gas/fields-and-wells",
        "locale": "en"
      },
      {
        "content_id": "0a6116da-fbf6-4d5c-baa9-2a74ae8a8fb9",
        "base_path": "/topic/oil-and-gas/licensing",
        "title": "Licensing",
        "api_url": "https://www.gov.uk/api/content/topic/oil-and-gas/licensing",
        "web_url": "https://www.gov.uk/topic/oil-and-gas/licensing",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Oil and gas",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "topic",
  "document_type": "topic"
}

```

### uncurated_subtopic.json
```json
{
  "content_id": "ee990f3e-5aee-4a09-a247-70177ea23690",
  "base_path": "/topic/oil-and-gas/licensing",
  "description": "A page about oil and gas licensing",
  "details": {},
  "format": "topic",
  "links": {
    "parent": [
      {
        "content_id": "a6510b11-75c8-4df3-be2d-17d0e2c081be",
        "base_path": "/topic/oil-and-gas",
        "title": "Oil and gas",
        "api_url": "https://www.gov.uk/api/content/topic/oil-and-gas",
        "web_url": "https://www.gov.uk/topic/oil-and-gas",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2015-04-20T15:46:10.000+00:00",
  "title": "Oil and gas: Licensing",
  "updated_at": "2015-04-20T15:50:11.000+00:00",
  "schema_name": "topic",
  "document_type": "topic"
}

```



