---
layout: content_schema
title:  Contact
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/contact/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>slug</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>quick_links</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>query_response_time</strong> <code>["string", "boolean"]</code></td> <td></td></tr>
<tr><td><strong>contact_form_links</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_contact_form</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>contact_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>feature_on_homepage</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>email_addresses</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_email_address</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>phone_numbers</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_phone_number</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>post_addresses</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_post_address</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>language</strong> <code>string</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>locale</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>need_ids</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>phase</strong> <code>string</code></td> <td>Allowed values: <code>alpha</code> or <code>beta</code> or <code>live</code>The service design phase of this content item - https://www.gov.uk/service-manual/phases</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>redirects</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>rendering_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>routes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>contact</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/contact/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/contact/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>slug</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>quick_links</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>query_response_time</strong> <code>["string", "boolean"]</code></td> <td></td></tr>
<tr><td><strong>contact_form_links</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_contact_form</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>contact_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>feature_on_homepage</strong> <code>boolean</code></td> <td></td></tr>
<tr><td><strong>email_addresses</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_email_address</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>phone_numbers</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_phone_number</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>post_addresses</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>more_info_post_address</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>language</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>contact</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### contact.json
```json
{
  "base_path": "/government/organisations/hm-revenue-customs/contact/customs-excise-and-vat-fraud-reporting",
  "content_id": "6c50a476-5681-4808-974d-c8e80bcca90d",
  "title": "Customs, Excise and VAT fraud reporting",
  "format": "contact",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-12-02T10:42:56.350Z",
  "public_updated_at": "2015-09-30T09:11:00.300+00:00",
  "phase": "live",
  "analytics_identifier": "",
  "links": {
    "related": [
      {
        "content_id": "4e661905-fd41-453a-b953-6877bfa88b45",
        "title": "Fraud: report a benefit thief online ",
        "base_path": "/government/organisations/hm-revenue-customs/contact/report-a-benefit-thief-online",
        "description": "If you suspect someone of benefit fraud report them online here",
        "api_url": "https://www.gov.uk/api/content/government/organisations/hm-revenue-customs/contact/report-a-benefit-thief-online",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs/contact/report-a-benefit-thief-online",
        "locale": "en"
      },
      {
        "content_id": "e90e2f58-670d-4871-a5c8-71fd9c0b2a7b",
        "title": "Fraudulent emails",
        "base_path": "/government/organisations/hm-revenue-customs/contact/reporting-fraudulent-emails",
        "description": "Email address to use to report a fraudulent or phishing email that mentions HMRC",
        "api_url": "https://www.gov.uk/api/content/government/organisations/hm-revenue-customs/contact/reporting-fraudulent-emails",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs/contact/reporting-fraudulent-emails",
        "locale": "en"
      },
      {
        "content_id": "5a21285a-f386-4820-af81-e6d2a847b223",
        "title": "Tax evasion",
        "base_path": "/government/organisations/hm-revenue-customs/contact/reporting-tax-evasion",
        "description": "Use the online form, or call or write to HMRC to report someone not paying their fair share of tax",
        "api_url": "https://www.gov.uk/api/content/government/organisations/hm-revenue-customs/contact/reporting-tax-evasion",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs/contact/reporting-tax-evasion",
        "locale": "en"
      }
    ],
    "available_translations": [
      {
        "content_id": "6c50a476-5681-4808-974d-c8e80bcca90d",
        "title": "Customs, Excise and VAT fraud reporting",
        "base_path": "/government/organisations/hm-revenue-customs/contact/customs-excise-and-vat-fraud-reporting",
        "description": "Contact HMRC to report all types of smuggling, misuse of red diesel, customs, excise and VAT fraud",
        "api_url": "https://www.gov.uk/api/content/government/organisations/hm-revenue-customs/contact/customs-excise-and-vat-fraud-reporting",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs/contact/customs-excise-and-vat-fraud-reporting",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
        "title": "HM Revenue & Customs",
        "base_path": "/government/organisations/hm-revenue-customs",
        "api_url": "https://www.gov.uk/api/content/government/organisations/hm-revenue-customs",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs",
        "locale": "en"
      }
    ]
  },
  "description": "Contact HMRC to report all types of smuggling, misuse of red diesel, customs, excise and VAT fraud",
  "details": {
    "slug": "customs-excise-and-vat-fraud-reporting",
    "title": "Customs, Excise and VAT fraud reporting",
    "description": "Contact HMRC to report all types of smuggling, misuse of red diesel, customs, excise and VAT fraud",
    "quick_links": [
      {
        "title": "Report smuggling ",
        "url": "https://www.gov.uk/report-smuggling"
      },
      {
        "title": "Report VAT fraud",
        "url": "https://www.gov.uk/report-vat-fraud"
      }
    ],
    "query_response_time": false,
    "contact_form_links": [
      {
        "title": "Customs Hotline online form",
        "link": "https://online.hmrc.gov.uk/shortforms/form/CusConf_InformB?dept-name=Customs&sub-dept-name=Hotline&location=48&origin=http://www.hmrc.gov.uk",
        "description": "<p>Contact HMRC to report suspicious activity in relation to smuggling, customs, excise and VAT fraud.</p>\n"
      }
    ],
    "more_info_contact_form": "<p>If HMRC needs to contact you about anything confidential they’ll reply by phone or post.</p>\n",
    "email_addresses": [
      {
        "title": "Customs Hotline",
        "email": "customs.hotline@hmrc.gsi.gov.uk ",
        "description": "\n"
      }
    ],
    "more_info_email_address": "<p>If HMRC needs to contact you about anything confidential they’ll reply by phone or post.</p>\n",
    "phone_numbers": [
      {
        "title": "Customs Hotline",
        "number": "0800 595 000",
        "textphone": "",
        "international_phone": "",
        "fax": "0800 528 0506",
        "description": "<p>Call or fax HMRC to report suspicious activity in relation to smuggling, customs, excise and VAT fraud.</p>\n\n<p>This number does not deal with questions about taxes, duty, benefits or tax credits.</p>\n",
        "open_hours": "<p>24 hours a day, 7 days a week</p>\n",
        "best_time_to_call": "\n"
      },
      {
        "title": "Belgium, Denmark, France, Germany, Republic of Ireland, Netherlands",
        "number": "+800 555 95000",
        "textphone": "",
        "international_phone": "",
        "fax": "",
        "description": "\n",
        "open_hours": "\n",
        "best_time_to_call": "\n"
      },
      {
        "title": "Mainland Spain",
        "number": "900 988 922",
        "textphone": "",
        "international_phone": "",
        "fax": "",
        "description": "\n",
        "open_hours": "\n",
        "best_time_to_call": "\n"
      },
      {
        "title": "Any other country",
        "number": "+44 208 929 0153",
        "textphone": "",
        "international_phone": "",
        "fax": "",
        "description": "\n",
        "open_hours": "\n",
        "best_time_to_call": "\n"
      }
    ],
    "more_info_phone_number": "\n",
    "post_addresses": [
      {
        "title": "HM Revenue and Customs - Customs, Excise and VAT fraud reporting",
        "street_address": "Freepost NAT22785\r\n",
        "postal_code": "CF14 5GX",
        "world_location": "United Kingdom",
        "locality": "",
        "region": "CARDIFF",
        "description": "<p>Write to this address to report suspicious activity in relation to smuggling, customs, excise and VAT fraud.</p>\n"
      }
    ],
    "more_info_post_address": "\n",
    "language": "en"
  },
  "schema_name": "contact",
  "document_type": "contact"
}

```



