---
layout: content_schema
title:  Manual section
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/manual_section/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>attachments</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>manual</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>base_path</strong> </td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>manual_section</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/manual_section/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>organisations</strong> </td> <td>All organisations linked to this content item. This should include lead organisations.</td></tr>
<tr><td><strong>manual</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/manual_section/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>attachments</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>manual</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>base_path</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>organisations</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>organisations</strong> </td> <td></td></tr>
<tr><td><strong>manual</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>manual_section</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### what-is-content-design.json
```json
{
  "content_id": "66d565ea-1544-4410-85ff-2e411cdf78e6",
  "base_path": "/guidance/content-design/what-is-content-design",
  "title": "What is content design?",
  "description": "Introduction to content design.",
  "format": "manual_section",
  "need_ids": [],
  "locale": "en",
  "updated_at": "2015-04-27T12:54:39.815Z",
  "public_updated_at": "2015-04-24T10:26:26.000+00:00",
  "details": {
    "body": "<h2 id=\"designing-content-not-creating-copy\">Designing content, not creating copy</h2>\n\n<p>Good content design allows people to do or find out what they need to from government simply and quickly using the most appropriate content format available. It is based on research into GOV.UK user behaviour, analytics and feedback.</p>\n\n<p>Government has a tendency to publish content that is more focused on what it wants to say than what the user needs to know. This makes content difficult to understand and act on.</p>\n\n<p>This can result in frustrated users (citizens, businesspeople and even government experts) who can’t find the information they need or complete the tasks they come to GOV.UK for.\nWe can avoid this on GOV.UK by basing what we publish on research into user behaviour and what users actually need.</p>\n\n<h2 id=\"content-design-always-starts-with-user-needs\">Content design always starts with user needs</h2>\n\n<p>When we talk about content design we mean taking a user need and presenting it on GOV.UK in the best way possible. </p>\n\n<p>A user need is something that a user will need to do or find out from government and can include:</p>\n\n<ul>\n  <li>finding out who a <a href=\"/government/ministers\">new minister</a> is</li>\n  <li>working out whether they’re eligible to <a href=\"/browse/benefits\">claim a benefit</a></li>\n  <li>registering to <a href=\"/register-to-vote\">vote online</a></li>\n  <li>checking the <a href=\"/trade-tariff\">Trade Tariff</a> for the taxes due on goods they import</li>\n  <li>confirming that a client’s prospective merger is permitted under the current <a href=\"/government/collections/cma-mergers-guidance\">Competition and Markets Authority guidance</a></li>\n</ul>\n\n<p>There are currently over 40 content formats and tools on GOV.UK, all developed in response to the specific needs of different types of users. There can sometimes be more than one way to present content and the decisions have to be made carefully.</p>\n\n<p>Before publishing to GOV.UK, you need to know your users’ needs and design your content around them. For more detail on how to do this, read the section on <a href=\"/guidance/content-design/user-needs\">user needs</a>. </p>\n\n<h2 id=\"content-strategy-and-design\">Content strategy and design</h2>\n\n<p>Depending on what your user needs are, you may need to:  </p>\n\n<ul>\n  <li>reduce the amount of content you plan to publish  </li>\n  <li>split one big piece of content into smaller pieces  </li>\n  <li>change the format of the content  </li>\n  <li>put some content in the Mainstream area of the site </li>\n  <li>remove content from the site</li>\n  <li>request a new GOV.UK tool or format to meet the needs of your users</li>\n  <li>publish your content elsewhere, like a blog, partner site or social media</li>\n</ul>\n\n<p>You’ll need to consider all of this when <a href=\"/guidance/content-design/planning-content\">planning your content</a>. You will also need to consider how long the content will stay on GOV.UK and what will happen to it after it&rsquo;s out of date. If you need <a href=\"/guidance/contact-the-government-digital-service/request-a-thing#content-advice\">content design advice</a>, you can contact GDS via the <a rel=\"external\" href=\"https://support.production.alphagov.co.uk\">internal support form</a>.</p>\n\n<h2 id=\"designing-by-writing-great-content\">Designing by writing great content</h2>\n\n<p>Writing great content clearly, in plain English, and optimised for the web helps people understand and find the information they need quickly and easily. This guidance and the GOV.UK style guide are based on research about how people use the internet. They show how to <a href=\"/guidance/content-design/writing-for-gov-uk\">write great content</a>.</p>\n\n<p>As government, we must write so that GOV.UK is accessible to anybody who is interested enough to look. GOV.UK users have different reading abilities and check GOV.UK on a range of devices. Read <a href=\"/guidance/content-design/planning-content#accessibity\">how to design accessible content</a> on GOV.UK before you start.</p>\n\n<h2 id=\"designing-to-avoid-duplication\">Designing to avoid duplication</h2>\n\n<p>Content design also involves making sure content can be easily found on a site with over 100,000 content items (as of 2014).</p>\n\n<p>Duplicate content produces poor search results, confuses the user and damages the credibility of GOV.UK as a brand. Users end up using offline channels, like calling a helpline, because they aren&rsquo;t sure they have all the information or the right information.</p>\n\n<h2 id=\"content-maintenance\">Content maintenance</h2>\n\n<p>Good content design practice ensures that content on GOV.UK stays accurate, relevant, current and optimised both for users and search engines. When content no longer meets users’ needs or is out of date, it needs to be archived or removed from the site. The <a href=\"/guidance/content-design/content-maintenance\">section on content maintenance</a> looks at how to maintain and review content. </p>\n\n<h2 id=\"simpler-clearer-faster\">Simpler, clearer, faster</h2>\n\n<p>Applying all of these content design principles mean we do the hard work for the user. But the reward is a site that is simpler, clearer and faster for both government and citizens.</p>\n",
    "attachments": [
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/introduction-section-image.jpg",
        "content_type": "application/jpeg",
        "title": "introduction section title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      },
      {
        "url": "https://assets.digital.cabinet-office.gov.uk/media/513a0efbed915d425e000002/introduction-section-pdf.pdf",
        "content_type": "application/pdf",
        "title": "introduction section title",
        "created_at": "2015-02-11T13:45:00.000+00:00",
        "updated_at": "2015-02-13T13:45:00.000+00:00"
      }
    ],
    "manual": {
      "base_path": "/guidance/content-design"
    },
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
        "content_id": "66d565ea-1544-4410-85ff-2e411cdf78e6",
        "title": "What is content design?",
        "base_path": "/guidance/content-design/what-is-content-design",
        "api_url": "https://content-store.preview.alphagov.co.uk/content/guidance/content-design/what-is-content-design",
        "web_url": "https://www.preview.alphagov.co.uk/guidance/content-design/what-is-content-design",
        "locale": "en"
      }
    ]
  },
  "schema_name": "manual_section",
  "document_type": "manual_section"
}

```



