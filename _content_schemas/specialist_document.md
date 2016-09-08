---
layout: content_schema
title:  Specialist document
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/specialist_document/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>attachments</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>metadata</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>max_cache_time</strong> <code>integer</code></td> <td>The maximum length of time the content should be cached, in seconds.</td></tr>
<tr><td><strong>headers</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>temporary_update_type</strong> <code>boolean</code></td> <td>Indicates that the user should choose a new update type on the next save.</td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>specialist_document</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/specialist_document/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/specialist_document/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>attachments</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>metadata</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>max_cache_time</strong> <code>integer</code></td> <td>The maximum length of time the content should be cached, in seconds.</td></tr>
<tr><td><strong>headers</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>temporary_update_type</strong> <code>boolean</code></td> <td>Indicates that the user should choose a new update type on the next save.</td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td>Allowed values: <code>aaib_report</code> or <code>asylum_support_decision</code> or <code>cma_case</code> or <code>countryside_stewardship_grant</code> or <code>dfid_research_output</code> or <code>drug_safety_update</code> or <code>employment_appeal_tribunal_decision</code> or <code>employment_tribunal_decision</code> or <code>esi_fund</code> or <code>international_development_fund</code> or <code>maib_report</code> or <code>medical_safety_alert</code> or <code>raib_report</code> or <code>tax_tribunal_decision</code> or <code>utaac_decision</code> or <code>vehicle_recalls_and_faults_alert</code></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>specialist_document</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### aaib-reports.json
```json
{
  "content_id": "fb81a47b-7c8f-4280-b6c7-b6fa258b19b3",
  "public_updated_at": "2015-07-09T08:17:10+00:00",
  "format": "specialist_document",
  "locale": "en",
  "details": {
    "body": "<h2 id=\"summary\">Summary:</h2>\n<p>The gyroplane began to move forward against the brakes before sufficient rotor rpm had been achieved for takeoff.  The pilot responded by re-positioning the control stick fully aft and the rotors struck the tailplane.  The pilot lost directional control and the right landing gear subsequently failed, causing the gyroplane to tip onto its right side.  The pilot was uninjured.</p>\n\n<h3 id=\"download-report\">Download report:</h3>\n<p><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/559e25de40f0b61564000039/Rotorsport_UK_Calidus_G-PCPC_07-15.pdf\">Rotorsport UK Calidus G-PCPC 07-15</a> </p>\n\n<h3 id=\"download-glossary-of-abbreviations\">Download glossary of abbreviations:</h3>\n<p><a href=\"https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/433812/Glossary_of_abbreviations.pdf\">Glossary of abbreviations</a></p>\n\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/aaib-report-image.jpg",
        "content_type": "application/jpeg",
        "title": "aaib reports image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/aaib-report-pdf.pdf",
        "content_type": "application/pdf",
        "title": "aaib reports pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "aircraft_category": [
        "sport-aviation-and-balloons"
      ],
      "report_type": "correspondence-investigation",
      "date_of_occurrence": "2015-08-08",
      "bulk_published": false,
      "aircraft_type": "Rotorsport UK Calidus",
      "location": "Damyns Hall Aerodrome, Essex",
      "registration": "G-PCPC",
      "document_type": "aaib_report"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Summary:",
        "level": 2,
        "id": "summary",
        "headers": [
          {
            "text": "Download report:",
            "level": 3,
            "id": "download-report"
          },
          {
            "text": "Download glossary of abbreviations:",
            "level": 3,
            "id": "download-glossary-of-abbreviations"
          }
        ]
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-07-09T08:17:10+00:00"
      }
    ]
  },
  "base_path": "/aaib-reports/aaib-investigation-to-rotorsport-uk-calidus-g-pcpc",
  "description": "Overturned after rotor struck tailplane during preparation for takeoff, Damyns Hall Aerodrome, Essex, 8 April 2015.",
  "title": "AAIB investigation to Rotorsport UK Calidus, G-PCPC\t",
  "updated_at": "2015-07-09T08:54:30+00:00",
  "schema_name": "specialist_document",
  "document_type": "aaib_report",
  "links": {
  }
}

```

### asylum-support-decision.json
```json
{
  "content_id": "3917cb0e-0928-45b7-bf63-20f9bc113a7a",
  "base_path": "/asylum-support-decisions/ast-06-04-13140",
  "title": "AST / 06 / 04 / 13140",
  "description": "The House of Lords guidance in Limbuela did not include failed asylum seekers - paragraphs 13, 81 and 100 of their Lordships' judgement refers - the solution to a failed asylum seeker's destitution lies in his own hands by way of a voluntary return home - an option not expected of an asylum seeker",
  "format": "specialist_document",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-09-04T09:04:39.828Z",
  "public_updated_at": "2015-09-04T09:04:39.000+00:00",
  "details": {
    "metadata": {
      "tribunal_decision_judges": [
        "sally-verity-smith"
      ],
      "bulk_published": false,
      "tribunal_decision_category": "section-4-2-failed-asylum-seekers",
      "tribunal_decision_sub_category": "section-4-2-jurisdiction",
      "tribunal_decision_landmark": "landmark",
      "tribunal_decision_reference_number": "AST / 06 / 04 / 13140",
      "tribunal_decision_decision_date": "2006-04-27",
      "hidden_indexable_content": "The appellant, an Iranian Kurd born on 20 February 1979, appeals against the decision of the Secretary of State who refused support under Section 4 of the Immigration and Asylum Act 1999 (“the Act”) on 8 April 2006 on the grounds that the appellant did not satisfy one or more of the conditions set out in Regulation 3 of the Immigration and Asylum (Provision of Accommodation to Failed Asylum Seekers) Regulations 2005 (“the 2005 Regulations”). \r\n...\r\n",
      "document_type": "asylum_support_decision"
    },
    "max_cache_time": 10,
    "change_history": [
      {
        "public_timestamp": "2015-09-04T09:03:56+00:00",
        "note": "First published."
      },
      {
        "public_timestamp": "2015-09-04T09:04:39+00:00",
        "note": "date format"
      }
    ],
    "body": "<p>Download decision: </p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/asylum-support-image.jpg",
        "content_type": "application/jpeg",
        "title": "asylum report image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/asylum-support-pdf.pdf",
        "content_type": "application/pdf",
        "title": "asylum report pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ]
  },
  "links": {
    "available_translations": [
      {
        "content_id": "3917cb0e-0928-45b7-bf63-20f9bc113a7a",
        "title": "AST / 06 / 04 / 13140",
        "base_path": "/asylum-support-decisions/ast-06-04-13140",
        "description": "The House of Lords guidance in Limbuela did not include failed asylum seekers - paragraphs 13, 81 and 100 of their Lordships' judgement refers - the solution to a failed asylum seeker's destitution lies in his own hands by way of a voluntary return home - an option not expected of an asylum seeker",
        "api_url": "http://content-store.dev.gov.uk/content/asylum-support-decisions/ast-06-04-13140",
        "web_url": "http://www.dev.gov.uk/asylum-support-decisions/ast-06-04-13140",
        "locale": "en"
      }
    ]
  },
  "schema_name": "specialist_document",
  "document_type": "asylum_support_decision"
}

```

### cma-cases.json
```json
{
  "content_id": "574585b6-bf99-4cb1-be8b-628695f358d9",
  "format": "specialist_document",
  "locale": "en",
  "base_path": "/cma-cases/richemont-yoox-net-a-porter-merger-inquiry",
  "title": "Richemont / Yoox / Net-A-Porter merger inquiry",
  "description": "The CMA is investigating the anticipated acquisition relating to Compagnie Financière Richemont S.A., Yoox S.p.A and The Net-A-Porter Group Limited. ",
  "details": {
    "body": "<h2 id=\"statutory-timetable\">Statutory timetable</h2>\n\n<table>\n  <thead>\n    <tr>\n      <th>Phase 1 date</th>\n      <th>Action</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>7 September 2015</td>\n      <td>Deadline for phase 1 decision (*)</td>\n    </tr>\n    <tr>\n      <td>10 to 24 July 2015</td>\n      <td>Invitation to comment</td>\n    </tr>\n    <tr>\n      <td>10 July 2015</td>\n      <td>Launch of merger inquiry</td>\n    </tr>\n  </tbody>\n</table>\n\n<p>(*) This date is the current statutory deadline by when the decision will be announced. If any change occurs, the information is refreshed as soon as practicable. However, the CMA cannot guarantee that the decision will be announced on or before this current deadline, as the deadline of a given case may change during the merger assessment process due to different reasons.</p>\n\n<h2 id=\"phase-1\">Phase 1</h2>\n\n<h3 id=\"invitation-to-comment-closes-24-july-2015\">Invitation to comment: closes 24 July 2015</h3>\n\n<p>10 July 2015: The CMA is considering whether it is or may be the case that this transaction has resulted in the creation of a relevant merger situation under the merger provisions of the Enterprise Act 2002 and, if so, whether the creation of that situation has resulted, or may be expected to result, in a substantial lessening of competition within any market or markets in the United Kingdom for goods or services.</p>\n\n<h3 id=\"launch-of-cma-merger-inquiry\">Launch of CMA merger inquiry</h3>\n\n<p>10 July 2015: The CMA announced the launch of its merger inquiry by notice to the parties.</p>\n\n<ul>\n  <li><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/559fc1b240f0b61564000047/Richemont-Yoox-NAP_commencement_of_initial_period_notice.pdf\">Commencement of initial period notice</a> (10.7.15)</li>\n</ul>\n\n<h3 id=\"contact\">Contact</h3>\n\n<p>Please send written representations about any competition issues to:</p>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nSuzanne Van Scheijen\n<br />Competition and Markets Authority \n<br />Victoria House \n<br />Southampton Row \n<br />London \n<br />WC1B 4AD\n<br />\n</p></div></div>\n\n<p><a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#083;&#117;&#122;&#097;&#110;&#110;&#101;&#046;&#086;&#097;&#110;&#083;&#099;&#104;&#101;&#105;&#106;&#101;&#110;&#064;&#099;&#109;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#083;&#117;&#122;&#097;&#110;&#110;&#101;&#046;&#086;&#097;&#110;&#083;&#099;&#104;&#101;&#105;&#106;&#101;&#110;&#064;&#099;&#109;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/cma-cases-image.jpg",
        "content_type": "application/jpeg",
        "title": "cma-cases report image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/cma-cases-pdf.pdf",
        "content_type": "application/pdf",
        "title": "cma-cases report pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "case_type": "mergers",
      "case_state": "closed",
      "market_sector": [
        "clothing-footwear-and-fashion"
      ],
      "opened_date": "2015-07-10",
      "closed_date": "2015-08-20"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Statutory timetable",
        "level": 2,
        "id": "statutory-timetable"
      },
      {
        "text": "Phase 1",
        "level": 2,
        "id": "phase-1",
        "headers": [
          {
            "text": "Invitation to comment: closes 24 July 2015",
            "level": 3,
            "id": "invitation-to-comment-closes-24-july-2015"
          },
          {
            "text": "Launch of CMA merger inquiry",
            "level": 3,
            "id": "launch-of-cma-merger-inquiry"
          },
          {
            "text": "Contact",
            "level": 3,
            "id": "contact"
          }
        ]
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-07-10T13:09:46+00:00"
      }
    ]
  },
  "public_updated_at": "2015-07-10T13:09:46+00:00",
  "schema_name": "specialist_document",
  "document_type": "cma_case",
  "links": {
  }
}

```

