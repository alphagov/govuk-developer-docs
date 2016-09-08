---
layout: content_schema
title:  Service manual guide
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/service_manual_guide/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>show_description</strong> <code>boolean</code></td> <td>Display the description on the page if true. This is needed for the service standard points.</td></tr>
<tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>header_links</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>service_manual_guide</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/service_manual_guide/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_owners</strong> </td> <td>References a page of a GDS community responsible for maintaining the guide e.g. Agile delivery community, Design community</td></tr>
<tr><td><strong>service_manual_topics</strong> </td> <td>References an array of 'service_manual_topic's. Not to be confused with 'topics'.</td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/service_manual_guide/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>show_description</strong> <code>boolean</code></td> <td>Display the description on the page if true. This is needed for the service standard points.</td></tr>
<tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>header_links</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_owners</strong> </td> <td></td></tr>
<tr><td><strong>service_manual_topics</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>service_manual_guide</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### point_page.json
```json
{
  "content_id": "fb81a47b-7c8f-4280-b6c7-b6fa25822222",
  "public_updated_at": "2015-10-09T08:17:10+00:00",
  "format": "service_manual_guide",
  "locale": "en",
  "base_path": "/service-standard/service-standard/understand-user-needs",
  "description": "Understand user needs. Research to develop a deep knowledge of who the service users are and what that means for the design of the service.",
  "title": "1. Understand user needs",
  "updated_at": "2015-10-12T08:54:30+00:00",
  "schema_name": "service_manual_guide",
  "document_type": "service_manual_guide",
  "details": {
    "show_description": true,
    "body": "<h2>Why it's in the standard</h2>\n<p>You need to know the people who use your service (your users) and what they want to do (their user needs) if you want to build a service that works for them.</p>\n",
    "header_links": [
      {
        "title": "Why it's in the standard",
        "href": "#why-its-in-the-standard"
      }
    ],
    "change_history": [
      {
        "public_timestamp": "2015-10-07T08:17:10+00:00",
        "note": "This is our latest change",
        "reason_for_change": "This is the reason for our latest change"
      },
      {
        "public_timestamp": "2015-09-09T08:17:10+00:00",
        "note": "This is another change",
        "reason_for_change": "This is why we made this change\nand it has a second line of text"
      },
      {
        "public_timestamp": "2015-09-01T08:17:10+00:00",
        "note": "Guidance first published",
        "reason_for_change": ""
      }
    ]
  },
  "links": {
    "parent": [
      {
        "analytics_identifier": null,
        "api_url": "http://www.dev.gov.uk/api/content/service-manual/service-standard",
        "base_path": "/service-manual/service-standard",
        "content_id": "00f693d4-866a-4fe6-a8d6-09cd7db8980b",
        "description": null,
        "locale": "en",
        "public_updated_at": "2016-06-22T10:35:24.641Z",
        "title": "The Digital Service Standard",
        "web_url": "http://www.dev.gov.uk/service-manual/service-standard",
        "expanded_links": {}
      }
    ]
  }
}

```

