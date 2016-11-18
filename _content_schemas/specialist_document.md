---
layout: content_schema
title: specialist_document
---

<!-- This file was automatically generated. DO NOT EDIT DIRECTLY. -->

## Details hash

What makes this schema special.

<table class='schema-table'><tr><td><strong>body</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>attachments</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>metadata</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>max_cache_time</strong> <code>integer</code></td> <td>The maximum length of time the content should be cached, in seconds.</td></tr>
<tr><td><strong>headers</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>temporary_update_type</strong> <code>boolean</code></td> <td>Indicates that the user should choose a new update type on the next save.</td></tr></table>



---

## Links

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/specialist_document/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>taxons</strong> </td> <td>Prototype-stage taxonomy label for this content item</td></tr>
<tr><td><strong>ordered_related_items</strong> </td> <td>Related items, can be any page on GOV.UK. Mostly used for mainstream content to power the sidebar. Ordering of the links is determined by the editor in Panopticon.</td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td>Powers the /browse section of the site. These are known as sections in some legacy apps.</td></tr>
<tr><td><strong>topics</strong> </td> <td>Powers the /topic section of the site. These are known as specialist sectors in some legacy apps.</td></tr>
<tr><td><strong>organisations</strong> </td> <td>All organisations linked to this content item. This should include lead organisations.</td></tr>
<tr><td><strong>parent</strong> </td> <td>The parent content item.</td></tr>
<tr><td><strong>policy_areas</strong> </td> <td>A largely deprecated tag currently only used to power email alerts.</td></tr></table>

---

## Frontend schema

This is the schema for the payload from the content-store.

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
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content received a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>taxons</strong> </td> <td></td></tr>
<tr><td><strong>ordered_related_items</strong> </td> <td></td></tr>
<tr><td><strong>mainstream_browse_pages</strong> </td> <td></td></tr>
<tr><td><strong>topics</strong> </td> <td></td></tr>
<tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>parent</strong> </td> <td></td></tr>
<tr><td><strong>policy_areas</strong> </td> <td></td></tr>
<tr><td><strong>available_translations</strong> </td> <td></td></tr>
<tr><td><strong>children</strong> </td> <td></td></tr>
<tr><td><strong>policies</strong> </td> <td></td></tr>
<tr><td><strong>document_collections</strong> </td> <td></td></tr>
<tr><td><strong>child_taxons</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td>Applications on GOV.UK only use lowercase letters and dashes</td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td>Applications on GOV.UK only use lowercase letters and dashes</td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>specialist_document</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---



## Full payload

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/specialist_document/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>change_note</strong> <code>["null", "string"]</code></td> <td></td></tr>
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
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content received a major or minor update.</td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td>Allowed values: <code>ar</code> or <code>az</code> or <code>be</code> or <code>bg</code> or <code>bn</code> or <code>cs</code> or <code>cy</code> or <code>de</code> or <code>dr</code> or <code>el</code> or <code>en</code> or <code>es</code> or <code>es-419</code> or <code>et</code> or <code>fa</code> or <code>fr</code> or <code>he</code> or <code>hi</code> or <code>hu</code> or <code>hy</code> or <code>id</code> or <code>it</code> or <code>ja</code> or <code>ka</code> or <code>ko</code> or <code>lt</code> or <code>lv</code> or <code>ms</code> or <code>pl</code> or <code>ps</code> or <code>pt</code> or <code>ro</code> or <code>ru</code> or <code>si</code> or <code>sk</code> or <code>so</code> or <code>sq</code> or <code>sr</code> or <code>sw</code> or <code>ta</code> or <code>th</code> or <code>tk</code> or <code>tr</code> or <code>uk</code> or <code>ur</code> or <code>uz</code> or <code>vi</code> or <code>zh</code> or <code>zh-hk</code> or <code>zh-tw</code></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>previous_version</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td>Applications on GOV.UK only use lowercase letters and dashes</td></tr>
<tr><td><strong>redirects</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td>Applications on GOV.UK only use lowercase letters and dashes</td></tr>
<tr><td><strong>routes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>specialist_document</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>