### countryside-stewardship-grants.json
```json
{
  "content_id": "6f86e13a-04f5-4b69-98f3-4ab374c764e0",
  "format": "specialist_document",
  "locale": "en",
  "base_path": "/countryside-stewardship-grants/nectar-flower-mix-ab1",
  "title": "Nectar flower mix (AB1)",
  "description": "Find out about eligibility and requirements for the nectar flower mix option.\r\n",
  "details": {
    "body": "<h2 id=\"how-much-will-be-paid\">How much will be paid</h2>\n\n<p>£511 per hectare (ha).</p>\n\n<p>If this option is used to meet Ecological Focus Area (EFA) requirements for the Basic Payments Scheme (BPS), the payment rate is reduced because of double funding to £107 per ha.</p>\n\n<h2 id=\"where-the-option-is-available\">Where the option is available</h2>\n\n<p>This is a rotational, whole or part parcel option. This option is available for:</p>\n\n<ul>\n  <li>Mid Tier</li>\n  <li>Higher Tier</li>\n</ul>\n\n<p>It can only be used on:</p>\n\n<ul>\n  <li>arable land</li>\n  <li>temporary grass</li>\n  <li>bush orchards</li>\n</ul>\n\n<h3 id=\"when-this-option-cant-be-used\">When this option can’t be used</h3>\n\n<p>This option can&rsquo;t be used:</p>\n\n<ul>\n  <li>where evidence or records exist for important arable plants (Plantlife IAPA classification 4 and above) - these can either be historic (within the last 40 years) or from recent arable plant survey results</li>\n  <li>on organic land or on land in conversion to organic status</li>\n</ul>\n\n<h2 id=\"how-to-apply\">How to apply</h2>\n\n<p>Applicants can read the <a href=\"https://www.gov.uk/guidance/countryside-stewardship\">Countryside Stewardship guidance</a> for more on eligibility and <a href=\"https://www.gov.uk/guidance/countryside-stewardship/how-to-apply\">how to apply</a>.</p>\n\n<h2 id=\"how-this-option-will-benefit-the-environment\">How this option will benefit the environment</h2>\n\n<p>This option provides areas of flowering plants to boost essential food sources for beneficial pollinators. </p>\n\n<p>If successful there will be:</p>\n\n<ul>\n  <li>an abundant supply of pollen and nectar-rich flowers between early and late summer </li>\n  <li>pollinating insects such as bumblebees, solitary bees, butterflies and hoverflies using the flowers</li>\n</ul>\n\n<h2 id=\"requirements\">Requirements</h2>\n\n<h3 id=\"higher-tier-agreements\">Higher Tier agreements</h3>\n\n<p>The requirements may differ slightly for a Higher Tier agreement as the option will be tailored to the site. Applicants should discuss and agree these requirements with their adviser.</p>\n\n<h3 id=\"on-the-land\">On the land</h3>\n<p>Successful applicants will need to:</p>\n\n<ul>\n  <li>establish a mix of at least 4 nectar-rich plants and at least 2 perennials </li>\n  <li>establish the mix in blocks or strips between 15 March and 30 April or 15 July to 30 August</li>\n  <li>rotationally cut 50% of the plot area each year between 15 April and 31 May - don’t cut the same area in successive years</li>\n  <li>cut the whole area between 15 September and 30 March, removing or shredding cuttings to avoid patches of dead material developing</li>\n</ul>\n\n<h3 id=\"keeping-records\">Keeping records</h3>\n\n<p>Successful applicants will need to keep the following records and supply them on request:</p>\n\n<ul>\n  <li>photographs of the established mixture and seed invoices – submit these with the annual claim</li>\n  <li>stock records to show grazing activity on parcels</li>\n</ul>\n\n<h2 id=\"what-must-not-be-done\">What must not be done</h2>\n\n<p>Don&rsquo;t graze between 15 March and 31 August.</p>\n\n<h2 id=\"how-to-carry-out-this-option\">How to carry out this option</h2>\n\n<p>The following section gives advice on carrying out this option successfully but does not form part of the requirements for this option.</p>\n\n<h3 id=\"pick-the-right-location\">Pick the right location</h3>\n\n<p>Use lower-yielding areas if they:</p>\n\n<ul>\n  <li>have a sunny aspect</li>\n  <li>face south or south-southwest</li>\n</ul>\n\n<p>Avoid planting:</p>\n\n<ul>\n  <li>under overhanging trees</li>\n  <li>next to tall hedges</li>\n  <li>on land facing north or east</li>\n</ul>\n\n<p>Leave access to surrounding crops for in-season management.</p>\n\n<h3 id=\"block-and-plot-sizes\">Block and plot sizes</h3>\n\n<p>Use wide margins and big blocks between 0.25ha and 0.5ha. This lets insects move to safety when bordering fields are being sprayed.</p>\n\n<p>Spacing five 0.5ha patches evenly within 100ha meets the food needs of many pollinators. </p>\n\n<h3 id=\"what-to-sow\">What to sow</h3>\n\n<p>The seed mix used should contain both short-term nectar rich and perennial plants, such as:</p>\n\n<ul>\n  <li>early and late flowering red clovers</li>\n  <li>alsike clover </li>\n  <li>sainfoin </li>\n  <li>birdsfoot trefoil </li>\n  <li>black knapweed </li>\n  <li>musk mallow</li>\n</ul>\n\n<p>Sow at 12kg per ha to provide enough plants.  </p>\n\n<p>Avoid short-term mixes that don’t include knapweed or mallow as they won’t supply pollinators with long-term food sources for years 4 and 5 of the agreement.</p>\n\n<h3 id=\"when-to-sow\">When to sow</h3>\n\n<p>Establish the mix in spring or autumn of year 1 of the agreement.</p>\n\n<p>Stop sowing by mid-September to avoid slug and frost damage as this tends to happen more often in later sown mixes.</p>\n\n<h3 id=\"how-to-sow\">How to sow</h3>\n\n<p>Sow by broadcasting seeds rather than drilling, when the soil is warm and moist. Use a ring roll before and after sowing. Check regularly for slug damage. </p>\n\n<h3 id=\"management\">Management</h3>\n\n<p>Cut emerging flowers and weeds at least 2 times in year 1 and up to 4 times if necessary, where the soil is particularly fertile. Regular cutting prevents weeds smothering the slow-growing flowers so all sown species are established successfully. </p>\n\n<p>Plots can be grazed between 1 September and 30 March but there must not be any:</p>\n\n<ul>\n  <li>poaching or soil compaction by livestock</li>\n  <li>supplementary feeding carried out</li>\n</ul>\n\n<p>Keep nectar plots until the end of the agreement. </p>\n\n<h2 id=\"further-information\">Further information</h2>\n\n<p>Order the ‘Growing farm wildlife’ DVD from Natural England which gives a step-by-step approach to sowing nectar flower mixtures. </p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/countryside-stewardship-grants-image.jpg",
        "content_type": "application/jpeg",
        "title": "countryside stewardship image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/countryside-stewardship-grants-pdf.pdf",
        "content_type": "application/pdf",
        "title": "countryside stewardship pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "grant_type": "option",
      "land_use": [
        "arable-land",
        "wildlife-package"
      ],
      "tiers_or_standalone_items": [
        "higher-tier",
        "mid-tier"
      ],
      "funding_amount": [
        "more-than-500"
      ],
      "document_type": "countryside_stewardship_grant"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "How much will be paid",
        "level": 2,
        "id": "how-much-will-be-paid"
      },
      {
        "text": "Where the option is available",
        "level": 2,
        "id": "where-the-option-is-available",
        "headers": [
          {
            "text": "When this option can’t be used",
            "level": 3,
            "id": "when-this-option-cant-be-used"
          }
        ]
      },
      {
        "text": "How to apply",
        "level": 2,
        "id": "how-to-apply"
      },
      {
        "text": "How this option will benefit the environment",
        "level": 2,
        "id": "how-this-option-will-benefit-the-environment"
      },
      {
        "text": "Requirements",
        "level": 2,
        "id": "requirements",
        "headers": [
          {
            "text": "Higher Tier agreements",
            "level": 3,
            "id": "higher-tier-agreements"
          },
          {
            "text": "On the land",
            "level": 3,
            "id": "on-the-land"
          },
          {
            "text": "Keeping records",
            "level": 3,
            "id": "keeping-records"
          }
        ]
      },
      {
        "text": "What must not be done",
        "level": 2,
        "id": "what-must-not-be-done"
      },
      {
        "text": "How to carry out this option",
        "level": 2,
        "id": "how-to-carry-out-this-option",
        "headers": [
          {
            "text": "Pick the right location",
            "level": 3,
            "id": "pick-the-right-location"
          },
          {
            "text": "Block and plot sizes",
            "level": 3,
            "id": "block-and-plot-sizes"
          },
          {
            "text": "What to sow",
            "level": 3,
            "id": "what-to-sow"
          },
          {
            "text": "When to sow",
            "level": 3,
            "id": "when-to-sow"
          },
          {
            "text": "How to sow",
            "level": 3,
            "id": "how-to-sow"
          },
          {
            "text": "Management",
            "level": 3,
            "id": "management"
          }
        ]
      },
      {
        "text": "Further information",
        "level": 2,
        "id": "further-information"
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-04-02T11:07:32+00:00"
      }
    ]
  },
  "public_updated_at": "2015-04-02T11:07:32+00:00",
  "schema_name": "specialist_document",
  "document_type": "countryside_stewardship_grant",
  "links": {
  }
}

```

