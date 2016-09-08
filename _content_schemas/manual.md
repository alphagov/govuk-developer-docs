---
layout: content_schema
title:  Manual
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/manual/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>child_section_groups</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_notes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>manual</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/manual/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>organisations</strong> </td> <td>All organisations linked to this content item. This should include lead organisations.</td></tr>
<tr><td><strong>sections</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/manual/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>child_section_groups</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_notes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>sections</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr>
<tr><td><strong>taxons</strong> </td> <td></td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>topics</strong> </td> <td></td></tr>
<tr><td><strong>parent</strong> </td> <td></td></tr>
<tr><td><strong>policies</strong> </td> <td></td></tr>
<tr><td><strong>policy_areas</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>manual</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### content-design.json
```json
{
  "content_id": "9b2e22e1-a222-4cda-9799-de7ce56088b0",
  "base_path": "/guidance/content-design",
  "title": "Content design: planning, writing and managing content",
  "description": "Planning and managing digital content to meet the needs the public has of government.",
  "format": "manual",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-04-27T12:54:38.685Z",
  "public_updated_at": "2015-04-27T12:54:27.000+00:00",
  "details": {
    "body": "<p>Vis nostro intellegebat at. Impedit pericula duo ne, pri nonumes ullamcorper in. Oratio invidunt et his, ele, at principes similique nam. No eam eleifend euripidis intellegat, sensibus theophrastus consectetuer.\nSumo solum quaestio has cu. Eu oblique euismod deleniti eum, congue necessitatibus ne sit.\nNo eum mutat soleat definiebas, ut argumentum efficiantur delicatissimi ius. At feugait adversarium vel. At cum mutat numquam graecis. Sit appareat adolescens constituto eu, te eleifend postulant theophrastus eam\nIf you would like to receive email updates for daily ice cream flavours, send us a hand written note.\nVel ut iudico dolore. Vix ne diam iuvaret referrentur, eam nisl accusamus temporibus ne.If you like yoga <a href=\"/lloydsfactsheet\">click here</a>.</p>\n",
    "child_section_groups": [
      {
        "title": "Contents",
        "child_sections": [
          {
            "title": "What is content design?",
            "description": "Introduction to content design.",
            "base_path": "/guidance/content-design/what-is-content-design"
          },
          {
            "title": "User needs",
            "description": "How to write and record a user need for GOV.UK.",
            "base_path": "/guidance/content-design/user-needs"
          },
          {
            "title": "Planning content",
            "description": "Find out how to decide if something is suitable for GOV.UK, what the content lifecycle is and why accessibility must be planned for.",
            "base_path": "/guidance/content-design/planning-content"
          }
        ]
      }
    ],
    "change_notes": [
      {
        "base_path": "/guidance/content-design/what-is-content-design",
        "title": "What is content design?",
        "change_note": "New section added.",
        "published_at": "2014-10-06T19:49:25Z"
      },
      {
        "base_path": "/guidance/content-design/user-needs",
        "title": "User needs",
        "change_note": "New section added.",
        "published_at": "2014-10-06T19:49:25Z"
      },
      {
        "base_path": "/guidance/content-design/planning-content",
        "title": "Planning content",
        "change_note": "New section added.",
        "published_at": "2014-10-06T19:49:25Z"
      },
      {
        "base_path": "/guidance/content-design/content-types",
        "title": "Content types",
        "change_note": "New section added.",
        "published_at": "2014-10-06T19:49:25Z"
      }
    ],
    "organisations": [
      {
        "title": "Government Digital Service",
        "abbreviation": "GDS",
        "web_url": "https://www.gov.uk/government/organisations/government-digital-service"
      }
    ]
  },
  "links": {
    "available_translations": [
      {
        "content_id": "9b2e22e1-a222-4cda-9799-de7ce56088b0",
        "title": "Content design: planning, writing and managing content",
        "base_path": "/guidance/content-design",
        "api_url": "https://content-store.preview.alphagov.co.uk/content/guidance/content-design",
        "web_url": "https://www.preview.alphagov.co.uk/guidance/content-design",
        "locale": "en"
      }
    ]
  },
  "schema_name": "manual",
  "document_type": "manual"
}

```



