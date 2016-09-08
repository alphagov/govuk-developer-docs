---
layout: content_schema
title:  Financial releases geoblocker
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/financial_releases_geoblocker/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>footer_legal_disclaimer</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>financial_releases_geoblocker</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/financial_releases_geoblocker/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/financial_releases_geoblocker/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>footer_legal_disclaimer</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>financial_releases_geoblocker</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### financial_releases_campaign_geoblocker.json
```json
{
  "base_path": "/lloydsshares/location",
  "content_id": "b636c3f1-3bdc-49eb-8edc-c9c053a3691d",
  "title": "Financial Releases geoblocker",
  "description": "The government will be making shares in Lloyds Banking Group available for sale to the general public.",
  "format": "financial_releases_geoblocker",
  "locale": "en",
  "public_updated_at": "2015-12-01T00:00:00.000Z",
  "details": {
    "body": "<h2 class='heading-medium'>Choose your country of residence</h2><p>The information in this advertisement is intended to be available only to persons located in the United Kingdom.</p><p>Select the country where you are located from the drop-down menu below. By clicking on the ‘Submit’ button you confirm that: (1) you are a person located only in the country you have selected from the drop-down menu and (2) you are not located in the United States of America.</p>",
    "footer_legal_disclaimer": "This notice and its content are not and should not be deemed to be an offer or invitation to engage in any investment activity. The securities have not been and will not be registered under the U.S. Securities Act of 1933 and may not be offered or sold in the U.S. absent registration or an exemption therefrom."
  },
  "schema_name": "financial_releases_geoblocker",
  "document_type": "financial_releases_geoblocker",
  "links": {
  }
}

```

### financial_releases_index_geoblocker.json
```json
{
  "base_path": "/lloydsshares/lloyds-share-offer-press-releases/location",
  "content_id": "9285e91b-afa0-4ccb-a4cb-65f98e093f58",
  "title": "Financial Releases geoblocker",
  "description": "The government will be making shares in Lloyds Banking Group available for sale to the general public.",
  "format": "financial_releases_geoblocker",
  "locale": "en",
  "public_updated_at": "2015-12-01T00:00:00.000Z",
  "details": {
    "body": "<h2 class='heading-medium'>Choose your country of residence</h2><p>The information in this advertisement is intended to be available only to persons located in the United Kingdom.</p><p>Select the country where you are located from the drop-down menu below. By clicking on the ‘Submit’ button you confirm that: (1) you are a person located only in the country you have selected from the drop-down menu and (2) you are not located in the United States of America.</p>",
    "footer_legal_disclaimer": "This notice and its content are not and should not be deemed to be an offer or invitation to engage in any investment activity. The securities have not been and will not be registered under the U.S. Securities Act of 1933 and may not be offered or sold in the U.S. absent registration or an exemption therefrom."
  },
  "schema_name": "financial_releases_geoblocker",
  "document_type": "financial_releases_geoblocker",
  "links": {
  }
}

```

### financial_releases_not_permitted.json
```json
{
  "content_id": "054e8890-8cba-47fd-ab3b-32fc7a3ca2b3",
  "base_path": "/location/not-permitted",
  "title": "Financial releases not permitted dummy title",
  "description": "Financial release dummy description",
  "format": "financial_releases_geoblocker",
  "locale": "en",
  "public_updated_at": "2015-12-02T17:11:23+01:00",
  "details": {
    "body": "<p>Dummy body content to explain why you are not permitted to view Lloyds campaign if you are not from the correct country"
  },
  "schema_name": "financial_releases_geoblocker",
  "document_type": "financial_releases_geoblocker",
  "links": {
  }
}

```

### financial_releases_press_release_geoblocker.json
```json
{
  "base_path": "/lloydsshares/lloyds-share-offer/location",
  "content_id": "f0905472-5696-475b-8b39-604e9b3b0a20",
  "title": "Financial Releases geoblocker",
  "description": "The government will be making shares in Lloyds Banking Group available for sale to the general public.",
  "format": "financial_releases_geoblocker",
  "locale": "en",
  "public_updated_at": "2015-12-01T00:00:00.000Z",
  "details": {
    "body": "<h2 class='heading-medium'>Choose your country of residence</h2><p>The information in this advertisement is intended to be available only to persons located in the United Kingdom.</p><p>Select the country where you are located from the drop-down menu below. By clicking on the ‘Submit’ button you confirm that: (1) you are a person located only in the country you have selected from the drop-down menu and (2) you are not located in the United States of America.</p>",
    "footer_legal_disclaimer": "This notice and its content are not and should not be deemed to be an offer or invitation to engage in any investment activity. The securities have not been and will not be registered under the U.S. Securities Act of 1933 and may not be offered or sold in the U.S. absent registration or an exemption therefrom."
  },
  "schema_name": "financial_releases_geoblocker",
  "document_type": "financial_releases_geoblocker",
  "links": {
  }
}

```