### drug-device-alerts.json
```json
{
  "content_id": "23714fce-cd0f-45cf-abae-65eec4756981",
  "format": "specialist_document",
  "locale": "en",
  "base_path": "/drug-device-alerts/transwarmer-infant-transport-mattress-novaplus-transwarmer-infant-heat-therapy-mattress-with-warmgel-infant-heel-warmer-risk-of-serious-burn",
  "title": "TransWarmer infant transport mattress,  NovaPlus TransWarmer infant heat therapy mattress with WarmGel, infant heel warmer  - risk of serious burn",
  "description": "(CooperSurgical under different brand names) Risk of serious burn if device is used past its expiry date (MDA/2015/025)",
  "details": {
    "body": "<h2 id=\"action\">Action</h2>\n\n<ul>\n  <li>Identify and quarantine all product that does not have a lot or expiry date on the packaging (check the <a rel=\"external\" href=\"https://mhra.filecamp.com/public/file/28mi-dc53bihr\">transport mattress field safety notice (FSN)</a> and <a href=\"https://mhra.filecamp.com/public/file/28mh-2firuo71 to see where the expiry date should be\">heel warmer FSN</a>.</li>\n  <li>Discard or return affected product to your supplier.</li>\n  <li>Return the relevant acknowledgement and receipt form to the manufacturer.</li>\n</ul>\n\n<h4 id=\"action-by\">Action by</h4>\n\n<p>All staff who use these devices</p>\n\n<h4 id=\"deadlines-for-actions\">Deadlines for actions</h4>\n\n<p>Actions underway: 20 July 2015, actions complete: 3 August 2015</p>\n\n<h2 id=\"device-details\">Device details</h2>\n\n<p>Mattresses</p>\n\n<table>\n  <thead>\n    <tr>\n      <th>Package label</th>\n      <th>Part</th>\n      <th>Product description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>CooperSurgical</td>\n      <td>20421</td>\n      <td>TransWarmer® infant transport   mattress</td>\n    </tr>\n    <tr>\n      <td>NovaPlus</td>\n      <td>V6390</td>\n      <td>NovaPlus TransWarmer® infant   heat therapy mattress with WarmGel®</td>\n    </tr>\n  </tbody>\n</table>\n\n<p>Heel warmers</p>\n\n<table>\n  <thead>\n    <tr>\n      <th>Package label</th>\n      <th>Part</th>\n      <th>Product description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>CooperSurgical</td>\n      <td>20418</td>\n      <td>WarmGel infant heel warmer</td>\n    </tr>\n    <tr>\n      <td>CooperSurgical</td>\n      <td>24401</td>\n      <td>Liquid infant heel warmer</td>\n    </tr>\n    <tr>\n      <td>Fisher Brand</td>\n      <td>24647</td>\n      <td>FISHERBRAND gel infant heel   warmer</td>\n    </tr>\n    <tr>\n      <td>Fisher Brand</td>\n      <td>24646</td>\n      <td>FISHERBRAND liquid infant -   heel warmer</td>\n    </tr>\n    <tr>\n      <td>MediChoice</td>\n      <td>24649</td>\n      <td>MEDICHOICE warmgel infant heel   warmer</td>\n    </tr>\n    <tr>\n      <td>MediChoice</td>\n      <td>24648</td>\n      <td>MEDICHOICE liquid infant - heel   warmer</td>\n    </tr>\n    <tr>\n      <td>NovaPlus</td>\n      <td>V6391</td>\n      <td>WARMGEL infant heel warmer -   NOVAPLUS</td>\n    </tr>\n    <tr>\n      <td>NovaPlus</td>\n      <td>V6393</td>\n      <td>Liquid infant heel warmer -   NOVAPLUS</td>\n    </tr>\n  </tbody>\n</table>\n\n<h2 id=\"manufacturer-contacts\">Manufacturer contacts</h2>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nCooperSurgical\n<br />Attn: Product Surveillance\n<br />75 Corporate Dr\n<br />Trumbull CT 06611, USA\n<br />USA phone: +1 203-601-5200 ext. 3414  \n<br />USA fax: +1 203-601-9870\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#112;&#114;&#111;&#100;&#117;&#099;&#116;&#115;&#117;&#114;&#118;&#101;&#105;&#108;&#108;&#097;&#110;&#099;&#101;&#064;&#099;&#111;&#111;&#112;&#101;&#114;&#115;&#117;&#114;&#103;&#105;&#099;&#097;&#108;&#046;&#099;&#111;&#109;\">&#112;&#114;&#111;&#100;&#117;&#099;&#116;&#115;&#117;&#114;&#118;&#101;&#105;&#108;&#108;&#097;&#110;&#099;&#101;&#064;&#099;&#111;&#111;&#112;&#101;&#114;&#115;&#117;&#114;&#103;&#105;&#099;&#097;&#108;&#046;&#099;&#111;&#109;</a></p>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nEuropean Authorised Representative – Emergo Europe\n<br />Telephone: +31 70 346 7299\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#118;&#105;&#103;&#105;&#108;&#097;&#110;&#099;&#101;&#064;&#101;&#109;&#101;&#114;&#103;&#111;&#103;&#114;&#111;&#117;&#112;&#046;&#099;&#111;&#109;\">&#118;&#105;&#103;&#105;&#108;&#097;&#110;&#099;&#101;&#064;&#101;&#109;&#101;&#114;&#103;&#111;&#103;&#114;&#111;&#117;&#112;&#046;&#099;&#111;&#109;</a></p>\n\n<h2 id=\"distribution\">Distribution</h2>\n\n<p>If you are responsible for cascading these alerts in your organisation, these are our suggested distribution lists.</p>\n\n<p>Trusts (NHS boards in Scotland) </p>\n\n<p>CAS and SABS (NI) liaison officers for onward distribution to all relevant staff including:</p>\n\n<ul>\n  <li>A&amp;E consultants</li>\n  <li>A&amp;E departments</li>\n  <li>A&amp;E directors</li>\n  <li>A&amp;E nurses</li>\n  <li>All departments</li>\n  <li>Ambulance services directors</li>\n  <li>Community children’s nurses</li>\n  <li>Community hospitals</li>\n  <li>Community midwives</li>\n  <li>Community nurses</li>\n  <li>District nurses</li>\n  <li>Gynaecologists</li>\n  <li>Gynaecology departments</li>\n  <li>Gynaecology nurses</li>\n  <li>Health visitors</li>\n  <li>Hospital at home units</li>\n  <li>Immunisation co-ordinators</li>\n  <li>Intensive care medical staff/paediatrics</li>\n  <li>Intensive care nursing staff (paediatric)</li>\n  <li>Intensive care units</li>\n  <li>Intensive care, directors of</li>\n  <li>Maternity units</li>\n  <li>Midwifery departments</li>\n  <li>Midwifery staff</li>\n  <li>Neonatal nurse specialists</li>\n  <li>Neonatology departments</li>\n  <li>Neonatology directors</li>\n  <li>Obstetricians</li>\n  <li>Obstetrics and gynaecology departments</li>\n  <li>Obstetrics and gynaecology directors</li>\n  <li>Obstetrics departments</li>\n  <li>Obstetrics nurses</li>\n  <li>Paediatric intensive care units</li>\n  <li>Paediatric medicine, directors of</li>\n  <li>Paediatric nurse specialists</li>\n  <li>Paediatric oncologists</li>\n  <li>Paediatric surgeons</li>\n  <li>Paediatric surgery, directors of</li>\n  <li>Paediatric wards</li>\n  <li>Paediatricians</li>\n  <li>Paediatrics departments</li>\n  <li>Paramedics</li>\n  <li>Patient transport managers</li>\n  <li>Phlebotomists</li>\n  <li>Point of care testing co-ordinators</li>\n  <li>Purchasing managers</li>\n  <li>Special care baby units</li>\n  <li>Supplies managers</li>\n  <li>Theatre managers</li>\n  <li>Theatre nurses</li>\n  <li>Theatres</li>\n</ul>\n\n<h4 id=\"nhs-england-area-teams\">NHS England area teams</h4>\n\n<p>CAS liaison officers for onward distribution to all relevant staff including:</p>\n\n<ul>\n  <li>General practice managers</li>\n  <li>General practice nurses</li>\n  <li>General practitioners</li>\n</ul>\n\n<h4 id=\"independent-distribution\">Independent distribution</h4>\n\n<h4 id=\"establishments-registered-with-the-care-quality-commission-cqc-england-only\">Establishments registered with the Care Quality Commission (CQC) (England only)</h4>\n\n<ul>\n  <li>Clinics</li>\n  <li>Hospitals in the independent sector</li>\n  <li>Independent treatment centres</li>\n  <li>Nursing agencies</li>\n  <li>Private medical practitioners</li>\n</ul>\n\n<p>Please note: CQC and OFSTED do not distribute these alerts. Independent healthcare providers and social care providers can sign up to receive MDAs directly from the Department of Health’s Central Alerting System (CAS) by sending an email to: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#115;&#097;&#102;&#101;&#116;&#121;&#097;&#108;&#101;&#114;&#116;&#115;&#064;&#100;&#104;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#115;&#097;&#102;&#101;&#116;&#121;&#097;&#108;&#101;&#114;&#116;&#115;&#064;&#100;&#104;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a> and requesting this facility.</p>\n\n<h2 id=\"enquiries\">Enquiries</h2>\n\n<h3 id=\"england\">England</h3>\n\n<p>Send enquiries about this notice to MHRA, quoting reference number MDA/2015/025 or 2015/004/027/291/014</p>\n\n<h4 id=\"technical-aspects\">Technical aspects</h4>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nElke Kerwick or Andy Marsden\n<br />MHRA\n<br />Telephone: 020 3080 6826 / 7205\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#101;&#108;&#107;&#101;&#046;&#107;&#101;&#114;&#119;&#105;&#099;&#107;&#064;&#109;&#104;&#114;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#101;&#108;&#107;&#101;&#046;&#107;&#101;&#114;&#119;&#105;&#099;&#107;&#064;&#109;&#104;&#114;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a> or <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#097;&#110;&#100;&#121;&#046;&#109;&#097;&#114;&#115;&#100;&#101;&#110;&#064;&#109;&#104;&#114;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#097;&#110;&#100;&#121;&#046;&#109;&#097;&#114;&#115;&#100;&#101;&#110;&#064;&#109;&#104;&#114;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n\n<h4 id=\"clinical-aspects\">Clinical aspects</h4>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nMark Grumbridge\n<br />MHRA\n<br />Telephone: 020 3080 7128\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#109;&#097;&#114;&#107;&#046;&#103;&#114;&#117;&#109;&#098;&#114;&#105;&#100;&#103;&#101;&#064;&#109;&#104;&#114;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#109;&#097;&#114;&#107;&#046;&#103;&#114;&#117;&#109;&#098;&#114;&#105;&#100;&#103;&#101;&#064;&#109;&#104;&#114;&#097;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n\n<h4 id=\"reporting-adverse-incidents-in-england\">Reporting adverse incidents in England</h4>\n\n<p><a rel=\"external\" href=\"https://yellowcard.mhra.gov.uk/\">Through Yellow Card</a> </p>\n\n<h3 id=\"northern-ireland\">Northern Ireland</h3>\n\n<p>Alerts in Northern Ireland are distributed via the NI SABS system.</p>\n\n<p>Enquiries and adverse incident reports in Northern Ireland should be addressed to:</p>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nNorthern Ireland Adverse Incident Centre\n<br />CMO Group, \n<br />Department of Health, Social Services and Public Safety\n<br />Telephone: 028 9052 3868\t\n<br />Fax:\t028 9052 3900\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#078;&#073;&#065;&#073;&#067;&#064;&#100;&#104;&#115;&#115;&#112;&#115;&#110;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#078;&#073;&#065;&#073;&#067;&#064;&#100;&#104;&#115;&#115;&#112;&#115;&#110;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n\n<p><a rel=\"external\" href=\"http://www.dhsspsni.gov.uk/index/hea/niaic.htm\">Northern Ireland Adverse Incident Centre</a></p>\n\n<h4 id=\"reporting-adverse-incidents-in-northern-ireland\">Reporting adverse incidents in Northern Ireland</h4>\n\n<p>Please report directly to NIAIC using the <a rel=\"external\" href=\"http://www.dhsspsni.gov.uk/index/phealth/niaic/niaic_reporting_incidents.htm\">forms on our website</a>.</p>\n\n<h3 id=\"scotland\">Scotland</h3>\n\n<p>Enquiries and adverse incident reports in Scotland should be addressed to:</p>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nIncident Reporting and Investigation Centre\n<br />Health Facilities Scotland\n<br />NHS National Services Scotland \n<br />Telephone: 0131 275 7575\t\n<br />Fax:\t0131 314 0722\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#110;&#115;&#115;&#046;&#105;&#114;&#105;&#099;&#064;&#110;&#104;&#115;&#046;&#110;&#101;&#116;\">&#110;&#115;&#115;&#046;&#105;&#114;&#105;&#099;&#064;&#110;&#104;&#115;&#046;&#110;&#101;&#116;</a></p>\n\n<h4 id=\"reporting-adverse-incidents-in-scotland\">Reporting adverse incidents in Scotland</h4>\n\n<p>NHS boards and local authorities in Scotland – <a rel=\"external\" href=\"http://www.hfs.scot.nhs.uk/services/incident-reporting-and-investigation-centre-iric/how-to-report-an-adverse-incident/\">report to Health Facilities Scotland</a>.  </p>\n\n<p>Contractors such as private hospitals carrying out NHS work and private care homes that accept social work funded clients – <a rel=\"external\" href=\"http://www.hfs.scot.nhs.uk/services/incident-reporting-and-investigation-centre-iric/how-to-report-an-adverse-incident/\">report to Health Facilities Scotland</a>.  </p>\n\n<p>Private facilities providing care to private clients report to the <a rel=\"external\" href=\"http://www.careinspectorate.com/index.php?option=com_content&amp;view=article&amp;id=7865&amp;Itemid=721\">Care Inspectorate</a> and <a rel=\"external\" href=\"https://yellowcard.mhra.gov.uk/\">MHRA</a>.</p>\n\n<h3 id=\"wales\">Wales</h3>\n\n<p>Enquiries in Wales should be addressed to:</p>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nHealthcare Quality Division\n<br />Welsh Government\n<br />Telephone: 01267 225278 / 02920 825510\n<br />\n</p></div></div>\n\n<p>Email: <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#072;&#097;&#122;&#045;&#065;&#105;&#099;&#064;&#119;&#097;&#108;&#101;&#115;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#072;&#097;&#122;&#045;&#065;&#105;&#099;&#064;&#119;&#097;&#108;&#101;&#115;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n\n<h2 id=\"download-documents\">Download documents</h2>\n\n<p><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/559a7d20e5274a1559000015/MDA-2015-025.pdf\">TransWarmer infant transport mattress,  NovaPlus TransWarmer infant heat therapy mattress with WarmGel , infant heel warmer  - risk of serious burn</a>  </p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/drug-device-alerts-image.jpg",
        "content_type": "application/jpeg",
        "title": "drug device report image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/drug-device-alerts-pdf.pdf",
        "content_type": "application/pdf",
        "title": "drug device report pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "alert_type": "devices",
      "medical_specialism": [
        "critical-care",
        "general-practice",
        "obstetrics-gynaecology",
        "paediatrics",
        "theatre-practitioners"
      ],
      "issued_date": "2015-07-06",
      "document_type": "medical_safety_alert"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Action",
        "level": 2,
        "id": "action"
      },
      {
        "text": "Device details",
        "level": 2,
        "id": "device-details"
      },
      {
        "text": "Manufacturer contacts",
        "level": 2,
        "id": "manufacturer-contacts"
      },
      {
        "text": "Distribution",
        "level": 2,
        "id": "distribution"
      },
      {
        "text": "Enquiries",
        "level": 2,
        "id": "enquiries",
        "headers": [
          {
            "text": "England",
            "level": 3,
            "id": "england",
            "headers": [
              {
                "text": "Technical aspects",
                "level": 4,
                "id": "technical-aspects"
              },
              {
                "text": "Clinical aspects",
                "level": 4,
                "id": "clinical-aspects"
              },
              {
                "text": "Reporting adverse incidents in England",
                "level": 4,
                "id": "reporting-adverse-incidents-in-england"
              }
            ]
          },
          {
            "text": "Northern Ireland",
            "level": 3,
            "id": "northern-ireland",
            "headers": [
              {
                "text": "Reporting adverse incidents in Northern Ireland",
                "level": 4,
                "id": "reporting-adverse-incidents-in-northern-ireland"
              }
            ]
          },
          {
            "text": "Scotland",
            "level": 3,
            "id": "scotland",
            "headers": [
              {
                "text": "Reporting adverse incidents in Scotland",
                "level": 4,
                "id": "reporting-adverse-incidents-in-scotland"
              }
            ]
          },
          {
            "text": "Wales",
            "level": 3,
            "id": "wales"
          }
        ]
      },
      {
        "text": "Download documents",
        "level": 2,
        "id": "download-documents"
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-07-06T13:38:42+00:00"
      }
    ]
  },
  "public_updated_at": "2015-07-06T13:38:42+00:00",
  "schema_name": "specialist_document",
  "document_type": "medical_safety_alert",
  "links": {
  }
}

```

