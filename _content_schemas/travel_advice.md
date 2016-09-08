---
layout: content_schema
title:  Travel advice
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/travel_advice/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>summary</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>country</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>name</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>reviewed_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>change_description</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alert_status</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>email_signup_link</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_id</strong> </td> <td></td></tr>
<tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>created_at</strong> </td> <td></td></tr>
<tr><td><strong>updated_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>document</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_id</strong> </td> <td></td></tr>
<tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>created_at</strong> </td> <td></td></tr>
<tr><td><strong>updated_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>parts</strong> <code>array</code></td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>travel_advice</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/travel_advice/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/travel_advice/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>summary</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>country</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>name</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>reviewed_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>change_description</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alert_status</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>email_signup_link</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_id</strong> </td> <td></td></tr>
<tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>created_at</strong> </td> <td></td></tr>
<tr><td><strong>updated_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>document</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_id</strong> </td> <td></td></tr>
<tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>created_at</strong> </td> <td></td></tr>
<tr><td><strong>updated_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>parts</strong> <code>array</code></td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>travel_advice</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### alt-country.json
```json
{
  "base_path": "/foreign-travel-advice/turkey",
  "content_id": "385d62b6-1fb3-4b29-80f3-cef2efa73cce",
  "title": "Turkey travel advice",
  "format": "travel_advice",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-02-02T12:17:50.288Z",
  "public_updated_at": "2016-01-29T15:05:22.000+00:00",
  "phase": "live",
  "analytics_identifier": null,
  "links": {
    "related": [
      {
        "content_id": "82248bb1-c4d6-41e0-9494-d98123475626",
        "title": "Renew or replace your adult passport",
        "base_path": "/renew-adult-passport",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/renew-adult-passport",
        "web_url": "https://www.gov.uk/renew-adult-passport",
        "locale": "en",
        "links": {
          "parent": [
            "86eb717a-fb40-42e7-83fa-d031a03880fb"
          ]
        }
      },
      {
        "content_id": "86eb717a-fb40-42e7-83fa-d031a03880fb",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en",
        "links": {}
      },
      {
        "content_id": "e4d06cb9-9e2e-4e82-b802-0aad013ae16c",
        "title": "Driving abroad",
        "base_path": "/driving-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/driving-abroad",
        "web_url": "https://www.gov.uk/driving-abroad",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      },
      {
        "content_id": "95f9c380-30bc-44c7-86b4-e9c9ef0fc272",
        "title": "Hand luggage restrictions at UK airports",
        "base_path": "/hand-luggage-restrictions",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/hand-luggage-restrictions",
        "web_url": "https://www.gov.uk/hand-luggage-restrictions",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      },
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en",
        "links": {}
      }
    ],
    "parent": [
      {
        "content_id": "86eb717a-fb40-42e7-83fa-d031a03880fb",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en",
        "links": {}
      },
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en",
        "links": {
          "parent": [
            "86eb717a-fb40-42e7-83fa-d031a03880fb"
          ]
        }
      },
      {
        "content_id": "08d48cdd-6b50-43ff-a53b-beab47f4aab0",
        "title": "Foreign travel advice",
        "base_path": "/foreign-travel-advice",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/foreign-travel-advice",
        "web_url": "https://www.gov.uk/foreign-travel-advice",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      }
    ],
    "available_translations": [
      {
        "content_id": "385d62b6-1fb3-4b29-80f3-cef2efa73cce",
        "title": "Turkey travel advice",
        "base_path": "/foreign-travel-advice/turkey",
        "description": "Latest travel advice for Turkey including safety and security, entry requirements, travel warnings and health",
        "api_url": "https://www.gov.uk/api/content/foreign-travel-advice/turkey",
        "web_url": "https://www.gov.uk/foreign-travel-advice/turkey",
        "locale": "en"
      }
    ]
  },
  "description": "Latest travel advice for Turkey including safety and security, entry requirements, travel warnings and health",
  "details": {
    "summary": "<p>The Foreign and Commonwealth Office (FCO) advise against all travel to within 10 km of the border with Syria.</p>\n\n<p>The FCO advise against all but essential travel to:</p>\n\n<ul>\n  <li>the remaining areas of Sirnak, Mardin, Sanliurfa, Gaziantep, Kilis and Hatay provinces</li>\n  <li>Siirt, Tunceli, Diyarbakir and Hakkari </li>\n</ul>\n\n<p>Over 2,500,000 British nationals visit Turkey every year. Most visits are trouble-free.</p>\n\n<h3 id=\"terrorism\">Terrorism</h3>\n\n<p>Although the Turkish authorities have successfully disrupted attack planning in the recent past, the threat from terrorism remains high. Terrorist groups, including Kurdish groups, Daesh and far left organisations, continue to plan and carry out attacks. As a result, further attacks are likely.  </p>\n\n<p>The majority of attacks are likely to continue to target the Turkish state. Nevertheless, it is likely that some attacks will also target western interests and tourism, as they did in Istanbul on 12 January 2016 when 10 tourists died in a suicide bombing. The Turkish Prime Minister has described the person who carried out this attack as a member of Daesh. To date the majority of attacks in Turkey have taken place in the south and east of the country and in Ankara and Istanbul.</p>\n\n<p>The Turkish authorities have said that security has been tightened in response to the attack on tourists on 12 January 2016. Further attacks could be indiscriminate and could affect places visited by foreigners. Border crossings into Syria and nearby locations have also been targeted. Be vigilant, monitor media reports and keep up to date with this travel advice.</p>\n\n<p>For more detail, see the <a href=\"/foreign-travel-advice/turkey/terrorism\">Terrorism</a> section and the FCO’s travel advice for <a href=\"https://www.gov.uk/foreign-travel-advice/syria\">Syria</a></p>\n\n<h3 id=\"visas\">Visas</h3>\n\n<p>British nationals need a visa to travel to Turkey, except for cruise ship passengers with ‘British Citizen’ passports who arrive at sea ports for tourist visits to the port city or nearby cities, provided that the visit doesn’t exceed 72 hours.</p>\n\n<p>If you&rsquo;re visiting Turkey as a tourist or on business, get an <a rel=\"external\" href=\"https://www.evisa.gov.tr/\">e-Visa</a> online before you travel. Only use the <a rel=\"external\" href=\"https://www.evisa.gov.tr/\">official Republic of Turkey e-Visa website</a>. Avoid unauthorised websites as they may charge an additional fee. Some unauthorised websites have issued fake e-Visas.</p>\n\n<p>If you don’t have an e-Visa you can still get a visa on arrival for £20 in cash, although the visa on arrival service is due to be phased out. Getting an e-Visa from the official website before you travel will avoid possible problems or delays at the Turkish border, or when boarding your flight in the UK. See <a href=\"/foreign-travel-advice/turkey/entry-requirements\">Entry requirements</a></p>\n\n<h3 id=\"travel-insurance\">Travel insurance</h3>\n\n<p>Take out comprehensive <a href=\"https://www.gov.uk/foreign-travel-insurance\">travel and medical insurance</a> before you travel.</p>\n\n<h3 id=\"first-world-war-commemorations\">First World War commemorations</h3>\n\n<p>If you’re travelling to commemorate the First World War centenary, see <a href=\"https://www.gov.uk/government/news/first-world-war-centenary-advice-for-travellers\">this information and advice page</a> to help plan your trip and make sure it’s safe and trouble free.</p>\n\n<h3 id=\"demonstrations\">Demonstrations</h3>\n\n<p>Demonstrations regularly take place across Turkey, particularly in Istanbul in the area around Taksim Square and in Kadikoy (Asian side), in the Kizilay district of central Ankara and on the waterfront area in central Izmir. Demonstrations often coincide with important national anniversaries and there are likely to be additional security measures in place in major cities on these dates. You should avoid demonstrations or large gatherings and remain vigilant. </p>\n\n<p>Since July, demonstrations have occurred in cities across Turkey associated with renewed hostilities between the Kurdistan Workers’ Party (PKK) and Turkish security forces in south-east Turkey. Police have used tear gas and water cannon extensively to disperse protests. You should avoid all demonstrations.</p>\n\n<h3 id=\"earthquakes\">Earthquakes</h3>\n\n<p>Many parts of Turkey are subject to earthquakes. An earthquake of magnitude 6.9 occurred on 24 May 2014 in the northern Aegean Sea. See <a href=\"/foreign-travel-advice/turkey/natural-disasters\">Natural disasters</a></p>\n",
    "country": {
      "slug": "turkey",
      "name": "Turkey"
    },
    "updated_at": "2016-01-29T15:05:22+00:00",
    "reviewed_at": "2016-01-29T15:05:22+00:00",
    "change_description": "Latest update: Entry requirements section (passport validity) - the Turkish government advise that your passport should be valid for at least 6 months from the date you enter Turkey",
    "email_signup_link": "https://public.govdelivery.com/accounts/UKGOVUK/subscriber/topics?qsp=TRAVEL",
    "parts": [
      {
        "slug": "terrorism",
        "title": "Terrorism",
        "body": "<p>There is a high threat from <a href=\"/reduce-your-risk-from-terrorism-while-abroad\">terrorism</a>. Attacks could be indiscriminate and could affect places visited by foreigners. A number of terrorist groups are active in Turkey. During 2015 there was an increase in PKK (Kurdish separatist) terrorist activity in south-east Turkey. There have been a number of attacks by other groups including suicide attacks by Daesh, and attacks by the far left DHKP(C) and Kurdish separatist TAK in cities including Ankara and Istanbul.</p>\n\n<p>On 1 December 2015 in Istanbul a parcel bomb near the Bayrampasa Metro station injured one person. On 30 December 2015, 2 men were detained in Ankara on suspicion of planning terrorist attacks.</p>\n\n<p>There were 2 explosions near the main Ankara train station in the Ulus area on 10 October 2015. At least 100 people were killed and more than 180 injured. </p>\n\n<p>On 19 August 2015 there was an incident involving gunfire and a sound grenade in an attack on Turkish national police guards stationed outside Dolmabahçe Palace in Istanbul. On 10 August, 2 people opened fire outside the US Consulate-General in Istanbul. </p>\n\n<p>The terrorist group Teyre Azadiye Kurdistan has claimed responsibility for a mortar attack on Sabiha Gokcen airport in Istanbul while the airport was closed for the night on 23 December 2015. The Turkish authorities have increased security measures at airports in Istanbul in response.</p>\n\n<p>The terrorist group DHKP-C (Revolutionary People’s Liberation Party Front) has launched a series of attacks in Istanbul in 2015 targeting the Turkish police and judiciary. On 5 June, two people were killed and many injured by an explosion at an HDP rally in Diyarbakir. On 9 June, 4 people were killed in an attack in Diyarbakir. </p>\n\n<p>Extremist groups based in Syria including ANF (Al Nusra Front) and Daesh (formerly referred to as ISIL) have the capacity to carry out attacks in neighbouring countries, including Turkey. Media reports suggest that terrorists could target areas throughout Turkey, including Ankara, Istanbul and areas close to the Syrian border.</p>\n\n<p>Daesh has targeted border crossings and nearby locations on the Syrian side of the border. On 20 July 2015, a suicide bomber killed 33 people and injured over 100 others in Suruc, Sanlurfa province near the Syrian border. This attack is believed to have been carried out by individuals associated with Daesh. Daesh is also believed to have been responsible for the 10 October 2015 suicide bombings in Ankara, which killed over 100 people. The Turkish government have said that Daesh was responsible for the 12 January 2016 attack in Istanbul in which 10 foreign tourists were killed.</p>\n\n<p>Turkey shares a long border with <a href=\"/foreign-travel-advice/syria\">Syria</a>. Thousands of foreign nationals, including some British nationals, have used Turkey as a transit route for joining terrorist groups including ANF and Daesh in Syria.</p>\n\n<p>There’s a domestic terrorist presence in the south east of the country including in Van, Bitlis, Bingol, Elazig, Mus, Batman, Erzincan, Diyarbakir and Agri provinces. In December 2012 talks began between the Turkish Government and the Kurdish aligned PKK (proscribed as a terrorist group in the UK), during which the PKK observed a ceasefire. However, following the Suruc bombing on 20 July, the ceasefire ended when the PKK killed 2 Turkish police officers.</p>\n\n<p>15 August is the anniversary of the first PKK attack against Turkish government installations. Historically, this anniversary date has prompted an escalation of violence by the PKK and other splinter groups. Since the end of July there has been an intensive period of violent incidents in Turkey’s south-east and eastern provinces. The vast majority of these incidents have been PKK attacks on Turkish security forces, their premises and vehicles, in which many members of the armed forces and police have been killed and injured. There have also been attacks on infrastructure (eg oil pipelines, dams) and incidents in which civilians have been affected. The government has responded with arrests of PKK suspects in Turkey and air-strikes on PKK positions in northern Iraq.</p>\n\n<p>The anti-western, proscribed terrorist group, THKP/C-Acilciler (Turkish People’s Liberation Party/Front) and the linked DHKP/C (Revolutionary People’s Liberation Front) remain active. The DHKP/C attacks have mainly targeted the Turkish authorities and US diplomatic missions.</p>\n\n<p>Between approximately 30 March and 20 April, there are several dates significant to the DHKP/C, starting with the 30 March anniversary of their founding which may have been linked to previous attacks. 19 December is also recognised as an important date around which the DHKP/C may be active.</p>\n\n<p>Methods of attack have included armed assaults, suicide bombings, car bombings and rocket attacks and improvised explosive devices left in refuse bins, crowded areas and on public transport.</p>\n\n<p>Be vigilant, monitor media reports and keep up to date with the travel advice.</p>\n\n<p>There is considered to be a heightened threat of terrorist attack globally against UK interests and British nationals, from groups or individuals motivated by the conflict in Iraq and Syria. You should be vigilant at this time.</p>\n\n<h3 id=\"kidnapping\">Kidnapping</h3>\n\n<p>There is a threat of kidnapping near the Syrian border in Turkey.</p>\n\n<p>Terrorist groups operating in Syria, including those like Daesh who routinely use kidnapping as a tactic, are present in the Syrian border areas and are capable of conducting kidnappings from across the border. Daesh and other terrorist groups view those engaged in humanitarian aid work or journalism as legitimate targets. If you’re kidnapped, the reason for your presence is unlikely to serve as protection or secure your safe release.</p>\n\n<p>The long-standing policy of the British government is not to make substantive concessions to hostage takers. The British government considers that paying ransoms and releasing prisoners increases the risk of further hostage taking.</p>\n"
      },
      {
        "slug": "safety-and-security",
        "title": "Safety and security",
        "body": "<h3 id=\"local-travel---syrian-border\">Local travel - Syrian border</h3>\n\n<p>The FCO advise against all travel to within 10km of the border with Syria. The FCO advise against all but essential travel to the remaining areas of Sirnak, Mardin, Sanlurfa, Gaziantep, Kilis and Hatay provinces. On 20 July, a suicide bomber killed 33 people and injured over 100 others in Suruc, Sanlurfa. On 11 May 2013, 2 car bombs killed 53 people and wounded more than 100 in the town of Reyhanli, Hatay province. In October 2012, 5 Turkish citizens were killed when a shell fell on the town of Akḉakale. Syrian forces continue to target areas close to the Turkish border and there remains a heightened risk of terrorism in the region.</p>\n\n<p>Mortar rounds reportedly fired by Daesh militants in northern Syria landed on the E90 road near Nusaybin in Mardin province, Turkey, on 15 September 2014. There were no casualties. As a result of heavy fighting in northern Syria, there has been a mass influx of refugees into southern Turkey over the past two years.</p>\n\n<h3 id=\"local-travel--eastern-provinces\">Local travel – eastern provinces</h3>\n<p>The FCO advise against all but essential travel to the provinces of Diyarbakir and Tunceli.  Since July there has been an intensive period of PKK attacks on Turkish security forces, their premises and vehicles.  In some incidents, civilians have been affected.</p>\n\n<p>A temporary Turkish military restricted zone has been imposed for the Mount Ararat area. No permission is being given for parties to enter the area, nor to climb the mountain. Other temporary military restricted zones have been established in eastern provinces. Don’t attempt to enter these zones. There may be some disruption to travel in these areas.</p>\n\n<h3 id=\"demonstrations\">Demonstrations</h3>\n\n<p>Since Spring 2013, there have been sporadic demonstrations in cities across Turkey, some of which have become violent. In Istanbul previous demonstrations have centered on the area around Taksim Square, on Istiklal Street and in the Besiktas and Kadikoy districts and more recently in Okmeydani. In Ankara, the protests have mainly taken place in the central Kizilay district around the Prime Minister’s office. In Izmir the focus has been in the town centre, near the water front.</p>\n\n<p>Since July, demonstrations have occurred in cities across Turkey, including large demonstrations in Adana and Mersin in September, associated with renewed hostilities between the PKK and Turkish security forces in south-east Turkey. A number of these protests have turned violent.</p>\n\n<p>You should avoid all demonstrations and leave the area if one develops. Police have used tear gas and water cannon extensively to disperse protests. The effects of tear gas can be felt several hundred metres beyond the immediate site of demonstrations. Local transport routes may be disrupted.</p>\n\n<h3 id=\"crime\">Crime</h3>\n\n<p>Generally crime levels are low, but street robbery and pick-pocketing are common in the major tourist areas of Istanbul. You should maintain at least the same level of personal security awareness as in the UK. Alcohol and drugs can make you less alert, less in control and less aware of your environment. If you are going to drink, know your limit. Drinks served in bars overseas are often stronger than those in the UK. Buy your own drinks and keep sight of them at all times so they are not spiked. Be wary of strangers approaching you offering food and drink (which may be drugged), to change money or to take you to a restaurant or nightclub.</p>\n\n<p>Passports have been stolen from rented villas, even when they have been kept in the villa safe. This is a particular problem in Didim, Kas, Kalkan and the Fethiye/Hisaronu/Ovacik area.</p>\n\n<p>In 2014, 14 cases of sexual assault, including rape, were reported to British consular staff in Turkey. Most of these cases occurred during the summer holiday period in coastal tourist areas. Most were committed late at night by someone the victim met during the evening. There have also been sexual attacks on minors visiting toilet facilities alone. You should be extra vigilant in these situations.</p>\n\n<p>Never accept lifts from strangers. Find a registered yellow taxi and make a note of the registration number before getting in.</p>\n\n<p>Very rarely counterfeit alcohol has been responsible for the death of some tourists. If you have any concerns, seek advice from your tour operator or the Turkish authorities.</p>\n\n<h3 id=\"road-travel\">Road travel</h3>\n\n<p>Take care when travelling by road throughout Turkey, particularly at night. Approach roadblocks slowly and follow the instructions of security personnel. Roads between the major cities are generally in excellent condition, but can be poor in remote, rural areas. Accidents are common and mainly due to poor or reckless driving. According to the Turkish police, there were 1,207,354 road traffic accidents in 2013 which resulted in 3,685 deaths and 274,829 injuries.</p>\n\n<p>If you drive in Turkey, you must have either an <a rel=\"external\" href=\"http://www.theaa.com/getaway/idp/index.html\">International Driving Permit</a> or a notarised copy (in Turkish) of your UK driving licence. Provisional driving licences are not recognised.</p>\n\n<p>You will need an ‘A’ category standard motorcycle licence to hire a motorcycle over 50cc in Turkey. An ‘A1’ category ‘light motorcycle’ driving licence is only suitable for motorcycles below 50cc. By law you must wear a helmet. Failure to do so could result in a heavy fine.</p>\n\n<p>Don’t drink and drive. The police will breathalyse drunk drivers, fine you on the spot and immediately confiscate your licence for 6 months.</p>\n\n<h3 id=\"extreme-sports\">Extreme sports</h3>\n\n<p>If you participate in extreme sports (including paragliding, parasailing, white-water rafting, off-road driving and hot air ballooning), satisfy yourself that adequate safety precautions are in place. Only use reputable operators and insist on training before use. Make sure your travel insurance covers you for all the activities you want to undertake. British nationals have been injured and in some cases killed participating in extreme sports.</p>\n\n<h3 id=\"stray-dogs\">Stray dogs</h3>\n<p>Most towns and cities have stray dogs. Local authorities take action to control and manage numbers but packs congregate in parks and wastelands and can be aggressive. Take care, remain calm, and avoid approaching stray dogs. If you&rsquo;re bitten, seek medical advice as rabies and other animal borne diseases are present in Turkey.</p>\n"
      },
      {
        "slug": "local-laws-and-customs",
        "title": "Local laws and customs",
        "body": "<p>Smoking is prohibited on public transport and in all indoor workplaces and public places. Smoking is restricted in some outdoor areas where cultural, artistic, sports or entertainment activities are held.</p>\n\n<p>Turkey has strict laws against the use, possession or trafficking of illegal drugs. If you are convicted of any of these offences, you can expect to receive a heavy fine or a prison sentence of 4 to 24 years. The possession, sale and export of antiquities is against the law.</p>\n\n<p>Dress modestly if you’re visiting a mosque or a religious shrine.</p>\n\n<p>It is illegal not to carry some form of photographic ID in Turkey. Carry a photocopy of your passport with you at all times.</p>\n\n<p>Don’t take photographs near military or official installations. Ask for permission before photographing people.</p>\n\n<p>Homosexuality is legal in Turkey. However, many parts of Turkey are socially conservative and public displays of affection may lead to unwelcome attention. </p>\n\n<p>It is an offence to insult the Turkish nation or the national flag, or to deface or tear up currency.</p>\n"
      },
      {
        "slug": "entry-requirements",
        "title": "Entry requirements",
        "body": "<h3 id=\"visas\">Visas</h3>\n\n<p>British nationals need a visa to enter Turkey, except for cruise ship passengers with ‘British Citizen’ passports who arrive at sea ports for tourist visits to the port city or nearby cities, provided that the visit doesn’t exceed 72 hours.</p>\n\n<p>You can get an e-Visa online before you travel through the <a rel=\"external\" href=\"https://www.evisa.gov.tr/\">official Republic of Turkey e-Visa website</a>. An e-visa costs $20 and you can pay using a credit or debit card. You can apply up to 3 months in advance of your travel date. Turkish visit visas issued on arrival are valid for multiple stays up to a maximum of 90 days in a 180 day period.</p>\n\n<p>If you have any queries regarding e-Visas call the <a rel=\"external\" href=\"https://www.evisa.gov.tr/en/feedback/\">Visa Contact Centre</a> (details provided by the Turkish Ministry of Foreign Affairs).</p>\n\n<p>Some unauthorised websites may charge for information about e-Visas, and for submitting applications. These websites are not endorsed by or associated with the Turkish government. Be wary of such sites and businesses, particularly those that seek additional fees for other services. Some unauthorised websites have also issued fake e-Visas.</p>\n\n<p>In case of problems with the computer systems at the Turkish port of entry, print off and carry a paper copy of your e-Visa, or make sure you have an electronic copy on a smart phone or other device to show to the immigration officer.</p>\n\n<p>Until further notice British citizens can get a multiple entry visitor visa, valid for 90 days, on arrival at any port of entry on payment of £20 in cash (Scottish and Northern Irish currency is not accepted). However, the visa on arrival service is likely to be phased out at some point in the near future. To avoid possible problems or delays at the Turkish border, or when boarding your flight in the UK, get an e-Visa from the official website before you travel.</p>\n\n<p>At Istanbul Ataturk airport (and possibly at other airports) there will be self service e-Visa kiosks and Wi-Fi areas where visitors can apply for an e-Visa on arrival using their own smart devices.</p>\n\n<p>You can also apply for a visa before you travel from the <a rel=\"external\" href=\"http://www.turkishconsulate.org.uk/en/\">Turkish Consulate General in London</a>.\nIf you&rsquo;re planning to study or work in Turkey, or are unsure about the type of visa you require, you should apply for a visa before travel.</p>\n\n<p>If you don’t have a ‘British Citizen’ passport, but hold a different type of British nationality (eg BN(O), British Overseas Citizen, British Protected Person or British Subject), check visa requirements with the <a rel=\"external\" href=\"http://www.turkishconsulate.org.uk/en/\">Turkish Consulate General</a> before you travel. These types of passport are classed as ‘UK Special Passports’ in the Turkish e-Visa system. You’ll need to apply for a visa from the Turkish Consulate General before you travel.</p>\n\n<p>Make sure your passport has a blank page for the visa stamp. If it doesn&rsquo;t, the Turkish authorities will issue an ‘Entry-Exit form’ and put your entry-exit stamp on there. You should carry this form with you in Turkey and present it to the border officers when you leave.</p>\n\n<p>If you plan to remain in Turkey for a period of more than 90 days, you should either apply for a longer stay visa before you travel, or get a residence permit from the local authorities in Turkey before your 90 day stay has elapsed. If you intend to work in Turkey, ensure you have the correct permits. More information is available from the Turkish Ministry of the Interior. If you don&rsquo;t abide by the terms of your visa or permit, you may be fined, deported and banned from re-entering the country.</p>\n\n<p>If you&rsquo;re entering Turkey via a land border crossing, make sure your passport has a dated entry stamp before you leave the border crossing area.</p>\n\n<h3 id=\"passport-validity\">Passport validity</h3>\n<p>The Turkish government advise that your passport should be valid for at least 6 months from the date you enter Turkey. You can find more detail about the requirements for entry into Turkey on the website of the <a rel=\"external\" href=\"http://www.mfa.gov.tr/visa-information-for-foreigners.en.mfa\">Turkish Ministry of Foreign Affairs</a>.</p>\n\n<p>The Turkish authorities have confirmed they will accept British passports extended by 12 months by British Embassies and Consulates under additional measures put in place in mid-2014.</p>\n\n<h3 id=\"travelling-with-children\">Travelling with children</h3>\n\n<p>If you are leaving Turkey with a child who is a dual British-Turkish national, you may be asked to show the Turkish immigration authorities evidence that the Turkish parent has given permission for the child to travel.</p>\n\n<h3 id=\"uk-emergency-travel-documents\">UK Emergency Travel Documents</h3>\n\n<p>UK Emergency Travel Documents (ETD) are accepted for entry, airside transit and exit from Turkey within the dates printed on the document. ETDs should be valid for a minimum period of 6 months from the date of entry into Turkey.</p>\n"
      },
      {
        "slug": "health",
        "title": "Health",
        "body": "<p>Visit your health professional at least 4 to 6 weeks before your trip to check whether you need any vaccinations or other preventive measures. Country specific information and advice is published by the National Travel Health Network and Centre on the <a rel=\"external\" href=\"http://travelhealthpro.org.uk/country-information/\">TravelHealthPro website</a> and by NHS (Scotland) on the <a rel=\"external\" href=\"http://www.fitfortravel.nhs.uk/destinations.aspx\">fitfortravel website</a>. Useful information and advice about healthcare abroad is also available on the <a rel=\"external\" href=\"http://www.nhs.uk/NHSEngland/Healthcareabroad/Pages/Healthcareabroad.aspx\">NHS Choices website</a>.</p>\n\n<p>The European Health Insurance Card (<a rel=\"external\" href=\"http://www.nhs.uk/NHSEngland/Healthcareabroad/EHIC/Pages/about-the-ehic.aspx\">EHIC</a>), is not valid in Turkey. Make sure you have adequate travel health insurance and accessible funds to cover the cost of any medical treatment abroad and repatriation.</p>\n\n<p>If you need emergency medical assistance during your trip, dial 112 and ask for an ambulance. You should contact your insurance/medical assistance company promptly if you are referred to a medical facility for treatment.</p>\n"
      },
      {
        "slug": "natural-disasters",
        "title": "Natural disasters",
        "body": "<p>Many parts of Turkey are subject to earthquakes and tremors.  </p>\n\n<p>You should familiarise yourself with safety procedures in the event of an earthquake and follow any advice given by the local authorities.  </p>\n\n<p>The US Federal Emergency Management Agency has information about what to do <a rel=\"external\" href=\"http://www.ready.gov/earthquakes\">before, during and after an earthquake.</a></p>\n"
      },
      {
        "slug": "money",
        "title": "Money",
        "body": "<p>The currency in Turkey is the Turkish Lira. ATMs are widely available in major cities and tourist areas. You can get local currency from banks and exchange bureaux, known as DOVIZ in Turkish.</p>\n"
      },
      {
        "slug": "contact-fco-travel-advice-team",
        "title": "Contact FCO Travel Advice Team",
        "body": "<p>This email service only offers information and advice for British nationals planning to travel abroad. </p>\n\n<p>If you need urgent help because something has happened to a friend or relative abroad, contact the consular assistance team on 020 7008 1500 (24 hours).</p>\n\n<p>If you’re abroad and need emergency help, please contact the nearest <a href=\"https://www.gov.uk/government/world/organisations\">British embassy, consulate or high commission</a>.</p>\n\n<p>If you have a question about this travel advice, you can email us at <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#084;&#114;&#097;&#118;&#101;&#108;&#065;&#100;&#118;&#105;&#099;&#101;&#080;&#117;&#098;&#108;&#105;&#099;&#069;&#110;&#113;&#117;&#105;&#114;&#105;&#101;&#115;&#064;&#102;&#099;&#111;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#084;&#114;&#097;&#118;&#101;&#108;&#065;&#100;&#118;&#105;&#099;&#101;&#080;&#117;&#098;&#108;&#105;&#099;&#069;&#110;&#113;&#117;&#105;&#114;&#105;&#101;&#115;&#064;&#102;&#099;&#111;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n\n<p>Before you send an email, make sure you have read the travel advice for the country you’re travelling to, and the guidance on <a href=\"https://www.gov.uk/how-the-foreign-commonwealth-office-puts-together-travel-advice\">how the FCO puts travel advice together</a>.</p>\n"
      }
    ],
    "alert_status": [
      "avoid_all_travel_to_parts"
    ],
    "image": {
      "url": "https://www.gov.uk/media/55e5d564e5274a558000000b/150824_Turkey_jpeg.jpg",
      "content_type": "image/jpeg"
    },
    "document": {
      "url": "https://www.gov.uk/media/55e5d9b2ed915d06a100000e/Turkey.pdf",
      "content_type": "application/pdf"
    },
    "max_cache_time": 10,
    "publishing_request_id": "2546-1460985144476-19268198-3242"
  },
  "schema_name": "travel_advice",
  "document_type": "travel_advice"
}

```

