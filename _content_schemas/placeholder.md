---
layout: content_schema
title:  Placeholder
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/placeholder/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>change_note</strong> <code>["string", "null"]</code></td> <td></td></tr>
<tr><td><strong>start_date</strong> <code>string</code></td> <td>Used for topical events, so that related documents can get the date. Remove when topical events are migrated.</td></tr>
<tr><td><strong>end_date</strong> <code>string</code></td> <td>Used for topical events, so that related documents can get the date. Remove when topical events are migrated.</td></tr>
<tr><td><strong>brand</strong> <code>["string", "null"]</code></td> <td>Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.</td></tr>
<tr><td><strong>logo</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>formatted_title</strong> <code>string</code></td> <td>Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.</td></tr>
<tr><td><strong>crest</strong> <code>["string", "null"]</code></td> <td>Allowed values: <code>bis</code> or <code>eo</code> or <code>hmrc</code> or <code>ho</code> or <code>mod</code> or <code>portcullis</code> or <code>single-identity</code> or <code>so</code> or <code>ukaea</code> or <code>wales</code> or <code></code>Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.</td></tr></table></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>primary_topic</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>additional_topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.</td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/placeholder/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/placeholder/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>change_note</strong> <code>["string", "null"]</code></td> <td></td></tr>
<tr><td><strong>start_date</strong> <code>string</code></td> <td>Used for topical events, so that related documents can get the date. Remove when topical events are migrated.</td></tr>
<tr><td><strong>end_date</strong> <code>string</code></td> <td>Used for topical events, so that related documents can get the date. Remove when topical events are migrated.</td></tr>
<tr><td><strong>brand</strong> <code>["string", "null"]</code></td> <td>Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.</td></tr>
<tr><td><strong>logo</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>formatted_title</strong> <code>string</code></td> <td>Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.</td></tr>
<tr><td><strong>crest</strong> <code>["string", "null"]</code></td> <td>Allowed values: <code>bis</code> or <code>eo</code> or <code>hmrc</code> or <code>ho</code> or <code>mod</code> or <code>portcullis</code> or <code>single-identity</code> or <code>so</code> or <code>ukaea</code> or <code>wales</code> or <code></code>Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.</td></tr></table></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>primary_topic</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>additional_topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.</td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### battle-of-the-somme-centenary-commemorations.json
```json
{
  "content_id": "8b19c222-54e3-4e27-b0d7-67f8e2a677c9",
  "base_path": "/government/topical-events/battle-of-the-somme-centenary-commemorations",
  "title": "Battle of the Somme Centenary",
  "description": "",
  "format": "placeholder_topical_event",
  "locale": "en",
  "need_ids": [

  ],
  "public_updated_at": "2015-07-04T11:32:28.000+01:00",
  "details": {
  },
  "schema_name": "placeholder_topical_event",
  "document_type": "placeholder_topical_event",
  "links": {
  }
}

```

### ebola-virus-government-response.json
```json
{
  "content_id": "8b19c222-54e3-4e27-b0d7-67f8e2a677c9",
  "base_path": "/government/topical-events/ebola-virus-government-response",
  "title": "Ebola virus: UK government response",
  "description": "",
  "format": "placeholder_topical_event",
  "locale": "en",
  "need_ids": [

  ],
  "public_updated_at": "2015-09-14T17:15:48.000+01:00",
  "details": {
    "start_date": "2015-03-11T00:00:00.000+00:00",
    "end_date": "2016-03-11T00:00:00.000+00:00"
  },
  "schema_name": "placeholder_topical_event",
  "document_type": "placeholder_topical_event",
  "links": {
  }
}

```

### organisation.json
```json
{
  "base_path": "/government/organisations/bona-vacantia",
  "content_id": "c9109663-0128-4db4-b513-a9cdfb691034",
  "title": "Bona Vacantia",
  "format": "placeholder",
  "document_type": "organisation",
  "schema_name": "placeholder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-03-09T15:42:28.867Z",
  "public_updated_at": "2015-03-31T18:33:12.000+00:00",
  "phase": "live",
  "analytics_identifier": "OT564",
  "links": {
    "available_translations": [
      {
        "content_id": "c9109663-0128-4db4-b513-a9cdfb691034",
        "title": "Bona Vacantia",
        "base_path": "/government/organisations/bona-vacantia",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/government/organisations/bona-vacantia",
        "web_url": "https://www.gov.uk/government/organisations/bona-vacantia",
        "locale": "en",
        "analytics_identifier": "OT564",
        "links": {}
      }
    ]
  },
  "details": {
    "brand": "attorney-generals-office",
    "logo": {
      "formatted_title": "Bona Vacantia",
      "crest": "single-identity"
    }
  }
}

```

### placeholder.json
```json
{
  "base_path": "/some-placeholder",
  "content_id": "5c806926-7631-11e4-a3cb-005056011aea",
  "title": "Some placeholder",
  "format": "placeholder",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-12-02T10:51:26.334Z",
  "public_updated_at": "2011-11-17T00:00:00.000+00:00",
  "phase": "live",
  "links": {},
  "description": "A placeholder",
  "details": {},
  "schema_name": "placeholder",
  "document_type": "placeholder"
}

```