### drug-safety-update.json
```json
{
  "content_id": "7a06f974-ffbd-467f-ba0b-7ade2a15f0e4",
  "format": "specialist_document",
  "locale": "en",
  "details": {
    "body": "\n<div class=\"call-to-action\">\n<p>When treating patients who are taking an SGLT2 inhibitor (canagliflozin, dapagliflozin or empagliflozin):</p>\n\n<ul>\n  <li>test for raised ketones in patients with symptoms of diabetic ketoacidosis (<abbr title=\"diabetic ketoacidosis\">DKA</abbr>); omitting this test could delay diagnosis of <abbr title=\"diabetic ketoacidosis\">DKA</abbr></li>\n  <li>if you suspect <abbr title=\"diabetic ketoacidosis\">DKA</abbr>, stop SGLT2 inhibitor treatment  </li>\n  <li>if <abbr title=\"diabetic ketoacidosis\">DKA</abbr> is confirmed, take appropriate measures to correct the <abbr title=\"diabetic ketoacidosis\">DKA</abbr> and to monitor glucose levels </li>\n  <li>inform patients of the symptoms and signs of <abbr title=\"diabetic ketoacidosis\">DKA</abbr> (see below); advise them to get immediate medical help if these occur</li>\n  <li>be aware that SGLT2 inhibitors are not approved for treatment of type 1 diabetes</li>\n  <li>please continue to report suspected side effects to SGLT2 inhibitors or any other medicines on a <a rel=\"external\" href=\"https://yellowcard.mhra.gov.uk/\">Yellow Card</a></li>\n</ul>\n</div>\n\n<h2 id=\"reports-of-diabetic-acidosis\">Reports of diabetic acidosis</h2>\n<p>Sodium glucose co-transporter 2 (SGLT2) inhibitors are licensed for use in adults with type 2 diabetes to improve glycaemic control. Serious and life-threatening cases of <abbr title=\"diabetic ketoacidosis\">DKA</abbr> have been reported in patients taking SGLT2 inhibitors (canagliflozin, dapagliflozin or empagliflozin). </p>\n\n<p>In several cases, blood glucose levels were only moderately elevated (eg &lt;14 mmol/L or 250 mg/dL), which is <strong>atypical for <abbr title=\"diabetic ketoacidosis\">DKA</abbr>.</strong> This atypical presentation could delay diagnosis and treatment. Therefore inform patients of the signs and symptoms of <abbr title=\"diabetic ketoacidosis\">DKA</abbr> (eg nausea, vomiting, anorexia, abdominal pain, excessive thirst, difficulty breathing, confusion, unusual fatigue or sleepiness) and test for raised ketones in patients with these signs and symptoms.</p>\n\n<p>Half of the cases occurred during the first 2 months of treatment. Some cases occurred shortly after stopping the SGLT2 inhibitor.</p>\n\n<p>One third of the cases involved off-label use in patients with type 1 diabetes. We remind you that this drug class is <strong>not licensed</strong> for the treatment of type 1 diabetes. </p>\n\n<p>The underlying mechanism for SGLT2 inhibitor-associated <abbr title=\"diabetic ketoacidosis\">DKA</abbr> has not been established. We are investigating this concern along with other EU medicines regulators. We will communicate further advice as appropriate once the investigation is complete.</p>\n\n<h2 id=\"sglt2-inhibitors--medicines-in-this-class\">SGLT2 inhibitors – medicines in this class</h2>\n<p>The SGLT2 inhibitors marketed in the UK are listed below. Click on the brand name to see the summary of product characteristics (<abbr title=\"summary of product characteristics\">SPC</abbr>). </p>\n\n<table>\n  <thead>\n    <tr>\n      <th>Brand name</th>\n      <th>Active substance(s)</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><a rel=\"external\" href=\"https://www.medicines.org.uk/emc/medicine/27188\">Forxiga</a>▼</td>\n      <td>Dapagliflozin tablets (5 mg and 10 mg)</td>\n    </tr>\n    <tr>\n      <td><a rel=\"external\" href=\"https://www.medicines.org.uk/emc/medicine/28667\">Xigduo</a>▼</td>\n      <td>Dapagliflozin/metformin tablets (5 mg/850 mg and 5 mg/1000 mg)</td>\n    </tr>\n    <tr>\n      <td><a rel=\"external\" href=\"https://www.medicines.org.uk/emc/search/?q=canagliflozin&amp;dt=1\">Invokana</a>▼</td>\n      <td>Canagliflozin tablets (100 mg and 300 mg)</td>\n    </tr>\n    <tr>\n      <td><a rel=\"external\" href=\"https://www.medicines.org.uk/emc/search/?q=canagliflozin&amp;dt=1\">Vokanamet</a>▼</td>\n      <td>Canagliflozin/metformin tablets (50 mg/850 mg, 50 mg/1000 mg, 150mg/850mg, 150mg/1000mg)</td>\n    </tr>\n    <tr>\n      <td><a rel=\"external\" href=\"https://www.medicines.org.uk/emc/search/?q=Empagliflozin&amp;dt=1\">Jardiance</a>▼</td>\n      <td>Empagliflozin tablets (10 mg and 25 mg)</td>\n    </tr>\n  </tbody>\n</table>\n\n<h2 id=\"further-information\">Further information</h2>\n<p><a rel=\"external\" href=\"http://www.ema.europa.eu/ema/index.jsp?curl=pages/medicines/human/referrals/SGLT2_inhibitors/human_referral_prac_000052.jsp&amp;mid=WC0b01ac05805c516f\">European Medicines Agency announcement</a> June 2015</p>\n\n<p>Post-publication addition: <a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/559d1b6f40f0b6156400002f/SGLT2_inhibitors_DHPC_sent_July_2015.pdf\">letter sent to health professionals</a> in July 2015</p>\n\n<p>Article citation: Drug Safety Update Volume 8 issue 11 June 2015 1.</p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/drug-safety-update-image.jpg",
        "content_type": "application/jpeg",
        "title": "drug safety update img title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/drug-safety-update-pdf.pdf",
        "content_type": "application/pdf",
        "title": "drug safety update pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "therapeutic_area": [
        "endocrinology-diabetology-metabolism"
      ],
      "document_type": "drug_safety_update"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Reports of diabetic acidosis",
        "level": 2,
        "id": "reports-of-diabetic-acidosis"
      },
      {
        "text": "SGLT2 inhibitors – medicines in this class",
        "level": 2,
        "id": "sglt2-inhibitors--medicines-in-this-class"
      },
      {
        "text": "Further information",
        "level": 2,
        "id": "further-information"
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-06-26T10:20:12+00:00"
      }
    ]
  },
  "base_path": "/drug-safety-update/sglt2-inhibitors-canagliflozin-dapagliflozin-empagliflozin-risk-of-diabetic-ketoacidosis",
  "description": "Test for raised ketones in patients with acidosis symptoms, even if plasma glucose levels are near-normal.",
  "title": "SGLT2 inhibitors (canagliflozin, dapagliflozin, empagliflozin): risk of diabetic ketoacidosis",
  "public_updated_at": "2015-07-08T14:08:17+00:00",
  "schema_name": "specialist_document",
  "document_type": "drug_safety_update",
  "links": {
  }
}

```