### full-country.json
```json
{
  "content_id": "2a3938e1-d588-45fc-8c8f-0f51814d5409",
  "base_path": "/foreign-travel-advice/albania",
  "title": "Albania travel advice",
  "description": "Latest travel advice for Albania including safety and security, entry requirements, travel warnings and health",
  "details": {
    "summary": "<p>Over 80,000 British nationals visit Albania every year. Most visits are trouble-free.</p> <p>From December to February severe weather may cause flooding, particularly in northern Albania. Heavy snowfall in mountainous areas can lead to disruption to transport and services. </p> <p>Public security is generally good, particularly in Tirana. Crime and violence does occur in some areas, but is not typically targeted at foreigners. Gun ownership is widespread. See <a href=\"/foreign-travel-advice/albania/safety-and-security\">Crime.</a></p> <p>When visiting hill towns on the northern border with Kosovo, you should exercise caution and heed warning signs about unexploded landmines and other unexploded ordnance. See <a href=\"/foreign-travel-advice/albania/safety-and-security\">Landmines.</a></p> <p>There is an underlying threat from terrorism. See <a href=\"/foreign-travel-advice/albania/terrorism\">Terrorism.</a></p> <p>Take out comprehensive travel and medical <a href=\"https://www.gov.uk/foreign-travel-insurance\">insurance</a> before you travel.</p>",
    "country": {
      "name": "Albania",
      "slug": "albania"
    },
    "updated_at": "2015-10-15T11:00:20+01:00",
    "reviewed_at": "2015-10-15T11:00:20+01:00",
    "change_description": "Latest Update - this advice has been reviewed and re-issued without amendment",
    "alert_status": [],
    "email_signup_link": "https://public.govdelivery.com/accounts/UKGOVUK/subscriber/topics?qsp=TRAVEL",
    "image": {
      "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/120613_Albania_Travel_Advice_WEB_Ed2_jpeg.jpg",
      "content_type": "image/jpeg"
    },
    "document": {
      "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efced915d4261000001/120613_Albania_Travel_Advice_Ed2_pdf.pdf",
      "content_type": "application/pdf"
    },
    "parts": [
      {
        "slug": "safety-and-security",
        "title": "Safety and security",
        "body": "<h3>Crime</h3> <p>Public security is generally good, particularly in Tirana, and Albanians are very hospitable to visitors. Crime and violence does occur in some areas, but reports of crime specifically targeting foreigners are rare. There have been occasional shootings and small explosions, but these appear to be related to internal disputes over criminal, business or political interests. </p> <p>There have been reports of luggage stolen from hotel rooms and public transport, particularly in the coastal resorts of Vlore and Saranda. Be vigilant and keep valuables in a safe place. </p> <h3>Landmines</h3> <p>In December 2009 Albania officially declared it had met its  <a rel=\"external\" href=\"http://www.unog.ch/80256EE600585943/(httpPages)/CA826818C8330D2BC1257180004B1B2E?OpenDocument\">‘Ottawa Convention Article 5’</a> obligations and had reached mine-free status. However, when visiting hill towns on the northern border with Kosovo and Montenegro you should take care, particularly if hiking and follow the signs warning about unexploded landmines and other unexploded ordnance. Demining is ongoing on the Kosovo side.  </p> <h3>Road travel</h3> <p>Driving can be very hazardous. Roads are poor, especially in rural areas. Street lighting in urban areas is subject to power cuts. Elsewhere, even on the major inter-urban arterial routes, there is no street lighting. If you are travelling at night, watch out for unmarked road works, potholes and unlit vehicles. Four-wheel drive vehicles are often more practical on rural and minor roads.</p> <p>Albanian driving can often be aggressive and erratic. Deaths from road traffic accidents are amongst the highest in Europe. Police have taken some measures to decrease the number of accidents. Minor traffic disputes can quickly escalate, especially as some motorists could be armed. Avoid reacting to provocative behaviour by other road users. If you are involved in a traffic accident, even a minor one, you are supposed to wait until the police arrive. This will usually happen quickly in built-up areas.</p> <p>If you are intending to import a vehicle into Albania, make sure you have all the necessary papers on arrival at the border. Consult the <a rel=\"external\" href=\"http://www.albanianembassy.co.uk\">Albanian Embassy</a> in London before you leave. The British Embassy will be unable to help anyone attempting to bring a vehicle into Albania without the correct paperwork. </p> <p>An International Driving Permit (IDP) is recommended.</p> <h3>Air travel</h3> <p>A list of incidents and accidents can be found on the website of the  <a rel=\"external\" href=\"http://aviation-safety.net/index.php\">Aviation Safety network</a>. </p> <p>In 2009 the International Civil Aviation Organisation carried out an <a rel=\"external\" href=\"http://www.icao.int/safety/Pages/USOAP-Results.aspx\">audit</a> of the level of implementation of the critical elements of safely oversight in Albania. </p> <p>We can’t offer advice on the safety of individual airlines. However, the International Air Transport Association publishes a <a rel=\"external\" href=\"http://www.iata.org/whatwedo/safety/audit/iosa/Pages/registry.aspx?Query=all\">list of registered airlines</a> that have been audited and found to meet a number of operational safety standards and recommended practices. This list is not exhaustive and the absence of an airline from this list does not necessarily mean that it is unsafe. </p> <h3>Sea travel</h3> <p>There have been instances of passenger boats sinking, usually due to a lack of safety precautions and equipment.  </p> <h3>Swimming</h3> <p>Several beaches along the Albanian coast are reported by the Albanian press to be polluted as a result of inadequate sewage disposal and treatment. </p> <h3>Political situation</h3> <p>Tension between religious groups and expression of extremist views is very rare, and attitudes to western countries are overwhelmingly positive.</p> "
      },
      {
        "slug": "terrorism",
        "title": "Terrorism",
        "body": "<p>There is an underlying threat from <a href=\"https://www.gov.uk/reduce-your-risk-from-terrorism-while-abroad\">terrorism</a>. Attacks, although unlikely, could be indiscriminate, including places frequented by expatriates and foreign travellers. </p> <p>There is considered to be a heightened threat of terrorist attack globally against UK interests and British nationals, from groups or individuals motivated by the conflict in Iraq and Syria. You should be vigilant at this time.</p> "
      },
      {
        "slug": "local-laws-and-customs",
        "title": "Local laws and customs",
        "body": "<p>English is not widely spoken but it is increasingly spoken by younger people.</p> <p>Homosexuality is not illegal but is not widely accepted. There have incidents of assault against homosexuals. Avoid public displays of affection. </p> <p>Penalties for drug-related crimes are severe. </p> <p>The Albanian authorities do not always inform the British Embassy when British nationals have been arrested. If you are detained, you may insist on your right to contact a British consular officer.</p> "
      },
      {
        "slug": "entry-requirements",
        "title": "Entry requirements",
        "body": "<h3>Visas</h3> <p>British citizens can enter and remain in Albania for a maximum of 90 days in every 6-month period without a visa. The Albanian authorities require anyone staying longer than 90 days to apply at a local police station for a residence permit.   </p> <h3>Passport validity </h3> <p>Your passport should be valid for a minimum period of 6 months from the date of entry into Albania.  </p> <p>The Albanian authorities have confirmed they will accept British passports extended by 12 months by British Embassies and Consulates under additional measures put in place in mid-2014.</p> <h3>Yellow fever</h3> <p>Yellow Fever vaccination is required for travellers arriving from <a rel=\"external\" href=\"http://www.who.int/ith/2015-ith-annex1.pdf?ua=1\">countries with risk</a> of yellow fever transmission.  </p> <h3>UK Emergency Travel Documents</h3> <p>UK Emergency Travel Documents are accepted for entry, airside transit and exit from Albania.</p> "
      },
      {
        "slug": "health",
        "title": "Health",
        "body": "<p>Visit your health professional at least 4 to 6 weeks before your trip to check whether you need any vaccinations or other preventive measures. Country specific information and advice is published by the National Travel Health Network and Centre on the <a rel=\"external\" href=\"http://travelhealthpro.org.uk/country-information/\">TravelHealthPro website</a> and by NHS (Scotland) on the <a rel=\"external\" href=\"http://www.fitfortravel.nhs.uk/destinations.aspx\">fitfortravel website</a>. Useful information and advice about healthcare abroad is also available on the <a rel=\"external\" href=\"http://www.nhs.uk/NHSEngland/Healthcareabroad/Pages/Healthcareabroad.aspx\">NHS Choices website</a>.</p> <p>In 2012 there were a number of cases of West Nile virus and Crimean-Congo haemorrhagic fever in the border areas between Kosovo and Albania. </p> <p>Medical and dental facilities (including those for accident and emergency use) are very poor, particularly outside Tirana. Make sure you have adequate travel health insurance and accessible funds to cover the cost of any medical treatment abroad, evacuation by air ambulance and repatriation. </p> <p>The tap water in Albania may cause illness - you should drink only bottled water. If you drink milk, make sure it is UHT (pasteurised). </p> <p>If you need emergency medical assistance during your trip, dial 127 or 04 2222 235 and ask for an ambulance. You should contact your insurance/medical assistance company promptly if you are referred to a medical facility for treatment. </p> "
      },
      {
        "slug": "natural-disasters",
        "title": "Natural disasters",
        "body": "<p>Albania lies in a seismically-active zone, and tremors are common. Serious earthquakes are less frequent but do occur. To learn more about what to do before, during and after an earthquake, see this <a rel=\"external\" href=\"http://www.ready.gov/earthquakes\">advice</a> from the US Federal Emergency Management Agency.</p> "
      },
      {
        "slug": "money",
        "title": "Money",
        "body": "<p>Major credit and debit cards are accepted in most banks, large supermarkets and international hotels. Smaller businesses and taxis often only accept cash. There are numerous ATMs in Tirana and the main towns, as well as bureaux de change where Sterling, US Dollars and Euros are widely accepted. Although street money-changers operate openly, they do so illegally. Only use banks or established bureaux de change. There have been some cases of credit card fraud.</p> "
      },
      {
        "slug": "contact-fco-travel-advice-team",
        "title": "Contact FCO Travel Advice Team",
        "body": "<p>This email service only offers information and advice for British nationals planning to travel abroad. </p> <p>If you need urgent help because something has happened to a friend or relative abroad, contact the consular assistance team on 020 7008 1500 (24 hours).</p> <p>If you’re abroad and need emergency help, please contact the nearest <a href=\"https://www.gov.uk/government/world/organisations\">British embassy, consulate or high commission</a>.</p> <p>If you have a question about this travel advice, you can email us at <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#084;&#114;&#097;&#118;&#101;&#108;&#065;&#100;&#118;&#105;&#099;&#101;&#080;&#117;&#098;&#108;&#105;&#099;&#069;&#110;&#113;&#117;&#105;&#114;&#105;&#101;&#115;&#064;&#102;&#099;&#111;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#084;&#114;&#097;&#118;&#101;&#108;&#065;&#100;&#118;&#105;&#099;&#101;&#080;&#117;&#098;&#108;&#105;&#099;&#069;&#110;&#113;&#117;&#105;&#114;&#105;&#101;&#115;&#064;&#102;&#099;&#111;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p> <p>Before you send an email, make sure you have read the travel advice for the country you’re travelling to, and the guidance on <a href=\"https://www.gov.uk/how-the-foreign-commonwealth-office-puts-together-travel-advice\">how the FCO puts travel advice together</a>.</p> "
      }
    ],
    "max_cache_time": 10,
    "publishing_request_id": "2546-1460985144476-19268198-3242"
  },
  "format": "travel_advice",
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
        "content_id": "82248bb1-c4d6-41e0-9494-d98123475626",
        "title": "Renew or replace your adult passport",
        "base_path": "/renew-adult-passport",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/renew-adult-passport",
        "web_url": "https://www.gov.uk/renew-adult-passport",
        "locale": "en",
        "links": {
          "parent": [
            "86eb717a-fb40-42e7-83fa-d031a03880fb"
          ]
        }
      },
      {
        "content_id": "86eb717a-fb40-42e7-83fa-d031a03880fb",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en",
        "links": {}
      },
      {
        "content_id": "e4d06cb9-9e2e-4e82-b802-0aad013ae16c",
        "title": "Driving abroad",
        "base_path": "/driving-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/driving-abroad",
        "web_url": "https://www.gov.uk/driving-abroad",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      },
      {
        "content_id": "95f9c380-30bc-44c7-86b4-e9c9ef0fc272",
        "title": "Hand luggage restrictions at UK airports",
        "base_path": "/hand-luggage-restrictions",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/hand-luggage-restrictions",
        "web_url": "https://www.gov.uk/hand-luggage-restrictions",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      },
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en",
        "links": {}
      }
    ],
    "parent": [
      {
        "content_id": "86eb717a-fb40-42e7-83fa-d031a03880fb",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en",
        "links": {}
      },
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en",
        "links": {
          "parent": [
            "86eb717a-fb40-42e7-83fa-d031a03880fb"
          ]
        }
      },
      {
        "content_id": "08d48cdd-6b50-43ff-a53b-beab47f4aab0",
        "title": "Foreign travel advice",
        "base_path": "/foreign-travel-advice",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/foreign-travel-advice",
        "web_url": "https://www.gov.uk/foreign-travel-advice",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      }
    ],
    "available_translations": [
      {
        "content_id": "2a3938e1-d588-45fc-8c8f-0f51814d5409",
        "title": "Albania travel advice",
        "base_path": "/foreign-travel-advice/albania",
        "api_url": "https://www.gov.uk/api/content/foreign-travel-advice/albania",
        "web_url": "https://www.gov.uk/foreign-travel-advice/albania",
        "locale": "en"
      }
    ]
  },
  "locale": "en",
  "need_ids": [
    "101191"
  ],
  "public_updated_at": "2015-10-15T11:00:20+01:00",
  "updated_at": "2015-10-15T11:04:13+01:00",
  "schema_name": "travel_advice",
  "document_type": "travel_advice"
}

```

