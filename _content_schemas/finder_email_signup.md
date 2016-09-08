---
layout: content_schema
title:  Finder email signup
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/finder_email_signup/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>beta</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>email_signup_choice</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>email_filter_by</strong> </td> <td></td></tr>
<tr><td><strong>subscription_list_title_prefix</strong> </td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>finder_email_signup</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/finder_email_signup/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related</strong> </td> <td></td></tr>
<tr><td><strong>organisations</strong> </td> <td>All organisations linked to this content item. This should include lead organisations.</td></tr>
<tr><td><strong>taxons</strong> </td> <td>Prototype-stage taxonomy label for this content item</td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td>Powers the /browse section of the site. These are known as sections in some legacy apps.</td></tr>
<tr><td><strong>topics</strong> </td> <td>Powers the /topic section of the site. These are known as specialist sectors in some legacy apps.</td></tr>
<tr><td><strong>parent</strong> </td> <td>The parent content item.</td></tr>
<tr><td><strong>policies</strong> </td> <td>These are for collecting content related to a particular government policy.</td></tr>
<tr><td><strong>policy_areas</strong> </td> <td>A largely deprecated tag currently only used to power email alerts.</td></tr></table></td></tr>
<tr><td><strong>previous_version</strong> <code>string</code></td> <td></td></tr></table>

---

## Frontend schema