### employment-appeal-tribunal-decision.json
```json
{
  "content_id": "3917cb0e-0928-45b7-bf63-20f9bc113a7a",
  "base_path": "/employment-appeal-tribunal-decisions/ukeat-0144-15-la",
  "title": "UKEAT/0144/15/LA",
  "description": "Discrimination on grounds of race - Subjecting an employee to a detriment",
  "format": "specialist_document",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-10-29T15:50:37.477Z",
  "public_updated_at": "2015-10-29T15:50:37.000+00:00",
  "details": {
    "metadata": {
      "bulk_published": false,
      "document_type": "employment_appeal_tribunal_decision",
      "hidden_indexable_content": "Appeal No. UKEAT/0144/15/LA\\n\tAt the Tribunal\n\tOn 7 October 2015\n\tJudgment handed down on 27 October 2015",
      "tribunal_decision_categories": [
        "race-discrimination"
      ],
      "tribunal_decision_decision_date": "2015-10-27",
      "tribunal_decision_landmark": "not-landmark",
      "tribunal_decision_sub_categories": [
        "race-discrimination-detriment",
        "race-discrimination-direct"
      ]
    },
    "max_cache_time": 10,
    "change_history": [
      {
        "public_timestamp": "2015-10-29T15:50:37+00:00",
        "note": "First published."
      }
    ],
    "body": "<p>Download PDF: <a rel=\"external\" href=\"http://assets-origin.dev.gov.uk/media/56324037759b742c00000001/15_0144rjfhMDLA.doc\">UKEAT/0144/15/LA</a></p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/employment-appeal-tribunal-decision-image.jpg",
        "content_type": "application/jpeg",
        "title": "employment appeal tribunal decision image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/employment-appeal-tribunal-decision-pdf.pdf",
        "content_type": "application/pdf",
        "title": "employment appeal tribunal decision pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ]
  },
  "links": {
    "available_translations": [
      {
        "content_id": "3917cb0e-0928-45b7-bf63-20f9bc113a7a",
        "title": "UKEAT/0144/15/LA",
        "base_path": "/employment-appeal-tribunal-decisions/ukeat-0144-15-la",
        "description": "Discrimination on grounds of race - Subjecting an employee to a detriment",
        "api_url": "http://content-store.dev.gov.uk/content/employment-appeal-tribunal-decisions/ukeat-0144-15-la",
        "web_url": "http://www.dev.gov.uk/employment-appeal-tribunal-decisions/ukeat-0144-15-la",
        "locale": "en"
      }
    ]
  },
  "schema_name": "specialist_document",
  "document_type": "employment_appeal_tribunal_decision"
}

```

### employment-tribunal-decision.json
```json
{
  "content_id": "a66a167f-081b-4b0c-bd8e-3bb1242507df",
  "base_path": "/employment-tribunal-decisions/retained-firefighters-case-management-order-of-employment-tribunal-of-19-december-2008",
  "title": "Retained Firefighters:Case Management Order of Employment Tribunal of 19 December 2008",
  "description": "This Case Management Discussion concerns the large number of claims brought by retained fire-fighters, principally in 1994 and 1995, complaining that their exclusion from the pension scheme.",
  "format": "specialist_document",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-10-15T14:26:18.717Z",
  "public_updated_at": "2015-10-15T14:26:18.000+00:00",
  "details": {
    "metadata": {
      "hidden_indexable_content": "The stay was extended pending the determination of proceedings commenced in 2000/2001 under the Part-time Workers (Prevention of Less Favourable Treatment) Regulations 2000, known as the Matthews -v- Kent & Medway Fire Authority litigation.",
      "tribunal_decision_categories": [
        "age-discrimination",
        "agency-workers"
      ],
      "tribunal_decision_country": "england-and-wales",
      "tribunal_decision_decision_date": "2008-12-19",
      "bulk_published": false,
      "document_type": "employment_tribunal_decision"
    },
    "max_cache_time": 10,
    "change_history": [
      {
        "public_timestamp": "2015-10-15T12:00:37+00:00",
        "note": "First published."
      }
    ],
    "body": "<p>Download PDF: </p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/employment-tribunal-decision-image.jpg",
        "content_type": "application/jpeg",
        "title": "employment tribunal decision image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/employment-tribunal-decision-pdf.pdf",
        "content_type": "application/pdf",
        "title": "employment tribunal decision image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ]
  },
  "links": {
    "available_translations": [
      {
        "content_id": "a66a167f-081b-4b0c-bd8e-3bb1242507df",
        "title": "Retained Firefighters:Case Management Order of Employment Tribunal of 19 December 2008",
        "base_path": "/employment-tribunal-decisions/retained-firefighters-case-management-order-of-employment-tribunal-of-19-december-2008",
        "description": "This Case Management Discussion concerns the large number of claims brought by retained fire-fighters, principally in 1994 and 1995, complaining that their exclusion from the pension scheme.",
        "api_url": "http://content-store.dev.gov.uk/content/employment-tribunal-decisions/retained-firefighters-case-management-order-of-employment-tribunal-of-19-december-2008",
        "web_url": "http://www.dev.gov.uk/employment-tribunal-decisions/retained-firefighters-case-management-order-of-employment-tribunal-of-19-december-2008",
        "locale": "en"
      }
    ]
  },
  "schema_name": "specialist_document",
  "document_type": "employment_tribunal_decision"
}

```

