---
layout: content_schema
title:  Service manual topic
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/service_manual_topic/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>visually_collapsed</strong> <code>boolean</code></td> <td>A flag set by a content designer when they want the sections of a topic to be collapsed into an accordion. This will likely be used when there are many items in the topic.</td></tr>
<tr><td><strong>groups</strong> <code>array</code></td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>service_manual_topic</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/service_manual_topic/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>linked_items</strong> </td> <td>Includes all content ids referenced in 'details'. This is a temporary measure to expand content ids for frontends which is planned to be replaced by a dependency resolution service.</td></tr>
<tr><td><strong>content_owners</strong> </td> <td>References a page of a GDS community responsible for maintaining the guide e.g. Agile delivery community, Design community</td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/service_manual_topic/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>visually_collapsed</strong> <code>boolean</code></td> <td>A flag set by a content designer when they want the sections of a topic to be collapsed into an accordion. This will likely be used when there are many items in the topic.</td></tr>
<tr><td><strong>groups</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>linked_items</strong> </td> <td></td></tr>
<tr><td><strong>content_owners</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>service_manual_topic</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### service_manual_topic.json
```json
{
  "base_path": "/service-manual/test-expanded-topic",
  "content_id": "cd02b82d-c706-435c-a2fc-2dcabd168ef4",
  "title": "Service Manual Test Expanded Topic",
  "format": "service_manual_topic",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-01-15T16:53:47.645Z",
  "public_updated_at": "2016-01-15T15:31:21.000+00:00",
  "phase": "alpha",
  "analytics_identifier": null,
  "links": {
    "content_owners": [
      {
        "content_id": "fb87cca9-311e-4fd3-af42-03616164a407",
        "title": "Agile delivery community",
        "base_path": "/service-manual/communities/agile-delivery-community",
        "description": "Agile delivery community takes care of...",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/communities/agile-delivery-community",
        "web_url": "http://www.dev.gov.uk/service-manual/communities/agile-delivery-community",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "d6f49e7f-4f54-44e6-815b-ac3098a5f509",
        "title": "User research community",
        "base_path": "/service-manual/communities/user-research-community",
        "description": "User research community takes care of...",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/communities/user-research-community",
        "web_url": "http://www.dev.gov.uk/service-manual/communities/user-research-community",
        "locale": "en",
        "analytics_identifier": null
      }
    ],
    "linked_items": [
      {
        "content_id": "60b91f03-9dfe-4cb1-a01b-d0391b261cd8",
        "title": "Helpdesk",
        "base_path": "/service-manual/operations/helpdesk",
        "description": "Description",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/operations/helpdesk",
        "web_url": "http://www.dev.gov.uk/service-manual/operations/helpdesk",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "0c23c42e-d1ae-433a-834b-ebc5e4c3785f",
        "title": "Accessibility",
        "base_path": "/service-manual/user-centred-design/accessibility",
        "description": "Description",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/user-centred-design/accessibility",
        "web_url": "http://www.dev.gov.uk/service-manual/user-centred-design/accessibility",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "56b79735-fd9b-4119-a9f4-682098087953",
        "title": "Addresses",
        "base_path": "/service-manual/user-centred-design/resources/patterns/addresses",
        "description": "Description",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/user-centred-design/resources/patterns/addresses",
        "web_url": "http://www.dev.gov.uk/service-manual/user-centred-design/resources/patterns/addresses",
        "locale": "en",
        "analytics_identifier": null
      }
    ],
    "available_translations": [
      {
        "content_id": "cd02b82d-c706-435c-a2fc-2dcabd168ef4",
        "title": "This should be looking goooooood",
        "base_path": "/service-manual/test-topic",
        "description": "A good lookin topic",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/test-topic",
        "web_url": "http://www.dev.gov.uk/service-manual/test-topic",
        "locale": "en"
      }
    ]
  },
  "description": "Service Manual Topic description",
  "details": {
    "groups": [
      {
        "name": "Group 1",
        "description": "The first group",
        "content_ids": [
          "0c23c42e-d1ae-433a-834b-ebc5e4c3785f",
          "56b79735-fd9b-4119-a9f4-682098087953"
        ]
      },
      {
        "name": "Group 2",
        "description": "The second group",
        "content_ids": [
          "60b91f03-9dfe-4cb1-a01b-d0391b261cd8",
          "65744959-71cc-495c-922e-da4709a5f89b"
        ]
      }
    ]
  },
  "schema_name": "service_manual_topic",
  "document_type": "service_manual_topic"
}

```