This is the schema for what you'll get back from the content-store.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/finder_email_signup/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>beta</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>email_signup_choice</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>email_filter_by</strong> </td> <td></td></tr>
<tr><td><strong>subscription_list_title_prefix</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>related</strong> </td> <td></td></tr>
<tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>taxons</strong> </td> <td></td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>topics</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>finder_email_signup</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### cma-cases-email-signup.json
```json
{
  "analytics_identifier": null,
  "base_path": "/cma-cases/email-signup",
  "content_id": "43dd2b13-93ec-4ca6-a7a4-e2eb5f5d485a",
  "document_type": "finder_email_signup",
  "expanded_links": {
    "related": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/cma-cases",
        "base_path": "/cma-cases",
        "content_id": "fef4ac7c-024a-4943-9f19-e85a8369a1f3",
        "description": "Find reports and updates on current and historical CMA investigations",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000Z",
        "title": "Competition and Markets Authority cases",
        "web_url": "https://www.gov.uk/cma-cases",
        "expanded_links": { }
      }
    ],
    "organisations": [
      {
        "analytics_identifier": "D550",
        "api_url": "https://www.gov.uk/api/content/government/organisations/competition-and-markets-authority",
        "base_path": "/government/organisations/competition-and-markets-authority",
        "content_id": "957eb4ec-089b-4f71-ba2a-dc69ac8919ea",
        "description": null,
        "locale": "en",
        "public_updated_at": "2015-03-10T16:23:14.000Z",
        "title": "Competition and Markets Authority",
        "web_url": "https://www.gov.uk/government/organisations/competition-and-markets-authority",
        "expanded_links": { }
      }
    ],
    "available_translations": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/cma-cases/email-signup",
        "base_path": "/cma-cases/email-signup",
        "content_id": "43dd2b13-93ec-4ca6-a7a4-e2eb5f5d485a",
        "description": "You'll get an email each time a case is updated or a new case is published.",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000Z",
        "title": "Competition and Markets Authority cases",
        "web_url": "https://www.gov.uk/cma-cases/email-signup"
      }
    ]
  },
  "first_published_at": "2016-02-29T09:24:10.000+00:00",
  "format": "finder_email_signup",
  "locale": "en",
  "need_ids": [ ],
  "phase": "live",
  "public_updated_at": "2016-06-13T14:30:40.000+00:00",
  "publishing_app": "specialist-publisher",
  "rendering_app": "finder-frontend",
  "schema_name": "finder_email_signup",
  "title": "Competition and Markets Authority cases",
  "updated_at": "2016-06-13T14:31:32.260Z",
  "withdrawn_notice": { },
  "links": {
    "related": [
      {
        "content_id": "fef4ac7c-024a-4943-9f19-e85a8369a1f3",
        "title": "Competition and Markets Authority cases",
        "base_path": "/cma-cases",
        "description": "Find reports and updates on current and historical CMA investigations",
        "api_url": "https://www.gov.uk/api/content/cma-cases",
        "web_url": "https://www.gov.uk/cma-cases",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000+00:00",
        "schema_name": "finder",
        "document_type": "finder",
        "analytics_identifier": null,
        "links": {
          "topics": [
            "fd11e3b0-76bc-4197-b652-a030b57915be",
            "7aa3ec0c-683e-44ba-aa3f-cc9655651b9b",
            "1433d403-333f-4d81-b83a-c5358412fd1b",
            "65a89136-2117-41aa-ba96-35feb9d821f5",
            "4a6f14ad-baa1-4b15-8026-8282913ef693"
          ],
          "email_alert_signup": [
            "43dd2b13-93ec-4ca6-a7a4-e2eb5f5d485a"
          ],
          "organisations": [
            "957eb4ec-089b-4f71-ba2a-dc69ac8919ea"
          ]
        }
      }
    ],
    "organisations": [
      {
        "content_id": "957eb4ec-089b-4f71-ba2a-dc69ac8919ea",
        "title": "Competition and Markets Authority",
        "base_path": "/government/organisations/competition-and-markets-authority",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/government/organisations/competition-and-markets-authority",
        "web_url": "https://www.gov.uk/government/organisations/competition-and-markets-authority",
        "locale": "en",
        "public_updated_at": "2015-03-10T16:23:14.000+00:00",
        "schema_name": "placeholder_organisation",
        "document_type": "placeholder_organisation",
        "analytics_identifier": "D550",
        "links": { },
        "details": {
          "brand": "department-for-business-innovation-skills",
          "logo": {
            "formatted_title": "Competition and <br/>Markets Authority",
            "crest": null
          }
        }
      }
    ],
    "available_translations": [
      {
        "content_id": "43dd2b13-93ec-4ca6-a7a4-e2eb5f5d485a",
        "title": "Competition and Markets Authority cases",
        "base_path": "/cma-cases/email-signup",
        "description": "You'll get an email each time a case is updated or a new case is published.",
        "api_url": "https://www.gov.uk/api/content/cma-cases/email-signup",
        "web_url": "https://www.gov.uk/cma-cases/email-signup",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000+00:00",
        "schema_name": "finder_email_signup",
        "document_type": "finder_email_signup",
        "analytics_identifier": null,
        "links": {
          "related": [
            "fef4ac7c-024a-4943-9f19-e85a8369a1f3"
          ],
          "organisations": [
            "957eb4ec-089b-4f71-ba2a-dc69ac8919ea"
          ]
        }
      }
    ]
  },
  "description": "You'll get an email each time a case is updated or a new case is published.",
  "details": {
    "beta": false,
    "email_signup_choice": [
      {
        "key": "ca98-and-civil-cartels",
        "radio_button_name": "CA98 and civil cartels",
        "topic_name": "CA98 and civil cartels",
        "prechecked": false
      },
      {
        "key": "criminal-cartels",
        "radio_button_name": "Criminal cartels",
        "topic_name": "criminal cartels",
        "prechecked": false
      },
      {
        "key": "markets",
        "radio_button_name": "Markets",
        "topic_name": "markets",
        "prechecked": false
      },
      {
        "key": "mergers",
        "radio_button_name": "Mergers",
        "topic_name": "mergers",
        "prechecked": false
      },
      {
        "key": "consumer-enforcement",
        "radio_button_name": "Consumer enforcement",
        "topic_name": "consumer enforcement",
        "prechecked": false
      },
      {
        "key": "regulatory-references-and-appeals",
        "radio_button_name": "Regulatory references and appeals",
        "topic_name": "regulatory references and appeals",
        "prechecked": false
      },
      {
        "key": "review-of-orders-and-undertakings",
        "radio_button_name": "Reviews of orders and undertakings",
        "topic_name": "reviews of orders and undertakings",
        "prechecked": false
      }
    ],
    "email_filter_by": "case_type",
    "subscription_list_title_prefix": {
      "singular": "Competition and Markets Authority (CMA) cases with the following case type: ",
      "plural": "Competition and Markets Authority (CMA) cases with the following case types: "
    }
  }

}
```