### european-structural-investment-funds.json
```json
{
  "content_id": "2f1560bf-8b24-48c5-a9b4-3e29d27d3e48",
  "format": "specialist_document",
  "locale": "en",
  "details": {
    "body": "\n<div class=\"call-to-action\">\n<p>This call is now closed.  Please do not submit an application for this call.  The information provided on this page is for reference purposes only.</p>\n</div>\n\n<h2 id=\"important-notice-for-this-call\">Important Notice for this Call</h2>\n\n<p>The process for applying under this call outlined below is the normal route to apply for funding. However we are aware that some users have been having issues with the IT system LOGASnet. A Word version of the application form is available <a href=\"https://www.gov.uk/government/publications/european-structural-and-investment-funds-project-requirements-and-publicity-materials\">here</a>. If you are unable to submit your application on the IT system we will accept a Word version as a temporary measure for this specific call. This must be submitted to the email address in Section 6 in the call specification by the deadline specified in the call. Applications submitted after this deadline cannot be accepted. Applicants will still be expected to submit an application using the IT system and should do so as soon as they can access the IT system.</p>\n\n<h2 id=\"details\">Details</h2>\n\n<p>One of the investment priorities for the ESF in 2014-2020 is to promote the sustainable integration into the labour market of young people, in particular those who are not in education, employment or training (NEET). This will be reinforced by the Youth Employment Initiative (YEI). This call is inviting proposals to deliver Personalised Education, Employment and Enterprise Pathways – for young people who are NEET (15-29) across the Tees Valley LEP area.\nFor more information, download the <a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/55269f1ee5274a1418000019/YEI-Tees-Valley-PEEPS-ref-_OC34S15P_0110.pdf\">call specification.</a></p>\n\n<h2 id=\"location\">Location</h2>\n\n<p>For the Youth Employment Initiative the project must cover all of the Tees Valley Local Enterprise Partnership area.</p>\n\n<h2 id=\"value\">Value</h2>\n\n<p>Funding available for all YEI calls in Tees Valley: up to £21,800,000 (including the YEI allocation).</p>\n\n<h2 id=\"deadlines\">Deadlines</h2>\n\n<p>Outline application deadline: 29 May 2015 </p>\n\n<h2 id=\"completion-date\">Completion date</h2>\n\n<p>The project must be completed no later than 31 July 2018. </p>\n\n<h2 id=\"how-to-apply\">How to apply</h2>\n\n<h3 id=\"step-one-register\">Step one: register</h3>\n\n<p>Register by sending an email to <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#101;&#115;&#105;&#102;&#049;&#052;&#050;&#048;&#046;&#073;&#084;&#113;&#117;&#101;&#114;&#105;&#101;&#115;&#064;&#099;&#111;&#109;&#109;&#117;&#110;&#105;&#116;&#105;&#101;&#115;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#101;&#115;&#105;&#102;&#049;&#052;&#050;&#048;&#046;&#073;&#084;&#113;&#117;&#101;&#114;&#105;&#101;&#115;&#064;&#099;&#111;&#109;&#109;&#117;&#110;&#105;&#116;&#105;&#101;&#115;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a>.</p>\n\n<p>Put ‘Register to apply for ESIF’ in the subject line.</p>\n\n<p>In the email, include:\n* your full name \n* full name of your organisation\n* email address \n* phone number (including extension)\nIf you’re already registered, you can make your <a rel=\"external\" href=\"https://logasnet.communities.gov.uk/logasnet\">outline application</a> right away.</p>\n\n<h3 id=\"step-two-make-an-outline-application\">Step two: make an outline application</h3>\n\n<p>We’ll register you on our system within 10 working days. Then we’ll contact you and tell you how to make your outline application.</p>\n\n<p>You can start preparing your application while you wait. Download the <a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/5513d9cce5274a142b000045/Outline-Application-Form-and-Guidance-LOGASnet-050515.pdf\">Instructions on how to apply</a>.</p>\n\n<p>You are also advised to read details on the <a href=\"https://www.gov.uk/government/publications/european-structural-and-investment-funds-assessment-documents\">selection and assessment</a> of projects and the <a href=\"https://www.gov.uk/government/publications/european-structural-and-investment-funds-project-requirements-and-publicity-materials\">guidance and requirements</a> on key areas of the funds that a successful applicant will need to comply with.</p>\n\n<p>The latest draft version of the <a href=\"https://www.gov.uk/government/publications/european-social-fund-draft-operational-programme-2014-to-2020\">European Social Fund operational programme</a> is also available to refer to.</p>\n\n<h2 id=\"what-happens-next\">What happens next</h2>\n\n<p>If your outline application is successful, we’ll contact you and ask you to make a full application.</p>\n\n<h2 id=\"contact-details\">Contact details</h2>\n\n<p>If you have a question, contact <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#069;&#083;&#070;&#046;&#050;&#048;&#049;&#052;&#045;&#050;&#048;&#050;&#048;&#064;&#100;&#119;&#112;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;\">&#069;&#083;&#070;&#046;&#050;&#048;&#049;&#052;&#045;&#050;&#048;&#050;&#048;&#064;&#100;&#119;&#112;&#046;&#103;&#115;&#105;&#046;&#103;&#111;&#118;&#046;&#117;&#107;</a></p>\n\n<p>Call reference number: OC34S15P0110</p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/european-structural-investment-funds-image.jpg",
        "content_type": "application/jpeg",
        "title": "employment structural investment funds image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/european-structural-investment-funds-pdf.pdf",
        "content_type": "application/pdf",
        "title": "employment appeal tribunal decision pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "fund_state": "closed",
      "fund_type": [
        "access-to-work"
      ],
      "location": [
        "north-east"
      ],
      "funding_source": [
        "european-social-fund"
      ],
      "closing_date": "2015-05-29",
      "document_type": "esi_fund"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Important Notice for this Call",
        "level": 2,
        "id": "important-notice-for-this-call"
      },
      {
        "text": "Details",
        "level": 2,
        "id": "details"
      },
      {
        "text": "Location",
        "level": 2,
        "id": "location"
      },
      {
        "text": "Value",
        "level": 2,
        "id": "value"
      },
      {
        "text": "Deadlines",
        "level": 2,
        "id": "deadlines"
      },
      {
        "text": "Completion date",
        "level": 2,
        "id": "completion-date"
      },
      {
        "text": "How to apply",
        "level": 2,
        "id": "how-to-apply",
        "headers": [
          {
            "text": "Step one: register",
            "level": 3,
            "id": "step-one-register"
          },
          {
            "text": "Step two: make an outline application",
            "level": 3,
            "id": "step-two-make-an-outline-application"
          }
        ]
      },
      {
        "text": "What happens next",
        "level": 2,
        "id": "what-happens-next"
      },
      {
        "text": "Contact details",
        "level": 2,
        "id": "contact-details"
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-04-09T15:56:34+00:00"
      },
      {
        "note": "First published.",
        "public_timestamp": "2015-04-13T09:29:16+00:00"
      },
      {
        "note": "Instructions on how to apply revised.",
        "public_timestamp": "2015-04-20T15:38:22+00:00"
      },
      {
        "note": "Notice regarding outline application format added to call homepage.",
        "public_timestamp": "2015-05-14T11:45:59+00:00"
      },
      {
        "note": "Call closed for Tees Valley",
        "public_timestamp": "2015-06-01T08:26:26+00:00"
      }
    ]
  },
  "base_path": "/european-structural-investment-funds/access-to-employment-tees-valley",
  "description": "To deliver Personalised Education, Employment and Enterprise Pathways – for young people who are NEET (15-29) across the Tees Valley LEP area.",
  "title": "CLOSED Access to employment: Tees Valley",
  "public_updated_at": "2015-06-01T08:26:26+00:00",
  "schema_name": "specialist_document",
  "document_type": "esi_fund",
  "links": {
  }
}

```