### service_manual_guide.json
```json
{
  "content_id": "fb81a47b-7c8f-4280-b6c7-b6fa25822222",
  "public_updated_at": "2015-10-09T08:17:10+00:00",
  "format": "service_manual_guide",
  "locale": "en",
  "details": {
    "body": "<h2 id=\"what\">What it is, why it works and how to do it</h2>\n<p>Agile methodologies will help you and your team to build world-class, user-centred services quickly and affordably.</p>\n",
    "header_links": [
      {
        "title": "What is it, why it works and how to do it",
        "href": "#what-is-it-why-it-works-and-how-to-do-it"
      }
    ],
    "change_history": [
      {
        "public_timestamp": "2015-10-07T08:17:10+00:00",
        "note": "This is our latest change",
        "reason_for_change": "This is the reason for our latest change"
      },
      {
        "public_timestamp": "2015-09-09T08:17:10+00:00",
        "note": "This is another change",
        "reason_for_change": "This is why we made this change\nand it has a second line of text"
      },
      {
        "public_timestamp": "2015-09-01T08:17:10+00:00",
        "note": "Guidance first published",
        "reason_for_change": ""
      }
    ]
  },
  "links": {
    "content_owners": [
      {
        "content_id": "e5f09422-bf55-417c-b520-8a42cb409814",
        "title": "Agile delivery community",
        "base_path": "/service-manual/communities/agile-delivery-community",
        "description": "Agile delivery community takes care of...",
        "api_url": "http://content-store.dev.gov.uk/content/service-manual/communities/agile-delivery-community",
        "web_url": "http://www.dev.gov.uk/service-manual/communities/agile-delivery-community",
        "locale": "en",
        "analytics_identifier": null
      }
    ],
    "service_manual_topics": [
      {
        "content_id": "370e00b2-3c79-4816-aaa9-1a7059e6155d",
        "title": "Agile",
        "base_path": "/service-manual/agile",
        "description": "",
        "api_url": "https://content-store.gov.uk/content/service-manual/agile",
        "web_url": "https://www.gov.uk/service-manual/agile",
        "locale": "en",
        "schema_name": "service_manual_topic",
        "document_type": "service_manual_topic",
        "analytics_identifier": null,
        "links": {
          "linked_items": [
            "fb81a47b-7c8f-4280-b6c7-b6fa25822222"
          ],
          "content_owners": [
            "e50286e4-2d79-44aa-bcf4-f024e5e17061"
          ],
          "organisations": [
            "af07d5a5-df63-4ddc-9383-6a666845ebe9"
          ]
        }
      }
    ]
  },
  "base_path": "/service-manual/agile/agile-delivery",
  "description": "What agile is, why it works and how to do it",
  "title": "Agile Delivery",
  "updated_at": "2015-10-12T08:54:30+00:00",
  "schema_name": "service_manual_guide",
  "document_type": "service_manual_guide"
}

```

### service_manual_guide_community.json
```json
{
  "content_id": "fb81a47b-7c8f-4280-b6c7-b6fa25822222",
  "public_updated_at": "2015-10-09T08:17:10+00:00",
  "format": "service_manual_guide",
  "locale": "en",
  "details": {
    "body": "<h2 id=\"what\">What it is, why it works and how to do it</h2>\n<p>Agile methodologies will help you and your team to build world-class, user-centred services quickly and affordably.</p>\n",
    "header_links": [
      {
        "title": "What is it, why it works and how to do it",
        "href": "#what-is-it-why-it-works-and-how-to-do-it"
      }
    ],
    "change_history": [
      {
        "public_timestamp": "2015-10-07T08:17:10+00:00",
        "note": "This is our latest change",
        "reason_for_change": "This is the reason for our latest change"
      },
      {
        "public_timestamp": "2015-09-09T08:17:10+00:00",
        "note": "This is another change",
        "reason_for_change": "This is why we made this change\nand it has a second line of text"
      },
      {
        "public_timestamp": "2015-09-01T08:17:10+00:00",
        "note": "Guidance first published",
        "reason_for_change": ""
      }
    ]
  },
  "links": {
    "service_manual_topics": [
      {
        "content_id": "370e00b2-3c79-4816-aaa9-1a7059e6155d",
        "title": "Communities",
        "base_path": "/service-manual/communities",
        "description": "",
        "api_url": "https://content-store.gov.uk/content/service-manual/communities",
        "web_url": "https://www.gov.uk/service-manual/communities",
        "locale": "en",
        "schema_name": "service_manual_topic",
        "document_type": "service_manual_topic",
        "analytics_identifier": null,
        "links": {
          "linked_items": [
            "fb81a47b-7c8f-4280-b6c7-b6fa25822222"
          ],
          "content_owners": [
            "e50286e4-2d79-44aa-bcf4-f024e5e17061"
          ],
          "organisations": [
            "af07d5a5-df63-4ddc-9383-6a666845ebe9"
          ]
        }
      }
    ]
  },
  "base_path": "/service-manual/communities/agile-community",
  "description": "The agile community",
  "title": "Agile Community",
  "updated_at": "2015-10-12T08:54:30+00:00",
  "schema_name": "service_manual_guide",
  "document_type": "service_manual_guide"
}

```