### no-parts.json
```json
{
  "content_id": "b31eb5c9-127c-4c34-9f74-3576c08a501a",
  "base_path": "/foreign-travel-advice/antarctica",
  "description": "Latest travel advice for Antarctica including safety and security, entry requirements, travel warnings and health",
  "details": {
    "summary": "<p>It's very cold.</p>",
    "country": {
      "name": "Antarctica",
      "slug": "antarctica"
    },
    "updated_at": "2015-10-15T11:00:20+01:00",
    "reviewed_at": "2015-08-28T17:11:23+01:00",
    "change_description": "Latest update: Info about the cold.",
    "alert_status": [],
    "email_signup_link": "https://public.govdelivery.com/accounts/UKGOVUK/subscriber/topics?qsp=TRAVEL",
    "parts": [],
    "max_cache_time": 10,
    "publishing_request_id": "2546-1460985144476-19268198-3242"
  },
  "format": "travel_advice",
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
        "content_id": "82248bb1-c4d6-41e0-9494-d98123475626",
        "title": "Renew or replace your adult passport",
        "base_path": "/renew-adult-passport",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/renew-adult-passport",
        "web_url": "https://www.gov.uk/renew-adult-passport",
        "locale": "en",
        "links": {
          "parent": [
            "86eb717a-fb40-42e7-83fa-d031a03880fb"
          ]
        }
      },
      {
        "content_id": "86eb717a-fb40-42e7-83fa-d031a03880fb",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en",
        "links": {}
      },
      {
        "content_id": "e4d06cb9-9e2e-4e82-b802-0aad013ae16c",
        "title": "Driving abroad",
        "base_path": "/driving-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/driving-abroad",
        "web_url": "https://www.gov.uk/driving-abroad",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      },
      {
        "content_id": "95f9c380-30bc-44c7-86b4-e9c9ef0fc272",
        "title": "Hand luggage restrictions at UK airports",
        "base_path": "/hand-luggage-restrictions",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/hand-luggage-restrictions",
        "web_url": "https://www.gov.uk/hand-luggage-restrictions",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      },
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en",
        "links": {}
      }
    ],
    "parent": [
      {
        "content_id": "86eb717a-fb40-42e7-83fa-d031a03880fb",
        "title": "Passports, travel and living abroad",
        "base_path": "/browse/abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad",
        "web_url": "https://www.gov.uk/browse/abroad",
        "locale": "en",
        "links": {}
      },
      {
        "content_id": "b9849cd6-61a7-42dc-8124-362d2c7d48b0",
        "title": "Travel abroad",
        "base_path": "/browse/abroad/travel-abroad",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/browse/abroad/travel-abroad",
        "web_url": "https://www.gov.uk/browse/abroad/travel-abroad",
        "locale": "en",
        "links": {
          "parent": [
            "86eb717a-fb40-42e7-83fa-d031a03880fb"
          ]
        }
      },
      {
        "content_id": "08d48cdd-6b50-43ff-a53b-beab47f4aab0",
        "title": "Foreign travel advice",
        "base_path": "/foreign-travel-advice",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/foreign-travel-advice",
        "web_url": "https://www.gov.uk/foreign-travel-advice",
        "locale": "en",
        "links": {
          "parent": [
            "b9849cd6-61a7-42dc-8124-362d2c7d48b0"
          ]
        }
      }
    ]
  },
  "locale": "en",
  "need_ids": [
    "101191"
  ],
  "public_updated_at": "2015-04-28T17:11:23+01:00",
  "title": "Antarctica travel advice",
  "updated_at": "2015-08-28T17:16:43+01:00",
  "schema_name": "travel_advice",
  "document_type": "travel_advice"
}

```