### international-development-funding.json
```json
{
  "content_id": "7cf2bfcb-8711-4cf4-951e-a27efb04a231",
  "format": "specialist_document",
  "locale": "en",
  "details": {
    "body": "\n<div class=\"call-to-action\">\n<p>Deadline for submission of concept notes is 3pm UK time on 13 July 2015.</p>\n</div>\n\n<h2 id=\"overview\">Overview</h2>\n<p>The <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> grants are intended to support activities globally, in timber producing, processing and consumer countries and regions. An anticipated £30m of <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Grants will be awarded to between 15 and 25 grantees for 30 months from 1 October 2015 to 31 March 2018, there is a 3 stage process: </p>\n\n<ul>\n  <li>Concept Note window 22 June to 13 July 2015 </li>\n  <li>Proposal window 30 July to 20 August 2015 </li>\n  <li>due diligence and contracting August to September 2015</li>\n</ul>\n\n<h2 id=\"what-the-fund-will-achieve\">What the fund will achieve</h2>\n<p><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> aims to bring about governance and market reforms that reduce the illegal use of forest resources and benefit poor people who depend on forests for their livelihoods. As part of global efforts to improve forest management and tackle deforestation the <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> supports the EU Forest Law Enforcement, Governance and Trade (<abbr title=\"EU Forest Law Enforcement, Governance and Trade\">FLEGT</abbr>) Action Plan, in particular by tackling illegal logging in timber-producing developing countries and the trade in illegally-produced timber products. It also seeks to apply lessons from the timber trade to trade in other commodities that impact forests and people who depend on forests for their livelihoods. </p>\n\n<p><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> grants will further the objectives of the overall <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> programme by supporting not-for-profit organisations working on these issues</p>\n\n<h2 id=\"how-to-apply\">How to apply</h2>\n<p>Links to the Concept Note form and guidance are provided below. The deadline for submission of concept notes is 3pm UK time on 13 July 2015. </p>\n\n<h2 id=\"countries\">Countries</h2>\n<p><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> has supported governance related activities in over 20 timber producing and processing countries, with a particular focus on countries where the UK is the lead EU Member State supporting the <abbr title=\"EU Forest Law Enforcement, Governance and Trade\">FLEGT</abbr> process (Ghana, Guyana, Indonesia, Liberia and Myanmar) and other UK-supported countries (Cameroon, Central African Republic, Cote d’Ivoire, Democratic Republic of Congo, Republic of Congo and Vietnam). In addition <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> also supports work in processor countries (China) and in EU and other global policy arenas.  </p>\n\n<h2 id=\"background-information-on-the-fund\">Background information on the fund</h2>\n<p>Over the 10-year period 2011-2021, <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> has a total budget of up to £250 million funded from the UK International Climate Fund (<abbr title=\"International Climate Fund\">ICF</abbr>). For the period from April 2015 to March 2018 the project has a budget of £84 million, which will be allocated primarily through accountable grants, service contracts and Memoranda of Understanding. </p>\n\n<p><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> has supported governance–related activities in over 20 timber producing and processing countries, with a particular focus on countries where the UK is the lead EU Member State supporting the <abbr title=\"EU Forest Law Enforcement, Governance and Trade\">FLEGT</abbr> process (Ghana, Guyana, Indonesia, Liberia and Myanmar) and other UK-supported countries  (Cameroon, Central African Republic, Cote d’Ivoire, Democratic Republic of Congo, Republic of Congo and Vietnam). In addition <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> also supports work in processor countries (China) and in EU and other global policy arenas. </p>\n\n<p><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> grants issued in previous rounds included activities that: enhanced advocacy and voice; built capacity for CSO, Private sector federations and Government, provided research and evidence for policy development, legal reform and forest rights; supported enforcement, improved justice, transparency, monitoring and whistle-blowing; and maintained a global ‘community of practice’ around illegal logging and associated governance issues.</p>\n\n<h2 id=\"contacts\">Contacts</h2>\n<p>DFID has appointed an independent Programme Management Support Team (<abbr title=\"Programme Management Support Team\">PMST</abbr>) to provide programme management support to the delivery of <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr>. For further information on the <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> 2015 Grants Round or on the <abbr title=\"Programme Management Support Team\">PMST</abbr>, please contact the <abbr title=\"Programme Management Support Team\">PMST</abbr> at <a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#102;&#103;&#109;&#099;&#045;&#103;&#114;&#097;&#110;&#116;&#115;&#064;&#107;&#112;&#109;&#103;&#046;&#099;&#111;&#109;\">&#102;&#103;&#109;&#099;&#045;&#103;&#114;&#097;&#110;&#116;&#115;&#064;&#107;&#112;&#109;&#103;&#046;&#099;&#111;&#109;</a>. </p>\n\n<h2 id=\"project-documents\">Project documents</h2>\n\n<ul>\n  <li><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/5587cb5640f0b615b6000018/concept-note-guidance1.pdf\">Concept note guidance</a></li>\n  <li><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/5588193b40f0b615b3000012/Concept-Note-Form-June2015.docx\">Concept Note form</a></li>\n  <li><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/55928c92ed915d159500000b/question-and-answer-presentation.pdf\">Question and answer presentation</a></li>\n  <li><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/55928cc9ed915d159500000d/frequently-asked-questions.pdf\">Frequently asked questions</a></li>\n</ul>\n\n<h2 id=\"other-links\">Other links</h2>\n\n<ul>\n  <li><a rel=\"external\" href=\"http://iati.dfid.gov.uk/iati_documents/3718415.odt\"><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Business Case (2011-2015)</a> </li>\n  <li><a rel=\"external\" href=\"http://iati.dfid.gov.uk/iati_documents/4722820.odt\"><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Business Case Addendum (2015-2018)</a> </li>\n  <li><a rel=\"external\" href=\"http://iati.dfid.gov.uk/iati_documents/4445967.xlsx\"><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Logframe</a> </li>\n  <li><a rel=\"external\" href=\"http://iati.dfid.gov.uk/iati_documents/3771832.odt\"><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Annual Report 2012</a>   </li>\n  <li><a rel=\"external\" href=\"http://iati.dfid.gov.uk/iati_documents/4258331.odt\"><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Annual Report 2013</a> </li>\n  <li><a rel=\"external\" href=\"http://iati.dfid.gov.uk/iati_documents/4615501.odt\"><abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr> Annual Report 2014</a> </li>\n  <li><a rel=\"external\" href=\"http://devtracker.dfid.gov.uk/projects/GB-1-201724/\">Development Tracker - <abbr title=\"Forest Governance, Markets and Climate\">FGMC</abbr></a> </li>\n  <li><a rel=\"external\" href=\"http://www.fao.org/forestry/33093-04ee4b3cc7232ef705169b9cc20c30850.pdf\">EU <abbr title=\"EU Forest Law Enforcement, Governance and Trade\">FLEGT</abbr> Action Plan</a></li>\n  <li><a href=\"https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/253889/using-revised-logical-framework-external.pdf\">DFID Logframe How To Note</a></li>\n  <li><a rel=\"external\" href=\"http://www.theoryofchange.org/pdf/DFID_ToC_Review_VogelV7.pdf\">DFID Review of the use of &lsquo;Theory of Change&rsquo; in international development (DFID 2012)</a></li>\n  <li><a rel=\"external\" href=\"http://www.euflegt.efi.int/home\">EU <abbr title=\"Food and Agriculture organization of the United Nations\">FAO</abbr> <abbr title=\"EU Forest Law Enforcement, Governance and Trade\">FLEGT</abbr> facility website</a></li>\n  <li><a rel=\"external\" href=\"http://www.fao.org/forestry/eu-flegt/en/\"><abbr title=\"Food and Agriculture organization of the United Nations\">FAO</abbr> <abbr title=\"EU Forest Law Enforcement, Governance and Trade\">FLEGT</abbr> Programme Website</a></li>\n</ul>\n\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/international-development-funding-image.jpg",
        "content_type": "application/jpeg",
        "title": "international development image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/international-development-funding-pdf.pdf",
        "content_type": "application/pdf",
        "title": "international development pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "fund_state": "open",
      "location": [

      ],
      "development_sector": [
        "agriculture",
        "climate-change",
        "empowerment-and-accountability",
        "environment",
        "livelihoods",
        "private-sector-business",
        "trade"
      ],
      "eligible_entities": [
        "non-governmental-organisations",
        "uk-based-non-profit-organisations"
      ],
      "value_of_funding": [
        "500001-to-1000000",
        "more-than-1000000"
      ],
      "document_type": "international_development_fund"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Overview",
        "level": 2,
        "id": "overview"
      },
      {
        "text": "What the fund will achieve",
        "level": 2,
        "id": "what-the-fund-will-achieve"
      },
      {
        "text": "How to apply",
        "level": 2,
        "id": "how-to-apply"
      },
      {
        "text": "Countries",
        "level": 2,
        "id": "countries"
      },
      {
        "text": "Background information on the fund",
        "level": 2,
        "id": "background-information-on-the-fund"
      },
      {
        "text": "Contacts",
        "level": 2,
        "id": "contacts"
      },
      {
        "text": "Project documents",
        "level": 2,
        "id": "project-documents"
      },
      {
        "text": "Other links",
        "level": 2,
        "id": "other-links"
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-06-19T14:31:52+00:00"
      },
      {
        "note": "Concept Note Guidance and Concept Note form added",
        "public_timestamp": "2015-06-22T14:20:15+00:00"
      },
      {
        "note": "Frequently asked questions and question and answer presentation documents added ",
        "public_timestamp": "2015-06-30T12:37:01+00:00"
      }
    ]
  },
  "base_path": "/international-development-funding/forest-governance-markets-and-climate-2015-grants-round",
  "description": "FGMC will provide a new round of grants for projects that support governance and market reforms that reduce the illegal use of forest resources and benefit poor people.",
  "title": "Forest Governance, Markets and Climate 2015 Grants Round",
  "public_updated_at": "2015-07-09T12:00:46+00:00",
  "schema_name": "specialist_document",
  "document_type": "international_development_fund",
  "links": {
  }
}

```