### raib-report-email-signup.json
```json
{
  "analytics_identifier": null,
  "base_path": "/raib-reports/email-signup",
  "content_id": "db81c7e8-b1b6-4c29-992a-1289f1b63073",
  "document_type": "finder_email_signup",
  "expanded_links": {
    "related": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/raib-reports",
        "base_path": "/raib-reports",
        "content_id": "e3ff7fc5-6788-45de-83f0-cbf34e9fe8bd",
        "description": "Find reports of RAIB investigations into rail accidents and incidents",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000Z",
        "title": "Rail Accident Investigation Branch reports",
        "web_url": "https://www.gov.uk/raib-reports",
        "expanded_links": { }
      }
    ],
    "organisations": [
      {
        "analytics_identifier": "OT249",
        "api_url": "https://www.gov.uk/api/content/government/organisations/rail-accident-investigation-branch",
        "base_path": "/government/organisations/rail-accident-investigation-branch",
        "content_id": "013872d8-8bbb-4e80-9b79-45c7c5cf9177",
        "description": null,
        "locale": "en",
        "public_updated_at": "2015-04-01T09:33:41.000Z",
        "title": "Rail Accident Investigation Branch",
        "web_url": "https://www.gov.uk/government/organisations/rail-accident-investigation-branch",
        "expanded_links": { }
      }
    ],
    "available_translations": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/raib-reports/email-signup",
        "base_path": "/raib-reports/email-signup",
        "content_id": "db81c7e8-b1b6-4c29-992a-1289f1b63073",
        "description": "You'll get an email each time a report is updated or a new report is published.",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000Z",
        "title": "Rail Accident Investigation Branch reports",
        "web_url": "https://www.gov.uk/raib-reports/email-signup"
      }
    ]
  },
  "first_published_at": "2016-02-29T09:24:10.000+00:00",
  "format": "finder_email_signup",
  "locale": "en",
  "need_ids": [ ],
  "phase": "live",
  "public_updated_at": "2016-06-13T14:30:40.000+00:00",
  "publishing_app": "specialist-publisher",
  "rendering_app": "finder-frontend",
  "schema_name": "finder_email_signup",
  "title": "Rail Accident Investigation Branch reports",
  "updated_at": "2016-06-13T14:31:34.931Z",
  "withdrawn_notice": { },
  "links": {
    "related": [
      {
        "content_id": "e3ff7fc5-6788-45de-83f0-cbf34e9fe8bd",
        "title": "Rail Accident Investigation Branch reports",
        "base_path": "/raib-reports",
        "description": "Find reports of RAIB investigations into rail accidents and incidents",
        "api_url": "https://www.gov.uk/api/content/raib-reports",
        "web_url": "https://www.gov.uk/raib-reports",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000+00:00",
        "schema_name": "finder",
        "document_type": "finder",
        "analytics_identifier": null,
        "links": {
          "email_alert_signup": [
            "db81c7e8-b1b6-4c29-992a-1289f1b63073"
          ],
          "organisations": [
            "013872d8-8bbb-4e80-9b79-45c7c5cf9177"
          ]
        }
      }
    ],
    "organisations": [
      {
        "content_id": "013872d8-8bbb-4e80-9b79-45c7c5cf9177",
        "title": "Rail Accident Investigation Branch",
        "base_path": "/government/organisations/rail-accident-investigation-branch",
        "description": null,
        "api_url": "https://www.gov.uk/api/content/government/organisations/rail-accident-investigation-branch",
        "web_url": "https://www.gov.uk/government/organisations/rail-accident-investigation-branch",
        "locale": "en",
        "public_updated_at": "2015-04-01T09:33:41.000+00:00",
        "schema_name": "placeholder",
        "document_type": "organisation",
        "analytics_identifier": "OT249",
        "links": { },
        "details": {
          "brand": "department-for-transport",
          "logo": {
            "formatted_title": "Rail Accident<br/>Investigation Branch",
            "crest": null
          }
        }
      }
    ],
    "available_translations": [
      {
        "content_id": "db81c7e8-b1b6-4c29-992a-1289f1b63073",
        "title": "Rail Accident Investigation Branch reports",
        "base_path": "/raib-reports/email-signup",
        "description": "You'll get an email each time a report is updated or a new report is published.",
        "api_url": "https://www.gov.uk/api/content/raib-reports/email-signup",
        "web_url": "https://www.gov.uk/raib-reports/email-signup",
        "locale": "en",
        "public_updated_at": "2016-06-13T14:30:40.000+00:00",
        "schema_name": "finder_email_signup",
        "document_type": "finder_email_signup",
        "analytics_identifier": null,
        "links": {
          "related": [
            "e3ff7fc5-6788-45de-83f0-cbf34e9fe8bd"
          ],
          "organisations": [
            "013872d8-8bbb-4e80-9b79-45c7c5cf9177"
          ]
        }
      }
    ]
  },
  "description": "You'll get an email each time a report is updated or a new report is published.",
  "details": {
    "beta": false,
    "email_signup_choice": [
      {
        "key": "heavy-rail",
        "radio_button_name": "Heavy rail",
        "topic_name": "heavy rail",
        "prechecked": false
      },
      {
        "key": "light-rail",
        "radio_button_name": "Light rail",
        "topic_name": "light rail",
        "prechecked": false
      },
      {
        "key": "metros",
        "radio_button_name": "Metros",
        "topic_name": "metros",
        "prechecked": false
      },
      {
        "key": "heritage-railways",
        "radio_button_name": "Heritage railways",
        "topic_name": "heritage railways",
        "prechecked": false
      }
    ],
    "email_filter_by": "railway_type",
    "subscription_list_title_prefix": {
      "singular": "Rail Accident Investigation Branch (RAIB) reports with the following railway type: ",
      "plural": "Rail Accident Investigation Branch (RAIB) reports with the following railway types: "
    }
  }

}
```