### service_manual_topic_collapsed.json
```json
{
  "base_path": "/service-manual/test-topic",
  "content_id": "cd02b82d-c706-435c-a2fc-2dcabd168ef4",
  "title": "Service Manual Test Topic",
  "format": "service_manual_topic",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-01-15T16:53:47.645Z",
  "public_updated_at": "2016-01-15T15:31:21.000+00:00",
  "phase": "alpha",
  "analytics_identifier": null,
  "links": {
    "content_owners": [
      {
        "content_id": "fb87cca9-311e-4fd3-af42-03616164a407",
        "title": "Agile delivery community",
        "base_path": "/service-manual/communities/agile-delivery-community",
        "description": "Agile delivery community takes care of...",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/communities/agile-delivery-community",
        "web_url": "http://www.dev.gov.uk/service-manual/communities/agile-delivery-community",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "d6f49e7f-4f54-44e6-815b-ac3098a5f509",
        "title": "User research community",
        "base_path": "/service-manual/communities/user-research-community",
        "description": "User research community takes care of...",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/communities/user-research-community",
        "web_url": "http://www.dev.gov.uk/service-manual/communities/user-research-community",
        "locale": "en",
        "analytics_identifier": null
      }
    ],
    "linked_items": [
      {
        "content_id": "60b91f03-9dfe-4cb1-a01b-d0391b261cd8",
        "title": "Helpdesk",
        "base_path": "/service-manual/operations/helpdesk",
        "description": "Description",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/operations/helpdesk",
        "web_url": "http://www.dev.gov.uk/service-manual/operations/helpdesk",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "0c23c42e-d1ae-433a-834b-ebc5e4c3785f",
        "title": "Accessibility",
        "base_path": "/service-manual/user-centred-design/accessibility",
        "description": "Description",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/user-centred-design/accessibility",
        "web_url": "http://www.dev.gov.uk/service-manual/user-centred-design/accessibility",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "56b79735-fd9b-4119-a9f4-682098087953",
        "title": "Addresses",
        "base_path": "/service-manual/user-centred-design/resources/patterns/addresses",
        "description": "Description",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/user-centred-design/resources/patterns/addresses",
        "web_url": "http://www.dev.gov.uk/service-manual/user-centred-design/resources/patterns/addresses",
        "locale": "en",
        "analytics_identifier": null
      }
    ],
    "available_translations": [
      {
        "content_id": "cd02b82d-c706-435c-a2fc-2dcabd168ef4",
        "title": "This should be looking goooooood",
        "base_path": "/service-manual/test-topic",
        "description": "A good lookin topic",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/test-topic",
        "web_url": "http://www.dev.gov.uk/service-manual/test-topic",
        "locale": "en"
      }
    ]
  },
  "description": "Service Manual Topic description",
  "details": {
    "visually_collapsed": true,
    "groups": [
      {
        "name": "Group 1",
        "description": "The first group",
        "content_ids": [
          "0c23c42e-d1ae-433a-834b-ebc5e4c3785f",
          "56b79735-fd9b-4119-a9f4-682098087953"
        ]
      },
      {
        "name": "Group 2",
        "description": "The second group",
        "content_ids": [
          "60b91f03-9dfe-4cb1-a01b-d0391b261cd8",
          "65744959-71cc-495c-922e-da4709a5f89b"
        ]
      }
    ]
  },
  "schema_name": "service_manual_topic",
  "document_type": "service_manual_topic"
}

```

### service_manual_topic_without_sections.json
```json
{
  "base_path": "/service-manual/service-assessments",
  "content_id": "20c9788e-4e74-4cfe-939b-61fcf47962e0",
  "title": "Service assessments",
  "format": "service_manual_topic",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-01-15T16:53:47.645Z",
  "public_updated_at": "2016-01-15T15:31:21.000+00:00",
  "phase": "alpha",
  "analytics_identifier": null,
  "links": {
    "content_owners": [
      {
        "content_id": "c5042bc1-d95c-41d7-8742-1f0b59f891ff",
        "title": "Standards and assurance community",
        "base_path": "/service-manual/communities/standards-and-assurance-community",
        "description": "The standards and assurance community is for anyone with an interest in government standards and how they can be used to build high quality digital services.",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/communities/standards-and-assurance-community",
        "web_url": "http://www.dev.gov.uk/service-manual/communities/standards-and-assurance-community",
        "locale": "en",
        "analytics_identifier": null
      }
    ],
    "linked_items": [
      {
        "content_id": "a69b577d-8660-4bee-90de-e5ac3b267a03",
        "title": "How service assessments work",
        "base_path": "/service-manual/service-assessments/how-service-assessments-work",
        "description": "What happens at a service assessment and what to do when you get your results.",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/service-assessments/how-service-assessments-work",
        "web_url": "http://www.dev.gov.uk/service-manual/service-assessments/how-service-assessments-work",
        "locale": "en",
        "analytics_identifier": null
      },
      {
        "content_id": "5394d049-1f7d-466e-af1a-44afd7dab46f",
        "title": "Check if you need to get your service assessed",
        "base_path": "/service-manual/service-assessments/check-if-you-need-a-service-assessment",
        "description": "How to find out if your service needs to be assessed and arrange your 3 assessments.",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/service-assessments/check-if-you-need-a-service-assessment",
        "web_url": "http://www.dev.gov.uk/service-manual/service-assessments/check-if-you-need-a-service-assessment",
        "locale": "en",
        "analytics_identifier": null
      }
    ]
  },
  "description": "Check if you need a service assessment and find out how to book one.",
  "details": {
    "visually_collapsed": true,
    "groups": [
      {
        "name": "",
        "description": "",
        "content_ids": [
          "a69b577d-8660-4bee-90de-e5ac3b267a03",
          "5394d049-1f7d-466e-af1a-44afd7dab46f"
        ]
      }
    ]
  },
  "schema_name": "service_manual_topic",
  "document_type": "service_manual_topic"
}

```