### maib-reports.json
```json
{
  "content_id": "10089df0-4c3d-4779-b6e3-174daa6e1cbc",
  "format": "specialist_document",
  "locale": "en",
  "details": {
    "body": "<h2 id=\"accident-investigation-report-162015\">Accident Investigation Report 16/2015</h2>\n\n<p>Investigation report into marine accident including what happened, safety lessons and recommendations made:</p>\n\n<p><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/559d3c62ed915d1592000032/MAIBInvReport-16_2015.pdf\">MAIB investigation report 16-2015: Orakai and Margriet</a></p>\n\n<p><img src=\"https://assets.digital.cabinet-office.gov.uk/media/559e273840f0b6156400003b/Margriet.jpg\" alt=\"Photograph of Margriet\" /></p>\n\n<h3 id=\"summary\">Summary</h3>\n\n<p>At 0533 on 21 December 2014, the chemical tanker Orakai and the beam trawler Margriet collided in the North Sea, 45nm west of Ijmuiden. Margriet was seriously damaged both above and below the waterline. Approximately 8 tons of diesel oil escaped from a damaged fuel tank. Orakai sustained minor damage. There were no injuries.</p>\n\n<p>The investigation identified that Margriet’s wheelhouse watchkeeper was not keeping an effective lookout. He had not seen the tanker, which was only 1 nautical mile away when he altered course towards it. The investigation also identified that Orakai’s officer of the watch had left an inexperienced ordinary seaman alone on the bridge. </p>\n\n<h3 id=\"recommendations\">Recommendations</h3>\n\n<p>MAIB has made recommendation 2015/140\tto Margriet’s owner, Kafish B.V. aimed at improving the standards of watchkeeping on its vessels, with particular regard to the additional risks associated with fishing in or near traffic separation schemes and other areas of potential high traffic density.</p>\n\n<p>Recommendation 2015/141 has been made to Orakai’s manager, South End Tanker Management B.V., to reiterate to its fleet that an officer of the watch should not leave the bridge unless relieved by another qualified officer.</p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/maib-reports-image.jpg",
        "content_type": "application/jpeg",
        "title": "maib reports image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/maib-reports-pdf.pdf",
        "content_type": "application/pdf",
        "title": "maib reports pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "vessel_type": [
        "merchant-vessel-100-gross-tons-or-over",
        "fishing-vessel"
      ],
      "report_type": "investigation-report",
      "date_of_occurrence": "2014-12-21",
      "document_type": "maib_report"
    },
    "max_cache_time": 10,
    "headers": [
      {
        "text": "Accident Investigation Report 16/2015",
        "level": 2,
        "id": "accident-investigation-report-162015",
        "headers": [
          {
            "text": "Summary",
            "level": 3,
            "id": "summary"
          },
          {
            "text": "Recommendations",
            "level": 3,
            "id": "recommendations"
          }
        ]
      }
    ],
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-07-09T07:48:50+00:00"
      }
    ]
  },
  "base_path": "/maib-reports/collision-between-chemical-tanker-orakai-and-beam-trawler-margriet",
  "description": "Location: North Hinder Junction, North Sea, UK",
  "title": "Collision between chemical tanker Orakai and beam trawler Margriet",
  "public_updated_at": "2015-07-09T09:13:18+00:00",
  "schema_name": "specialist_document",
  "document_type": "maib_report",
  "links": {
  }
}

```

### raib-reports.json
```json
{
  "content_id": "8b75627d-7c41-40fb-8c74-978e12dc920f",
  "format": "specialist_document",
  "locale": "en",
  "base_path": "/raib-reports/train-driver-receiving-a-severe-electric-shock-at-sutton-weaver",
  "title": "Train driver receiving a severe electric shock at Sutton Weaver",
  "description": "At 19:04 hrs on Tuesday 23 September 2014, a train driver received a severe electric shock at Sutton Weaver, Cheshire. ",
  "details": {
    "body": "<p>The train driver had stopped his train having seen damaged overhead power supply wires ahead of it. Following a call to the signaller, he left his train and came close to, or made contact with, an electrically live wire which had broken and was low hanging. The train driver suffered serious injuries.</p>\n\n<p>This accident occurred because one of the overhead wires had broken, was hanging down and was electrically live. Two previous trains had come into contact with this hanging wire and consequently tripped the power supply circuit breakers. Each time the circuit breakers had been reset by the Electrical Control Operators in accordance with procedures to make the overhead wires electrically live again. The driver had left the train to obtain information as to his location to assist in restoring train services as he was trained to do, but did not see the broken wire.</p>\n\n<p>The investigation found that the wire broke as some of its strands had fractured due to fatigue, likely initiated and progressed from a high stress area related to an attachment supporting the overhead wire.</p>\n\n<p>The RAIB has made two recommendations. One is for Network Rail to extend the scope of its detailed overhead line examinations to inspect for signs of wire damage at these attachment positions.</p>\n\n<p>The other recommendation is for RSSB, who are the custodian of the railway Rule Book, to review whether clarification is needed relating to the actions that train crew should take if they are required to leave a train where the OLE is known to be damaged and still live.</p>\n\n<p>Following a review of the actions of those involved in attending to the injured driver, one learning point has been made reminding train operators of the importance of contacting the signaller by the quickest means in emergency situations.</p>\n\n<p><a rel=\"external\" href=\"https://assets.digital.cabinet-office.gov.uk/media/558803de40f0b615b600001a/R072015_150624_Sutton_Weaver.pdf\">R072015_150624_Sutton_Weaver</a></p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/raib-reports-image.jpg",
        "content_type": "application/jpeg",
        "title": "raib-reports image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/raib-reports-pdf.pdf",
        "content_type": "application/pdf",
        "title": "raib-reports pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "metadata": {
      "bulk_published": false,
      "railway_type": [
        "heavy-rail"
      ],
      "report_type": "investigation-report",
      "date_of_occurrence": "2014-09-24",
      "document_type": "raib_report"
    },
    "max_cache_time": 10,
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2015-06-24T08:59:35+00:00"
      }
    ]
  },
  "public_updated_at": "2015-06-24T08:59:35+00:00",
  "schema_name": "specialist_document",
  "document_type": "raib_report",
  "links": {
  }
}

```

### tax-tribunal-decision.json
```json
{
  "content_id": "5ea90783-1a5b-4c0b-9c48-ce7ba478ee7b",
  "base_path": "/tax-and-chancery-tribunal-decisions/why-pay-more-for-cars-limited-v-the-commissioners-for-her-majesty-s-revenue-and-customs",
  "title": "Why Pay More For Cars Limited v The Commissioners For Her Majesty's Revenue And Customs",
  "description": "VALUE ADDED TAX - Edwards v Bairstow - jurisdiction of Upper Tribunal - appeal against refusal of claim for repayment of overpaid VAT",
  "format": "specialist_document",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-10-08T09:48:30.337Z",
  "public_updated_at": "2015-10-07T10:56:47.000+00:00",
  "details": {
    "metadata": {
      "bulk_published": false,
      "document_type": "tax_tribunal_decision",
      "tribunal_decision_category": "tax",
      "tribunal_decision_decision_date": "2015-09-08",
      "hidden_indexable_content": "whether FTT entitled not to find or infer that car dealer had accounted for VAT on bonuses paid by manufacturers to dealer on purchase of demonstrator and courtesy cars in claim periods - appeal dismissed"
    },
    "max_cache_time": 10,
    "change_history": [
      {
        "public_timestamp": "2015-10-07T10:54:48+00:00",
        "note": "Add attachment."
      }
    ],
    "body": "<p>Download decision as a PDF document: <a rel=\"external\" href=\"http://assets-origin.dev.gov.uk/media/5614f9f7759b74281e000001/Why-Pay-More-for-Cars-v-HMRC.pdf\">Why Pay More For Cars Limited v The Commissioners For Her Majesty&rsquo;s Revenue And Customs</a></p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/tax-tribunal-decision-image.jpg",
        "content_type": "application/jpeg",
        "title": "tax tribunal decision image title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/tax-tribunal-decision-pdf.pdf",
        "content_type": "application/pdf",
        "title": "tax tribunal decision pdf title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ]
  },
  "links": {
    "available_translations": [
      {
        "content_id": "5ea90783-1a5b-4c0b-9c48-ce7ba478ee7b",
        "title": "Why Pay More For Cars Limited v The Commissioners For Her Majesty's Revenue And Customs",
        "base_path": "/tax-and-chancery-tribunal-decisions/why-pay-more-for-cars-limited-v-the-commissioners-for-her-majesty-s-revenue-and-customs",
        "description": "VALUE ADDED TAX - Edwards v Bairstow - jurisdiction of Upper Tribunal - appeal against refusal of claim for repayment of overpaid VAT",
        "api_url": "http://content-store.dev.gov.uk/content/tax-and-chancery-tribunal-decisions/why-pay-more-for-cars-limited-v-the-commissioners-for-her-majesty-s-revenue-and-customs",
        "web_url": "http://www.dev.gov.uk/tax-and-chancery-tribunal-decisions/why-pay-more-for-cars-limited-v-the-commissioners-for-her-majesty-s-revenue-and-customs",
        "locale": "en"
      }
    ]
  },
  "schema_name": "specialist_document",
  "document_type": "tax_tribunal_decision"
}

```

### utaac-decision.json
```json
{
  "content_id": "3917cb0e-0928-45b7-bf63-20f9bc113a7b",
  "base_path": "/administrative-appeals-tribunal-decisions/example-utaac-decision",
  "title": "Example UTAAC Decision",
  "description": "Example text.",
  "format": "specialist_document",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2016-04-05T14:41:08.625Z",
  "public_updated_at": "2016-04-05T14:41:08.000+00:00",
  "details": {
    "metadata": {
      "hidden_indexable_content": "Example text.",
      "tribunal_decision_categories": [
        "benefits-for-children",
        "bereavement-and-death-benefits"
      ],
      "tribunal_decision_decision_date": "2015-08-30",
      "tribunal_decision_judges": [
        "angus-r"
      ],
      "tribunal_decision_sub_categories": [
        "benefits-for-children-benefit-increases-for-children",
        "bereavement-and-death-benefits-bereaved-parents-allowance"
      ],
      "bulk_published": false,
      "document_type": "utaac_decision"
    },
    "max_cache_time": 10,
    "change_history": [
      {
        "public_timestamp": "2016-04-05T14:41:08+00:00",
        "note": "First published."
      }
    ],
    "body": "<p>Example text.</p>\n"
  },
  "phase": "beta",
  "links": {
    "available_translations": [
      {
        "content_id": "3917cb0e-0928-45b7-bf63-20f9bc113a7c",
        "title": "Example UTAAC Decision",
        "base_path": "/administrative-appeals-tribunal-decisions/example-utaac-decision",
        "description": "Example text.",
        "api_url": "http://content-store.dev.gov.uk/content/administrative-appeals-tribunal-decisions/example-utaac-decision",
        "web_url": "http://www.dev.gov.uk/administrative-appeals-tribunal-decisions/example-utaac-decision",
        "locale": "en"
      }
    ]
  },
  "schema_name": "specialist_document",
  "document_type": "utaac_decision"
}

```



