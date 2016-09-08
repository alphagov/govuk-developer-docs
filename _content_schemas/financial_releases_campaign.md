---
layout: content_schema
title:  Financial releases campaign
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/financial_releases_campaign/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alt_text</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>caption</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>header_legal_disclaimer</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>body</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>email_header</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>email_caption</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>footer_legal_disclaimer</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>pdf</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_id</strong> </td> <td></td></tr>
<tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>created_at</strong> </td> <td></td></tr>
<tr><td><strong>updated_at</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>financial_releases_campaign</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/financial_releases_campaign/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/financial_releases_campaign/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alt_text</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>caption</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>header_legal_disclaimer</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>email_header</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>email_caption</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>footer_legal_disclaimer</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>pdf</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>content_id</strong> </td> <td></td></tr>
<tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>created_at</strong> </td> <td></td></tr>
<tr><td><strong>updated_at</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>financial_releases_campaign</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### financial_releases_campaign.json
```json
{
  "content_id": "333e6c9d-aaf9-4f7d-98ce-3ce57a79802e",
  "base_path": "/lloydsshares",
  "title": "Financial releases campaign page",
  "description": "Campaign page for financial press releases",
  "locale": "en",
  "public_updated_at": "2015-12-07T11:22:21.000Z",
  "format": "financial_releases_campaign",
  "details": {
    "image": {
      "alt_text": "HM Government",
      "url": "campaign.large.jpg"
    },
    "header_legal_disclaimer": "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum <a href=\"/lloydsshares\">www.gov.uk/lloydsshares</a>.</p>\n",
    "body": "<p>Vis nostro intellegebat at. Impedit pericula duo ne, pri nonumes ullamcorper in. Oratio invidunt et his, ele, at principes similique nam. No eam eleifend euripidis intellegat, sensibus theophrastus consectetuer.\nSumo solum quaestio has cu. Eu oblique euismod deleniti eum, congue necessitatibus ne sit.\nNo eum mutat soleat definiebas, ut argumentum efficiantur delicatissimi ius. At feugait adversarium vel. At cum mutat numquam graecis. Sit appareat adolescens constituto eu, te eleifend postulant theophrastus eam\nIf you would like to receive email updates for daily ice cream flavours, send us a hand written note.\nVel ut iudico dolore. Vix ne diam iuvaret referrentur, eam nisl accusamus temporibus ne.If you like yoga <a href=\"/lloydsfactsheet\">click here</a>.</p>\n",
    "email_header": "<p>Register your interest in this share offer</p>\n",
    "email_caption": "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur, and will be destroyed at that point.</p>\n",
    "footer_legal_disclaimer": "<p>Legal disclaimer:</p>\n\n<p>The contents of this advertisement, which have been prepared by and are the sole responsibility of HM Treasury, have been approved by Barclays Bank PLC (Barclays) solely for the purposes of section 21(2)(b) of the FSMA. Barclays, whose registered office is 1 Churchill Place, London E14 5HP, is authorised by the Prudential Regulation Authority and regulated by the Prudential Regulation Authority and the Financial Conduct Authority. No reliance may be placed on Barclays for advice or recommendations with respect to the contents of this advertisement and, to the extent it may do so under applicable law, Barclays makes no representation or warranty to the persons viewing this advertisement with regards to the information contained herein.</p>\n\n<p><strong>This advertisement does not constitute an offer, invitation or recommendation concerning the securities referred to in this advertisement. The price and value of securities can go down as well as up, and so you could get back less than you invested. Past performance is not a guide to future performance. Information in this advertisement cannot be relied upon as a guide to future performance. Before purchasing any securities referred to in this advertisement, persons viewing this advertisement should make sure that they fully understand and accept the risks which are to be set out in the prospectus referred to above. Potential Investors should consult an independent financial adviser as to the suitability of the securities referred to in this advertisement to the person concerned</strong>.</p>\n"
  },
  "schema_name": "financial_releases_campaign",
  "document_type": "financial_releases_campaign",
  "links": {
  }
}

```



