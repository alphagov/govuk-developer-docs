---
layout: content_schema
title:  Travel advice index
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/travel_advice_index/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>email_signup_link</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>countries</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>max_cache_time</strong> <code>integer</code></td> <td>The maximum length of time the content should be cached, in seconds.</td></tr>
<tr><td><strong>publishing_request_id</strong> <code>string</code></td> <td>A unique identifier used to track publishing requests to rendered content</td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>travel_advice_index</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/travel_advice_index/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/travel_advice_index/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>email_signup_link</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>countries</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>max_cache_time</strong> <code>integer</code></td> <td>The maximum length of time the content should be cached, in seconds.</td></tr>
<tr><td><strong>publishing_request_id</strong> <code>string</code></td> <td>A unique identifier used to track publishing requests to rendered content</td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>travel_advice_index</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### index.json
```json
{
  "content_id": "08d48cdd-6b50-43ff-a53b-beab47f4aab0",
  "base_path": "/foreign-travel-advice",
  "title": "Foreign travel advice",
  "description": "Latest travel advice by country including safety and security, entry requirements, travel warnings and health",
  "details": {
    "email_signup_link": "https://public.govdelivery.com/accounts/UKGOVUK/subscriber/topics?qsp=TRAVEL",
    "countries": [
      {
        "name": "Afghanistan",
        "base_path": "/foreign-travel-advice/afghanistan",
        "updated_at": "2016-01-01T00:00:00+00:00",
        "public_updated_at": "2015-01-01T00:00:00+00:00",
        "change_description": "Latest update: Summary - on 26 October 2015 a serious earthquake struck causing casualties around the country and affecting communications networks; if someone you know is likely to have been involved and you're unable to contact them, contact the British Embassy in Kabul",
        "synonyms": [

        ]
      },
      {
        "name": "Austria",
        "base_path": "/foreign-travel-advice/austria",
        "updated_at": "2016-01-02T00:00:00+00:00",
        "public_updated_at": "2015-01-02T00:00:00+00:00",
        "change_description": "Latest update: Summary – there’s ongoing disruption to rail and road transport; you should monitor local media and check with your transport provider or the Austrian Railways (OBB) website",
        "synonyms": [

        ]
      },
      {
        "name": "Finland",
        "base_path": "/foreign-travel-advice/finland",
        "updated_at": "2016-01-03T00:00:00+00:00",
        "public_updated_at": "2015-01-03T00:00:00+00:00",
        "change_description": "Latest update: Summary – removal of advice on Northern Ireland football match",
        "synonyms": [
          "arctic"
        ]
      },
      {
        "name": "India",
        "base_path": "/foreign-travel-advice/india",
        "updated_at": "2016-01-04T00:00:00+00:00",
        "public_updated_at": "2015-01-04T00:00:00+00:00",
        "change_description": "Latest update: Summary – removal of advice on Assam floods and the curfew in Srinagar ",
        "synonyms": [

        ]
      },
      {
        "name": "Malaysia",
        "base_path": "/foreign-travel-advice/malaysia",
        "updated_at": "2016-01-05T00:00:00+00:00",
        "public_updated_at": "2015-01-05T00:00:00+00:00",
        "change_description": "Latest update: Summary - haze can cause disruption to local, regional air travel and to government and private schools",
        "synonyms": [
          "Borneo"
        ]
      },
      {
        "name": "Spain",
        "base_path": "/foreign-travel-advice/spain",
        "updated_at": "2016-01-06T00:00:00+00:00",
        "public_updated_at": "2015-01-06T00:00:00+00:00",
        "change_description": "Latest update: Summary – information and advice for Manchester City fans travelling to Seville ",
        "synonyms": [
          "Ibiza",
          "Majorca",
          "Mallorca",
          "Lanzarote",
          "Barcelona",
          "Benidorm",
          "Tenerife",
          "Canary Islands",
          "Canaries",
          "Gran Canaria"
        ]
      }
    ],
    "max_cache_time": 10,
    "publishing_request_id": "2546-1460985144476-19268198-3242"
  },
  "format": "travel_advice_index",
  "links": {
    "mainstream_browse_pages": [
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en"
      },
      {
        "content_id": "bbb8985a-5451-4e9d-a601-8c55853a096c",
        "title": "Living abroad",
        "base_path": "/browse/abroad/living-abroad",
        "api_url": "https://www.gov.uk/api/content/browse/abroad/living-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/living-abroad",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "8b19c238-54e3-4e27-b0d7-60f8e2a677c9",
        "title": "Foreign & Commonwealth Office",
        "base_path": "/government/organisations/foreign-commonwealth-office",
        "api_url": "https://www.gov.uk/api/content/government/organisations/foreign-commonwealth-office",
        "web_url": "https://www.gov.uk/government/government/organisations/foreign-commonwealth-office",
        "locale": "en"
      }
    ],
    "related": [
      {
        "content_id": "95f9c380-30bc-44c7-86b4-e9c9ef0fc272",
        "title": "Hand luggage restrictions at UK airports",
        "base_path": "/hand-luggage-restrictions",
        "api_url": "https://www.gov.uk/api/content/hand-luggage-restrictions",
        "web_url": "https://www.gov.uk/hand-luggage-restrictions",
        "locale": "en"
      },
      {
        "content_id": "e4d06cb9-9e2e-4e82-b802-0aad013ae16c",
        "title": "Driving abroad",
        "base_path": "/driving-abroad",
        "api_url": "https://www.gov.uk/api/content/driving-abroad",
        "web_url": "https://www.gov.uk/driving-abroad",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "08d48cdd-6b50-43ff-a53b-beab47f4aab0",
        "title": "Foreign travel advice",
        "base_path": "/foreign-travel-advice",
        "api_url": "https://www.gov.uk/api/content/foreign-travel-advice",
        "web_url": "https://www.gov.uk/foreign-travel-advice",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [
    "101191"
  ],
  "public_updated_at": "2015-04-28T17:11:23+01:00",
  "updated_at": "2015-08-28T17:16:43+01:00",
  "schema_name": "travel_advice_index",
  "document_type": "travel_advice_index"
}

```



