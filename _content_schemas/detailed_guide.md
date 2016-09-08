---
layout: content_schema
title:  Detailed guide
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/detailed_guide/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>related_mainstream_content</strong> <code>array</code></td> <td>The ordered list of related and additional mainstream content item IDs. Use in conjunction with the (unordered) `related_mainstream_content` link.</td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alt_text</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>caption</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>alternative_scotland_url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alternative_wales_url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alternative_nothern_ireland_url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>national_applicability</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>england</strong> </td> <td></td></tr>
<tr><td><strong>northern_ireland</strong> </td> <td></td></tr>
<tr><td><strong>scotland</strong> </td> <td></td></tr>
<tr><td><strong>wales</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>detailed_guide</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/detailed_guide/publisher_v2/links.json)

<table class='schema-table'><tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>document_collections</strong> </td> <td></td></tr>
<tr><td><strong>related_guides</strong> </td> <td></td></tr>
<tr><td><strong>related_policies</strong> </td> <td></td></tr>
<tr><td><strong>related_mainstream</strong> </td> <td></td></tr>
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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/detailed_guide/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>body</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>related_mainstream_content</strong> <code>array</code></td> <td>The ordered list of related and additional mainstream content item IDs. Use in conjunction with the (unordered) `related_mainstream_content` link.</td></tr>
<tr><td><strong>first_public_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>image</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alt_text</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>caption</strong> <code>string</code> or <code>null</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>change_history</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>alternative_scotland_url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alternative_wales_url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>alternative_nothern_ireland_url</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>tags</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>browse_pages</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>topics</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>policies</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>government</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>title</strong> <code>string</code></td> <td>Name of the government that first published this document, eg '1970 to 1974 Conservative government'.</td></tr>
<tr><td><strong>slug</strong> <code>string</code></td> <td>Government slug, used for analytics, eg '1970-to-1974-conservative-government'.</td></tr>
<tr><td><strong>current</strong> <code>boolean</code></td> <td>Is the government that published this document still the current government.</td></tr></table></td></tr>
<tr><td><strong>political</strong> <code>boolean</code></td> <td>If the content is considered political in nature, reflecting views of the government it was published under.</td></tr>
<tr><td><strong>emphasised_organisations</strong> <code>array</code></td> <td>The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.</td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr>
<tr><td><strong>national_applicability</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>england</strong> </td> <td></td></tr>
<tr><td><strong>northern_ireland</strong> </td> <td></td></tr>
<tr><td><strong>scotland</strong> </td> <td></td></tr>
<tr><td><strong>wales</strong> </td> <td></td></tr></table></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>expanded_links</strong> <code>object</code></td> <td></td></tr>
<tr><td><strong>first_published_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>format</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>last_edited_at</strong> <code>string</code></td> <td>Last time when the content recieved a major or minor update.</td></tr>
<tr><td><strong>links</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>document_collections</strong> </td> <td></td></tr>
<tr><td><strong>related_guides</strong> </td> <td></td></tr>
<tr><td><strong>related_policies</strong> </td> <td></td></tr>
<tr><td><strong>related_mainstream</strong> </td> <td></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>detailed_guide</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### detailed_guide.json
```json
{
  "content_id": "c9e77115-22aa-45a2-8c0d-827d92462758",
  "base_path": "/guidance/salary-sacrifice-and-the-effects-on-paye",
  "description": "Find out how salary sacrifice arrangements work and how they might affect an employee's current and future income.",
  "public_updated_at": "2016-02-18T15:45:44.000+00:00",
  "title": "Salary sacrifice",
  "updated_at": "2016-02-18T10:37:00Z",
  "schema_name": "detailed_guide",
  "document_type": "detailed_guide",
  "format": "detailed_guide",
  "locale": "en",
  "details": {
    "body": "<div class=\"govspeak\">\n<h2 id=\"the-basics\">The basics</h2>\n\n<p>A salary sacrifice arrangement is an agreement between an employer and an employee to change the terms of the employment contract to reduce the employee’s entitlement to cash pay. This sacrifice of cash entitlement is usually made in return for some form of non-cash benefit.</p>\n\n<p>Salary sacrifice can be financially beneficial for both employer and employee. For example, when part of an employee’s remuneration shifts from cash - on which tax and National Insurance contributions (<abbr title=\"National Insurance contributions\">NICs</abbr>) are due - to non-cash benefits that are wholly or partially exempt.</p>\n\n<p>A salary sacrifice arrangement can’t reduce an employee’s cash earnings below the \n<a rel=\"external\" href=\"https://www.gov.uk/national-minimum-wage-rates\">National Minimum Wage rates</a>.</p>\n\n<h2 id=\"changing-the-terms-of-a-salary-sacrifice-arrangement\">Changing the terms of a salary sacrifice arrangement</h2>\n\n<p>If an employee wants to opt in or out of a salary sacrifice arrangement, employers must alter their contract with each change. The employee’s contract must be clear on what their cash and non-cash entitlements are at any given time.</p>\n\n<p>It may be necessary to change the terms of a salary sacrifice arrangement where a ‘lifestyle change’ significantly alters an employee’s financial circumstances. Examples include marriage, divorce, or an employee’s spouse or partner becoming redundant or pregnant. Salary sacrifice arrangements can allow opting in or out in the event of lifestyle changes like these.</p>\n\n<p>If an employee can swap between cash earnings and a non-cash benefit whenever they like, it’s not a salary sacrifice. In these circumstances, any expected tax and <abbr title=\"National Insurance contributions\">NICs</abbr> advantages under a salary sacrifice arrangement won’t apply.</p>\n\n<h2 id=\"tax-and-nics\">Tax and <abbr title=\"National Insurance contributions\">NICs</abbr>\n</h2>\n\n<p>The impact on tax and <abbr title=\"National Insurance contributions\">NICs</abbr> payable for any employee will depend on the pay and non-cash benefits that make up the salary sacrifice arrangement. An employer’s key responsibility is to make sure that they pay and deduct the right amount of tax and <abbr title=\"National Insurance contributions\">NICs</abbr> for the cash and benefits they provide.</p>\n\n<p>For the cash component, that means operating the PAYE system correctly through their payroll.</p>\n\n<p>For any non-cash benefits, it means checking the tax and <abbr title=\"National Insurance contributions\">NICs</abbr> rules that apply and implementing them correctly.</p>\n\n<h3 id=\"employers-reporting-requirements-for-non-cash-benefits\">Employers’ reporting requirements for non-cash benefits</h3>\n\n<p>Reporting requirements for many non-cash benefits are different to those for cash earnings. In general, benefits must be reported to HM Revenue and Customs (<abbr title=\"HM Revenue and Customs\">HMRC</abbr>) at the end of the tax year using forms <a rel=\"external\" href=\"https://www.gov.uk/government/publications/paye-end-of-year-expenses-and-benefits-p11d\">P11D</a> or <a rel=\"external\" href=\"https://www.gov.uk/government/publications/paye-end-of-year-expenses-and-benefits-p9d\">P9D</a>. </p>\n\n<h3 id=\"tax-and-nics-exemptions-on-non-cash-benefits\">Tax and <abbr title=\"National Insurance contributions\">NICs</abbr> exemptions on non-cash benefits</h3>\n\n<p>Some non-cash benefits qualify for an exemption from tax. Some may be disregarded before calculating <abbr title=\"National Insurance contributions\">NICs</abbr>. If this is the case for a benefit an employer provides to an employee as part of a salary sacrifice arrangement, any conditions that apply to the exemption must be satisfied.</p>\n\n<p>For example, if a benefit has to be made available to all employees in order to be exempt, then this condition must be fully satisfied, whether or not all employees have a salary sacrifice arrangement.</p>\n\n<p>Guidance for employers on particular <a rel=\"external\" href=\"https://www.gov.uk/expenses-and-benefits-a-to-z\">expenses and benefits</a> is available. </p>\n\n<h3 id=\"ask-hmrc-to-confirm-the-tax-and-nics\">Ask <abbr title=\"HM Revenue and Customs\">HMRC</abbr> to confirm the tax and <abbr title=\"National Insurance contributions\">NICs</abbr>\n</h3>\n\n<p>Once a salary sacrifice arrangement is in place, employers can ask the <abbr title=\"HM Revenue and Customs\">HMRC</abbr> Clearances Team to confirm the tax and <abbr title=\"National Insurance contributions\">NICs</abbr> implications. <abbr title=\"HM Revenue and Customs\">HMRC</abbr> won’t comment on a proposed salary sacrifice arrangement before it has been put in place.</p>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\n<abbr title=\"HM Revenue and Customs\">HMRC</abbr> Clearances Team\n<br>Alexander House\n<br>21 Victoria Avenue \n<br>Southend-on-Sea\n<br>Essex\n<br>SS99 1BD\n<br>\n</p></div></div>\n\n<p>Alternatively they can email the <abbr title=\"HM Revenue and Customs\">HMRC</abbr> Clearances Team at <a href=\"mailto:hmrc.southendteam@hmrc.gsi.gov.uk\">hmrc.southendteam@hmrc.gsi.gov.uk</a></p>\n\n<p>To be satisfied that the change has been effective at the right time and not applied retrospectively, <abbr title=\"HM Revenue and Customs\">HMRC</abbr> would need to see:</p>\n\n<ul>\n  <li>evidence of the variation of terms and conditions (if there is a written contract)</li>\n  <li>payslips before and after the variation</li>\n</ul>\n\n<h2 id=\"examples-of-salary-sacrifice\">Examples of salary sacrifice</h2>\n\n<table>\n  <thead>\n    <tr>\n      <th>Salary</th>\n      <th>Salary sacrificed</th>\n      <th>Non cash benefit received</th>\n      <th>Consequence</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>£350 per week</td>\n      <td>£50 of that salary</td>\n      <td>Childcare voucher to the same value</td>\n      <td>Only £300 is subject to tax and <abbr title=\"National Insurance contributions\">NICs</abbr>, childcare vouchers are exempt from both tax and Class 1 <abbr title=\"National Insurance contributions\">NICs</abbr> up to a limit of £55 per week</td>\n    </tr>\n    <tr>\n      <td>£350 per week</td>\n      <td>£100 of that salary</td>\n      <td>Childcare vouchers to the same value</td>\n      <td>£295 is subject to tax and <abbr title=\"National Insurance contributions\">NICs</abbr> - PAYE is operated on the £250 cash component, childcare vouchers are exempt from both tax and Class 1 <abbr title=\"National Insurance contributions\">NICs</abbr> up to a limit of £55 per week, £45 is reported as a non-cash benefit  at the end of the tax year using forms P11D or P9D</td>\n    </tr>\n    <tr>\n      <td>£5,000 bonus</td>\n      <td>£5,000</td>\n      <td>£5,000 employer contribution to registered pension scheme</td>\n      <td>No employment income tax or <abbr title=\"National Insurance contributions\">NICs</abbr> charge to the employee - the full amount is invested in the pension fund</td>\n    </tr>\n  </tbody>\n</table>\n\n<h3 id=\"childcare-vouchers-and-tax-credits\">Childcare vouchers and tax credits</h3>\n\n<p>Childcare vouchers from an employer may affect the amount of tax credits an employee gets. Employees can <a rel=\"external\" href=\"https://www.gov.uk/childcare-vouchers-better-off-calculator\">use a calculator</a> to help them decide if they’re better off taking the vouchers or not.</p>\n\n<h2 id=\"earnings-related-payments\">Earnings related payments</h2>\n\n<p>Employers usually decide how earnings related payments such as occupational pension contributions, overtime rates, pay rises, etc are calculated. Such payments can be based on the notional salary or the new reduced cash salary, but this must be made clear to the employee.</p>\n\n<h2 id=\"earnings-related-benefits\">Earnings related benefits</h2>\n\n<p>Salary sacrifice can affect an employee’s entitlement to earnings related benefits such as <a rel=\"external\" href=\"https://www.gov.uk/maternity-allowance\">Maternity Allowance</a> and <a rel=\"external\" href=\"https://www.gov.uk/additional-state-pension\">Additional State Pension</a>. The amount they receive may be less than the full standard rate or they may lose the entitlement altogether.</p>\n\n<h2 id=\"contribution-based-benefits\">Contribution based benefits</h2>\n\n<p>Salary sacrifice may affect an employee’s entitlement to contribution based benefits such as <a rel=\"external\" href=\"https://www.gov.uk/incapacity-benefit\">Incapacity Benefit</a> and <a rel=\"external\" href=\"https://www.gov.uk/state-pension\">State Pension</a>. Salary sacrifice may reduce the cash earnings on which <abbr title=\"National Insurance contributions\">NICs</abbr> are charged. Employees may therefore pay – or be treated as paying – less or no <abbr title=\"National Insurance contributions\">NICs</abbr>.</p>\n\n<h2 id=\"statutory-payments\">Statutory payments</h2>\n\n<p>Salary sacrifice can affect the amount of <a rel=\"external\" href=\"https://www.gov.uk/government/collections/statutory-pay\">statutory pay</a> an employee receives. It can cause some employees to lose their entitlement altogether. If a salary sacrifice arrangement reduces an employee’s average weekly earnings below the lower earnings limit, then the employer doesn’t have to make any statutory payments to them.</p>\n\n<h2 id=\"workplace-pension-schemes\">Workplace pension schemes</h2>\n\n<p>The employer decides whether salary sacrifice affects contributions into a <a rel=\"external\" href=\"https://www.gov.uk/workplace-pensions-employers\">workplace pension</a> scheme. Often, employers will use a notional level of pay to calculate employer and employee pension contributions, so that employees who participate in salary sacrifice arrangements are not put at a disadvantage. </p>\n\n<p>However, employers should always check with their scheme provider to make sure any such arrangements are allowable.\nOther salary sacrifice arrangements are possible. For example, an employer might agree to pay more than the minimum amount required, to cover some or all of the employee’s contribution. The employee may then become entitled to a lower cash salary. </p>\n\n<h3 id=\"auto-enrolment\">Auto-enrolment</h3>\n\n<p>Where an employee has been automatically enrolled into a workplace pension scheme, it will be a registered pension scheme for tax purposes. No tax is charged on the contributions an employer pays to a registered pension scheme in respect of an employee.</p>\n\n<p>Where an employee <a rel=\"external\" href=\"https://www.gov.uk/workplace-pensions/if-you-want-to-leave-your-workplace-pension-scheme\">opts out</a> of a workplace pension scheme, it is possible that they will have received reduced earnings under the salary sacrifice arrangement. If the employer ‘makes good’ that shortfall to the employee then the payment should be made subject to tax and <abbr title=\"National Insurance contributions\">NICs</abbr>.</p>\n\n<h2 id=\"technical-guidance\">Technical guidance</h2>\n\n<p>The following guides contain more detailed information:</p>\n\n<ul>\n  <li>Employment Income Manual - <a rel=\"external\" href=\"http://www.hmrc.gov.uk/manuals/eimanual/EIM42750.htm\">Salary sacrifice</a>\n</li>\n  <li>Employment Income Manual - <a rel=\"external\" href=\"http://www.hmrc.gov.uk/manuals/eimanual/EIM21600.htm\">Particular benefits</a>\n</li>\n  <li>Employment Income Manual - <a rel=\"external\" href=\"http://www.hmrc.gov.uk/manuals/eimanual/EIM42775.htm\">Salary sacrifice: contributions to a registered pension scheme: income tax effects</a>\n</li>\n  <li>Tax Credits Technical Manual - <a rel=\"external\" href=\"http://www.hmrc.gov.uk/manuals/tctmanual/tctm04104.htm\">Income: Employment Income Rules: Salary sacrifice</a>\n</li>\n</ul>\n\n</div>",
    "first_public_at": "2014-06-12T10:00:00+01:00",
    "change_history": [
      {
        "public_timestamp": "2016-02-18T10:37:00+00:00",
        "note": "The second entry in the table Examples of salary sacrifice has been amended to correct the explanation of how much of the salary is subject to tax and National Insurance contributions."
      },
      {
        "public_timestamp": "2015-05-26T18:19:27+01:00",
        "note": "Information for employees added to guide."
      },
      {
        "public_timestamp": "2014-06-12T10:00:00+01:00",
        "note": "First published."
      }
    ],
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "emphasised_organisations": ["6667cce2-e809-4e21-ae09-cb0bdc1ddda3"],
    "political": false
  },
  "links": {
    "organisations": [
      {
        "content_id": "6667cce2-e809-4e21-ae09-cb0bdc1ddda3",
        "title": "HM Revenue & Customs",
        "base_path": "/government/organisations/hm-revenue-customs",
        "api_url": "https://www.gov.uk/api/organisations/hm-revenue-customs",
        "web_url": "https://www.gov.uk/government/organisations/hm-revenue-customs",
        "locale": "en",
        "analytics_identifier": "D25"
      }
    ],
    "policy_areas": [
      {
        "content_id": "8034be95-4ac2-4fff-93c5-e7514ed9504a",
        "title": "Tax and revenue",
        "base_path": "/government/topics/tax-and-revenue",
        "api_url": "https://www.gov.uk/api/content/government/world/topics/tax-and-revenue",
        "web_url": "https://www.gov.uk/government/world/topics/tax-and-revenue",
        "locale": "en"
      }
    ],
    "parent": [
      {
        "content_id": "6e1d83bc-d37a-447c-bdac-31be4b441417",
        "title": "PAYE",
        "base_path": "/topic/business-tax/paye",
        "api_url": "https://www.gov.uk/api/content/topic/business-tax/paye",
        "web_url": "https://www.gov.uk/topic/business-tax/paye",
        "locale": "en",
        "parent": [
          {
            "content_id": "a481832e-5f10-4d3b-8131-a064b36730ae",
            "title": "Business tax",
            "base_path": "/topic/business-tax",
            "api_url": "https://www.gov.uk/api/content/topic/business-tax",
            "web_url": "https://www.gov.uk/topic/business-tax",
            "locale": "en"
          }
        ]
      }
    ],
    "topics": [
      {
        "content_id": "6e1d83bc-d37a-447c-bdac-31be4b441417",
        "title": "PAYE",
        "base_path": "/topic/business-tax/paye",
        "api_url": "https://www.gov.uk/api/content/topic/business-tax/paye",
        "web_url": "https://www.gov.uk/topic/business-tax/paye",
        "locale": "en"
      },
      {
        "content_id": "a481832e-5f10-4d3b-8131-a064b36730ae",
        "title": "Business tax",
        "base_path": "/topic/business-tax",
        "api_url": "https://www.gov.uk/api/content/topic/business-tax",
        "web_url": "https://www.gov.uk/topic/business-tax",
        "locale": "en"
      }
    ]
  }
}

```

### national_applicability_alternative_url_detailed_guide.json
```json
{
  "content_id": "5f20e4c6-7631-11e4-a3cb-005056011aef",
  "base_path": "/guidance/report-lost-or-stolen-cattle",
  "description": "What to do if any of your cattle, bison or buffalo are lost or stolen, and if you get them back. ",
  "public_updated_at": "2014-05-06T13:03:41+01:00",
  "title": "Report lost or stolen cattle",
  "schema_name": "detailed_guide",
  "document_type": "detailed_guide",
  "format": "detailed_guide",
  "locale": "en",
  "details": {
    "body": "<div class=\"govspeak\"><p>You must report any loss or theft of an animal to the police and to the British Cattle Movement Service (BCMS) and inform them if the animal is recovered.</p>\n\n<h2 id=\"if-an-animal-is-lost-or-stolen\">If an animal is lost or stolen</h2>\n\n<p>You must:</p>\n\n<ul>\n  <li>report the loss or theft to the police and obtain an incident number</li>\n  <li>post the animal’s passport or certificate of registration to arrive with BCMS within 7 days of becoming aware of the loss or theft, at the following address:</li>\n</ul>\n\n<div class=\"address\"><div class=\"adr org fn\"><p>\n\nBCMS\n<br>Curwen Road\n<br>Workington \n<br>CA14 2DD \n<br>\n</p></div></div>\n\n<p>You should also make a note of the date of the loss or theft in your <a rel=\"external\" href=\"https://www.gov.uk/keep-a-holding-register-for-cattle\">holding register</a>.</p>\n\n<h2 id=\"if-the-animal-is-recovered\">If the animal is recovered</h2>\n\n<p>You must:</p>\n\n<ul>\n  <li>confirm this in writing with BCMS at the address above</li>\n  <li>inform the police that the animal has been recovered</li>\n  <li>update your farm records to show the animal has been recovered</li>\n</ul>\n\n<p>BCMS will send you a replacement passport.</p>\n</div>",
    "first_public_at": "2014-05-06T13:03:41+01:00",
    "tags": {
      "browse_pages": [],
      "topics": ["keeping-farmed-animals/cattle-identity-registration"],
      "policies": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "emphasised_organisations": ["49e09fa7-f65b-49d6-b4ab-0ca82a548e93"],
    "change_history": [
      {
        "public_timestamp": "2014-05-06T13:03:41+01:00",
        "note": "First published."
      }
    ],
    "political": false,
    "national_applicability": {
      "england": {
        "label": "England",
        "applicable": true
      },
      "northern_ireland": {
        "label": "Northern Ireland",
        "applicable": false,
        "alternative_url": "http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for"
      },
      "scotland": {
        "label": "Scotland",
        "applicable": true
      },
      "wales": {
        "label": "Wales",
        "applicable": true
      }
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "49e09fa7-f65b-49d6-b4ab-0ca82a548e93",
        "title": "British Cattle Movement Service",
        "base_path": "/government/organisations/british-cattle-movement-service",
        "api_url": "https://www.gov.uk/api/organisations/british-cattle-movement-service",
        "web_url": "https://www.gov.uk/government/organisations/british-cattle-movement-service",
        "locale": "en",
        "analytics_identifier": "OT1051"
      }
    ],
    "parent": []
  }
}

```

### national_applicability_detailed_guide.json
```json
{
  "content_id": "5d5ea667-7631-11e4-a3cb-005056011aef",
  "base_path": "/guidance/housing-finance-and-household-expenditure-notes-and-definitions",
  "description": "Information on how statistics on housing finance and household expenditure are compiled.",
  "public_updated_at": "2013-02-27T12:01:17+00:00",
  "title": "Housing finance and household expenditure: notes and definitions",
  "schema_name": "detailed_guide",
  "document_type": "detailed_guide",
  "format": "detailed_guide",
  "locale": "en",
  "details": {
    "body": "<div class=\"govspeak\"><h2 id=\"overview\">Overview</h2>\n\n<p>This guidance is to be read in conjunction with the <a rel=\"external\" href=\"https://www.gov.uk/government/organisations/department-for-communities-and-local-government/series/housing-finance-and-household-expenditure-social-housing\">series on housing finance and household expenditure</a> which includes the latest sets of live tables.</p>\n\n<h2 id=\"expenditure-and-income-on-housing-from-housing-revenue-account\">Expenditure and income on housing from Housing Revenue Account</h2>\n\n<p>Each local authority is required by statute to keep a Housing Revenue Account in which are recorded the annual revenue income and expenditure in respect of dwellings and other property provided under <a rel=\"external\" href=\"http://www.legislation.gov.uk/ukpga/1985/68/part/II\" title=\"Housing Act 1985: Part II\">Part II of the Housing Act 1985.</a> Housing Revenue Account self-financing was implemented as part of the <a rel=\"external\" href=\"http://www.legislation.gov.uk/ukpga/2011/20/contents/enacted\" title=\"Localism Act 2011\">Localism Act 2011.</a> As a result of this, the previous subsidy system ceased in April 2012 and we are in the process of reviewing the basis of the <a href=\"http://www.dev.gov.uk/government/statistical-data-sets/live-tables-on-housing-finance-and-household-expenditure\" title=\"Live tables on housing finance and household expenditure\">live tables</a>.</p>\n\n<p>The main items of expenditure are:</p>\n\n<ul>\n  <li>loan charges in respect of moneys borrowed for the provision or improvement of local authority housing accommodation mainly under Part II of the Housing Act 1985</li>\n  <li>supervision and management</li>\n  <li>housing repairs</li>\n</ul>\n\n<p>The main items of income are:</p>\n\n<ul>\n  <li>rents (excluding rates and water charges)</li>\n  <li>Exchequer housing subsidies</li>\n  <li>investment and interest income from the sale of dwellings</li>\n</ul>\n\n<p>Figures of expenditure and income for each authority are collected annually by the Department for Communities and Local Government in housing subsidy claim forms.</p>\n\n<h2 id=\"renewal-grants\">Renewal grants</h2>\n\n<p>Live table 313 relates to grants paid under the <a rel=\"external\" href=\"http://www.legislation.gov.uk/ukpga/1996/53/contents\" title=\"Housing Grants, Construction and Regeneration Act 1996\">Housing Grants, Construction and Regeneration Act 1996.</a></p>\n\n<p>The Housing Grants, Construction and Regeneration 1996 Act came into operation in December 1996, replacing the Local Government and Housing Act 1989. The main effect of the 1996 Act was to make most grants discretionary rather than to change significantly the nature of the grants, although there were some modifications. Just one area of the 1989 Act, renewal areas, was left completely unchanged. It was repealed in July 2003. However, payments will continue for grants previously approved.</p>\n\n<p>Some of the main types of grants are detailed below.</p>\n\n<h3 id=\"home-repair-assistance\">Home Repair Assistance</h3>\n\n<p>Home Repair Assistance (<abbr title=\"Home Repair Assistance\">HRA</abbr>) was available at the authority’s discretion for financial support or materials to facilitate small-scale works of improvement, adaptation or improvement of a dwelling. It replaced Minor Works Assistance (1989 Act) and was intended, like its predecessor, to compliment the mainstream system of renovation grants. <abbr title=\"Home Repair Assistance\">HRA</abbr> was limited to a maximum of £2,000 per application, and no more than £4,000 was granted to any 1 property over a 3 year period.</p>\n\n<p><abbr title=\"Home Repair Assistance\">HRA</abbr> was not directly means-tested, although to be considered for a grant, an applicant would have had to be in receipt of at least 1 state benefit. In addition, they would have had to be over 18, had the power to carry out the works, and have lived in the dwelling as their only or main residence, or care for an elderly, infirm or disabled person. This grant was available to people living in mobile homes and houseboats.</p>\n\n<p>Examples of typical <abbr title=\"Home Repair Assistance\">HRA</abbr> works are:</p>\n\n<ul>\n  <li>securing the basic fabric of the property from wind or rain</li>\n  <li>protecting the occupants from immediate exposure to danger (that is, emergency works)</li>\n  <li>replacement of lead pipes</li>\n  <li>repairs to doors or windows</li>\n  <li>removal of radon</li>\n  <li>crime prevention measures</li>\n  <li>wheelchair ramps or grip rails</li>\n</ul>\n\n<h3 id=\"renovation-grants\">Renovation grants</h3>\n\n<p>This grant was the main type of grant for the improvement and/or repair of dwellings and for the conversion of houses and other buildings into flats for letting. It was mainly available to owner-occupiers and landlords (other than Houses in Multiple Occupation landlords), though it was available to tenants who were liable for works under the terms of their lease. The amount of grant was decided by the costs of the works concerned and the test of financial resources.</p>\n\n<p>The main purposes of the grant were:</p>\n\n<ul>\n  <li>to bring property up to the standard of fitness for human habitation (see below) - if a property is below this standard, then action will be required by the local authority, and if renovation is most appropriate then a grant is mandatory to owner-occupiers; grant is only mandatory to landlords if the works are required to comply with a repair notice</li>\n  <li>to repair and/or improve a property beyond the standard of fitness - grant is discretionary and it can be given in addition to mandatory grant, or on its own in the case of property already fit; for this reason the numbers of grants given out may exceed the numbers of dwellings renovated</li>\n  <li>for home insulation, where grant is discretionary</li>\n  <li>for heating, where again grant is discretionary, unless it is to make a property meet the fitness standard</li>\n  <li>for providing satisfactory internal arrangements, where grant is discretionary</li>\n  <li>for conversions, where grant is discretionary</li>\n</ul>\n\n<h3 id=\"common-parts-grants\">Common parts grants</h3>\n\n<p>This grant was available to help with the improvement or repair of the common parts of buildings containing one or more flats, where at least three-quarters of the flats have occupying tenants (that is owner-occupiers, long leaseholders or tenants whose flat is their main residence). Grants were available to landlords, landlords together with occupying tenants, or to occupying tenants if their lease made them liable for the works in question. Grants for works by a landlord to comply with a repair notice would have been mandatory; all other grants were discretionary. The amount of grant was decided by the test of financial resources.</p>\n\n<h3 id=\"houses-in-multiple-occupation-grants\">Houses in Multiple Occupation grants</h3>\n\n<p>This grant was available to cover works on Houses in Multiple Occupation (HMOs) where the occupants did not form a single household. It was only available to landlords. If works were required to comply with a statutory notice, then the grant was mandatory. Otherwise work to bring the <abbr title=\"House in Multiple Occupation\">HMO</abbr> up to the standard of fitness was discretionary. Discretionary grants were available for works to HMOs similar to those described in relation to the renovation grant. They were also available for the conversion of property into a <abbr title=\"House in Multiple Occupation\">HMO</abbr>. The amount of grant again depended on the test of financial resources.</p>\n\n<h3 id=\"minor-works-assistance\">Minor Works Assistance</h3>\n\n<p>This was available for carrying out small-scale works (costing up to £1,080), including insulation work. Assistance was only available to owner-occupiers or private sector tenants (including housing association tenants) who received an income related benefit. This assistance was for the following purposes:</p>\n\n<ul>\n  <li>to improve thermal insulation</li>\n  <li>for minor works to repair, improve or adapt a property for elderly occupants</li>\n  <li>to adapt property to enable an elderly person to move in with the occupants</li>\n  <li>to carry out minor repairs to a property in a clearance area</li>\n  <li>to replace lead piping in the water supply</li>\n</ul>\n\n<h2 id=\"disabled-facilities-grants\">Disabled Facilities Grants</h2>\n\n<p>Live table 314 provides data on the number and amount of Disabled Facilities Grants paid out by local authorities. For years up to and including 2007 to 2008, data were collected in the Housing Strategy Statistical Appendix (<abbr title=\"Housing Strategy Statistical Appendix\">HSSA</abbr>) return. For 2008 to 2009, this section was removed from the <abbr title=\"Housing Strategy Statistical Appendix\">HSSA</abbr> form to avoid duplication and data are taken from the Disabled Facilities Grant subsidy claim forms. Expenditure covers central Disabled Facilities Grant monies provided by the Department for Communities and Local Government to local authorities and any additional expenditure made by authorities directly.</p>\n\n<p>This grant is available for adapting, or providing facilities for, the home of a disabled person to make it more suitable for them to live in. It is also available for adaptations to the common parts of buildings containing 1 or more flats for a disabled person. Grants are available to, or on behalf of, registered or eligible disabled persons. They can be made to owner-occupiers, housing association tenants or to landlords on behalf of disabled tenants.</p>\n\n<p>The funding arrangements for providing adaptations to local authority tenants is different as the local authority must pay for them from their own resources. They cannot access the specific grant paid by the government to local authorities to reimburse them for expenditure incurred on Disabled Facilities Grants. Mandatory grants are available for works to make the disabled person manage more independently at home. The amount of grant is subject to a test of financial resources and has a grant maximum currently set at £30,000. Discretionary grant is available for other works to make a home suitable for disabled occupant’s accommodation, welfare or employment.</p>\n\n</div>",
    "first_public_at": "2013-02-27T12:01:17+00:00",
    "tags": {
      "browse_pages": [],
      "topics": ["government/national-and-official-statistics"],
      "policies": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "change_history": [
      {
        "public_timestamp": "2013-02-27T12:01:17+00:00",
        "note": "First published."
      }
    ],
    "political": false,
    "emphasised_organisations": ["2e7868a8-38f5-4ff6-b62f-9a15d1c22d28"],
    "national_applicability": {
      "england": {
        "label": "England",
        "applicable": true
      },
      "northern_ireland": {
        "label": "Northern Ireland",
        "applicable": false
      },
      "scotland": {
        "label": "Scotland",
        "applicable": false
      },
      "wales": {
        "label": "Wales",
        "applicable": false
      }
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "2e7868a8-38f5-4ff6-b62f-9a15d1c22d28",
        "title": "Department for Communities and Local Government",
        "base_path": "/government/organisations/department-for-communities-and-local-government",
        "api_url": "https://www.gov.uk/api/organisations/department-for-communities-and-local-government",
        "web_url": "https://www.gov.uk/government/organisations/department-for-communities-and-local-government",
        "locale": "en",
        "analytics_identifier": "D4"
      }
    ],
    "parent": []
  }
}

```

### political_detailed_guide.json
```json
{
  "content_id": "5d278772-7631-11e4-a3cb-005056011aef",
  "base_path": "/guidance/onshore-wind-part-of-the-uks-energy-mix",
  "description": "Onshore wind is a home-grown energy source that will protect UK consumers from energy price shocks and help meet renewable energy targets.",
  "public_updated_at": "2013-01-22T12:03:00+00:00",
  "title": "Onshore wind: part of the UK's energy mix",
  "updated_at": "2013-01-22T12:03:00+00:00",
  "schema_name": "detailed_guide",
  "document_type": "detailed_guide",
  "format": "detailed_guide",
  "locale": "en",
  "details": {
    "body": "<div class=\"govspeak\"><h2 id=\"overview\">Overview</h2>\n\n<p>The UK’s electricity supply faces an unprecedented challenge, with around a fifth of existing generation closing over the next decade and over £100 billion investment needed by 2020 as we look to secure low-carbon energy supplies. </p>\n\n<p>No individual technology will provide the silver bullet - our energy mix will have to become increasingly diverse.  As part of that mix, onshore wind has an important role to play as one of the most cost-effective and proven renewable energy technologies.</p>\n\n<p>In 2011, onshore wind:</p>\n\n<ul>\n  <li>generated enough power for 2.4 million homes </li>\n  <li>cost just £6 per household electricity bill in terms of subsidies</li>\n  <li>supported more than 8,600 jobs</li>\n  <li>saved more carbon emissions than the footprint of a city the size of Leeds</li>\n</ul>\n\n<h2 id=\"the-future-role-of-onshore-wind\">The future role of onshore wind</h2>\n\n<p>As part of a diverse energy mix, there are 4 main reasons why the government wants to see an increase in onshore wind:</p>\n\n<h3 id=\"contributions-to-energy-security-and-renewable-energy-goals\">1. Contributions to energy security and renewable energy goals</h3>\n\n<p>We must replace around a fifth of our existing electricity generation over the next decade - and as such we need to call on all the tools at our disposal to keep the lights on. This means having a balanced energy policy comprising a mix of nuclear, fossil fuels with <a rel=\"external\" href=\"https://www.gov.uk/government/policies/increasing-the-use-of-low-carbon-technologies/supporting-pages/carbon-capture-and-storage-ccs\">carbon capture and storage (<abbr title=\"carbon capture and storage\">CCS</abbr>)</a> and a major roll out of renewables.</p>\n\n<p>But every single energy technology carries risks and this is why we consider a balanced approach is crucial. For example:</p>\n\n<ul>\n  <li>Sizewell B nuclear power plant was out of commission for 7 months in 2010. In that time wind was producing the electricity for hundreds of thousands of homes</li>\n  <li>we are now net importers of gas. There is always a risk of interruption to gas and oil import supplies and uncertainties over global prices that  in 2011 were the primary reason for an increase in electricity prices</li>\n</ul>\n\n<p>Having more home-grown energy sources such as onshore wind, combined with demand-side response and improvements to the network, will help to protect UK consumers and businesses from price shocks in the longer term.</p>\n\n<p>Wind will also be a key component in meeting the UK’s 2020 target for energy from renewable sources and onshore wind could deliver around 14% of the required total energy. It has the potential to produce enough power for 7.7 million homes (32TWh).</p>\n\n<p>The <a href=\"http://www.dev.gov.uk/government/publications/renewable-energy-roadmap\">UK renewable energy roadmap</a> sets out the potential contribution of onshore wind to the target of 15% renewable energy by 2020.</p>\n\n<h3 id=\"carbon-savings\">2. Carbon savings</h3>\n\n<p>Electricity generated from wind power has one of the lowest carbon footprints compared with other forms of electricity generation. Nearly all the emissions occur during the manufacturing and construction phases, arising from the production of steel for the tower, concrete for the foundations and epoxy/fibreglass for the rotor blades. These account for 98% of the total life cycle CO2 emissions.</p>\n\n<p>This means onshore wind power has a relatively very small carbon footprint range of between 8 and 20g CO2eq/kWh, taking into account not only emissions from generation of electricity but those incurred during the manufacture, construction and decommissioning phases. By comparison, the average emissions from fossil-fuelled power generation in the UK was around 500gCO2/kWh.</p>\n\n<p>As a result, onshore wind power can make a real contribution to carbon reduction targets. In 2011, the Department of Energy &amp; Climate Change (DECC) estimated that approximately 6.3 million tonnes of CO2 were avoided in the UK (more than the carbon footprint of a city the size of Leeds), where onshore wind power displaces electricity generated from fossil-fuelled power generation. This was calculated using the total amount of electricity generated by onshore wind (10372Gwh), multiplied by an estimate of the amount of carbon dioxide emissions per gigawatt (Gwh) of electricity supplied for the known fossil fuel mix for electricity generation in the UK for 2011 (609t CO2/Gwh), divided by average equivalent carbon emissions per capita 2009 (7.4 tonnes). </p>\n\n<p>Including offshore, this figure rises to 9.3 million tonnes. In terms of emissions from reserve (or back-up) for wind power, additional fossil fuel stations may have come onto the system. However this additional reserve displaced the output of existing generating stations to maintain the balance of supply and demand, so there was no net increase of power on the system at any one time (the exact level of reserve and associated emissions changes on a daily basis throughout the year). Therefore the only additional emissions from reserve held for windpower was through the inefficiency of running separate fossil generating stations at part load rather than less at full-load, which is relatively insignificant compared to the carbon savings made.</p>\n\n<ul>\n  <li><a rel=\"external\" href=\"http://www.parliament.uk/business/publications/research/briefing-papers/POST-PN-383\">Parliamentary Office of Science and Technology note on carbon footprint of electricity generation</a></li>\n  <li>See how different energy pathways can help meet our energy demand and required carbon savings using the <a href=\"http://www.dev.gov.uk/guidance/2050-pathways-analysis\">2050 pathways calculator</a>\n</li>\n</ul>\n\n<h3 id=\"low-cost-low-carbon-generation\">3. Low cost low-carbon generation</h3>\n\n<p>Onshore wind is by far the cheapest large-scale renewable energy source that can be deployed at significant scale. </p>\n\n<h3 id=\"green-growth\">4. Green growth</h3>\n\n<p>Investment in wind can play a major part in the low-carbon economy. In 2011 onshore wind supported more than 8,600 jobs, was worth £548 million to the UK economy and is contributing to job creation across the UK. </p>\n\n<h2 id=\"costs-and-economic-benefits-of-onshore-wind\">Costs and economic benefits of onshore wind</h2>\n\n<p>All energy comes at a cost to the consumer and the challenge is to bring those costs down as swiftly as possible as we decarbonise our electricity supply. Wind energy is a free resource, so the costs reside only in the manufacture, construction and maintenance of the infrastructure. As such onshore wind is by far the cheapest large-scale renewable energy source that can be deployed at significant scale.</p>\n\n<p>But as well as meeting our energy security and climate change goals, onshore wind also brings huge economic opportunities in terms of inward investment to local economies, with direct and indirect job creation.</p>\n\n<h3 id=\"main-costs-and-economic-benefits\">Main costs and economic benefits</h3>\n\n<table>\n  <thead>\n    <tr>\n      <th>Main costs</th>\n      <th>Economic benefits</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Financial support to make onshore wind economic comes primarily through the <a rel=\"external\" href=\"https://www.gov.uk/government/policies/increasing-the-use-of-low-carbon-technologies/supporting-pages/the-renewables-obligation-ro\">Renewables Obligation (<abbr title=\"Renewables Obligation\">RO</abbr>)</a> through which subsidies are paid only for the renewable electricity actually generated</td>\n      <td>In 2011 onshore wind supported more than 8,600 jobs and was worth £548 million to the UK economy. Of this around 1,100 jobs and £84 million investment occur at the local authority level in which onshore wind turbines are located</td>\n    </tr>\n    <tr>\n      <td>In 2010/11, domestic and industrial electricity consumers paid around £440 million for onshore wind. For households this equates to just £6 a year on their electricity bill. In 2012 we proposed a 10% reduction in <abbr title=\"Renewables Obligation\">RO</abbr> support to minimise the impact on consumer energy bills and reflect falling costs</td>\n      <td>This equates to almost £700,000 for every megawatt (MW) of onshore wind installed in the UK, with over £100k staying in the local authority area</td>\n    </tr>\n    <tr>\n      <td>Onshore wind sites (larger than 5MW) were estimated to generate electricity at an average cost of £90.2/MWh, compared to £76.6/MWh for Combined Cycle Gas Turbines (CCGT), with the relative gap between onshore wind and CCGT costs halved in the last 5 years</td>\n      <td>If onshore wind is deployed at the central scale set out in the <a href=\"http://www.dev.gov.uk/government/publications/renewable-energy-roadmap\">UK renewable energy roadmap</a> (ie 13 GW) , the economy could benefit to the tune of £0.78 billion by 2020, supporting around 11,600 direct and supply chain jobs (rising to around 15,500 total jobs if wider quantifiable impacts are taken into account)</td>\n    </tr>\n    <tr>\n      <td>Smaller scale windfarms (below 5MW) are subsidised through the <a rel=\"external\" href=\"https://www.gov.uk/government/policies/increasing-the-use-of-low-carbon-technologies/supporting-pages/feed-in-tariffs-scheme\">Feed-in Tariff (FITs)</a> scheme. The total cost of the scheme for non-solar PV technologies (ie wind, hydro, anaerobic digestion) was estimated to be £300,000 per year in 2011</td>\n      <td>In addition, development of the onshore wind sector can bring a wide range of non-quantifiable benefits to local people including community benefit schemes that reward residents for hosting turbines, community ownership, investment in infrastructure around new developments and improvement to wildlife and habitat management</td>\n    </tr>\n  </tbody>\n</table>\n\n<ul>\n  <li>Information about generation costs of technologies</li>\n  <li>Information about economic impacts can be found in the joint DECC/renewableUK report by BiGGAR Economics, <a href=\"http://www.dev.gov.uk/government/publications/onshore-wind-direct-and-wider-economic-impacts\">‘Onshore Wind: direct and wider economic impacts’</a>\n</li>\n  <li>Written evidence on the costs of onshore wind power submitted to the Energy and Climate Change Select Committee can be found on the <a rel=\"external\" href=\"http://www.publications.parliament.uk/pa/cm201213/cmselect/cmenergy/writev/517/contents.htm\">The Economics of wind power</a>\n</li>\n</ul>\n\n<h3 id=\"further-information\">Further information</h3>\n\n<p><a rel=\"external\" href=\"https://www.gov.uk/government/statistical-data-sets/december-2012-energy-trends-weather-data\">Energy trends section 7: weather</a></p>\n\n<p><a rel=\"external\" href=\"https://www.gov.uk/government/statistical-data-sets/dukes-2012-weather-statistics\">DUKES 2013: Weather statistics</a></p>\n\n<section class=\"attachment embedded\" id=\"attachment_1075945\">\n  <div class=\"attachment-thumb\">\n      <a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/37672/7299-owctd-third-call-cost-model.xlsx\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/assets/pub-cover-spreadsheet-471052e0d03e940bbc62528a05ac204a884b553e4943e63c8bffa6b8baef8967.png\"></a>\n  </div>\n  <div class=\"attachment-details\">\n    <h2 class=\"title\"><a aria-describedby=\"attachment-1075945-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/37672/7299-owctd-third-call-cost-model.xlsx\">Offshore Wind Component Technologies Development and Demonstration Scheme: Simple levelised cost of energy model</a></h2>\n    <p class=\"metadata\">\n        <span class=\"type\">MS Excel Spreadsheet</span>, <span class=\"file-size\">148KB</span>\n    </p>\n\n\n      <div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-1075945-accessibility-help\">\n        <h2>This file may not be suitable for users of assistive technology.\n          <a class=\"toggler\" href=\"#attachment-1075945-accessibility-request\" data-controls=\"attachment-1075945-accessibility-request\" data-expanded=\"false\">Request a different format.</a>\n        </h2>\n        <p id=\"attachment-1075945-accessibility-request\" class=\"js-hidden\">\n          If you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Offshore%20Wind%20Component%20Technologies%20Development%20and%20Demonstration%20Scheme%3A%20Simple%20levelised%20cost%20of%20energy%20model%0A%20%20Original%20format%3A%20xlsx%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Offshore%20Wind%20Component%20Technologies%20Development%20and%20Demonstration%20Scheme%3A%20Simple%20levelised%20cost%20of%20energy%20model%27%20in%20an%20alternative%20format\"></a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n        </p>\n      </div>\n  </div>\n</section>\n\n<section class=\"attachment embedded\" id=\"attachment_1075946\">\n  <div class=\"attachment-thumb\">\n      <a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/37673/7300-owctd-briefing-slides.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/37673/thumbnail_7300-owctd-briefing-slides.pdf.png\"></a>\n  </div>\n  <div class=\"attachment-details\">\n    <h2 class=\"title\"><a aria-describedby=\"attachment-1075946-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/37673/7300-owctd-briefing-slides.pdf\">Offshore Wind Component Technologies Development and Demonstration Scheme briefing event: presentation slides</a></h2>\n    <p class=\"metadata\">\n        <span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">7.89MB</span>, <span class=\"page-length\">118 pages</span>\n    </p>\n\n\n      <div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-1075946-accessibility-help\">\n        <h2>This file may not be suitable for users of assistive technology.\n          <a class=\"toggler\" href=\"#attachment-1075946-accessibility-request\" data-controls=\"attachment-1075946-accessibility-request\" data-expanded=\"false\">Request a different format.</a>\n        </h2>\n        <p id=\"attachment-1075946-accessibility-request\" class=\"js-hidden\">\n          If you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Offshore%20Wind%20Component%20Technologies%20Development%20and%20Demonstration%20Scheme%20briefing%20event%3A%20presentation%20slides%0A%20%20Original%20format%3A%20pdf%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Offshore%20Wind%20Component%20Technologies%20Development%20and%20Demonstration%20Scheme%20briefing%20event%3A%20presentation%20slides%27%20in%20an%20alternative%20format\"></a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n        </p>\n      </div>\n  </div>\n</section>\n\n<section class=\"attachment embedded\" id=\"attachment_1075947\">\n  <div class=\"attachment-thumb\">\n      <a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/37674/6855-owctd-third-call-guidance-notes.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/37674/thumbnail_6855-owctd-third-call-guidance-notes.pdf.png\"></a>\n  </div>\n  <div class=\"attachment-details\">\n    <h2 class=\"title\"><a aria-describedby=\"attachment-1075947-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/37674/6855-owctd-third-call-guidance-notes.pdf\">Offshore Wind Component Technologies Development and Demonstration Scheme - Third call for proposals</a></h2>\n    <p class=\"metadata\">\n        <span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">311KB</span>, <span class=\"page-length\">22 pages</span>\n    </p>\n\n\n      <div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-1075947-accessibility-help\">\n        <h2>This file may not be suitable for users of assistive technology.\n          <a class=\"toggler\" href=\"#attachment-1075947-accessibility-request\" data-controls=\"attachment-1075947-accessibility-request\" data-expanded=\"false\">Request a different format.</a>\n        </h2>\n        <p id=\"attachment-1075947-accessibility-request\" class=\"js-hidden\">\n          If you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Offshore%20Wind%20Component%20Technologies%20Development%20and%20Demonstration%20Scheme%20-%20Third%20call%20for%20proposals%0A%20%20Original%20format%3A%20pdf%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Offshore%20Wind%20Component%20Technologies%20Development%20and%20Demonstration%20Scheme%20-%20Third%20call%20for%20proposals%27%20in%20an%20alternative%20format\"></a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n        </p>\n      </div>\n  </div>\n</section>\n\n<h2 id=\"planning-system-for-onshore-wind\">Planning system for onshore wind</h2>\n\n<p>The planning system has a central role in helping to deliver the infrastructure the UK needs to reduce our carbon emissions, ensure security of energy supply and help our economy to grow, while safeguarding our landscape and natural heritage and allowing individual communities the opportunity to shape their environment.</p>\n\n<p>Historically there have been concerns about the time taken to decide applications as well about as a lack of transparency, and apparent inconsistency across the UK in the way decisions are reached. Some communities have been concerned about the possible impacts of windfarms and associated grid infrastructure on landscapes and local amenities. The government is committed to resolving these issues so the UK has the low-carbon energy infrastructure it needs and communities have a say in decisions.</p>\n\n<p>To make sure the planning system delivers onshore wind in a sustainable way, the government will:</p>\n\n<ul>\n  <li>ensure decisions on projects that are of national significance above 50MW are taken swiftly by democratically accountable ministers in accordance with the <a href=\"http://www.dev.gov.uk/government/publications/national-policy-statements-for-energy-infrastructure\">National Policy Statements for energy infrastructure</a>\n</li>\n  <li>ensure projects below 50MW are dealt with locally in accordance with the revised <a rel=\"external\" href=\"http://www.communities.gov.uk/planningandbuilding/planningsystem/planningpolicy/planningpolicyframework\">National Planning Policy Framework</a>, which simplifies local planning, strengthens local participation and looks to achieve sustainable development</li>\n  <li>introduce neighbourhood planning and neighbourhood development orders through the <a rel=\"external\" href=\"http://www.communities.gov.uk/localgovernment/decentralisation/localismbill\">Localism Act 2011</a> to enable communities to shape their own locality</li>\n</ul>\n\n<h3 id=\"background\">Background</h3>\n\n<p>Planning applications for renewable energy projects, including onshore wind, above 50MW and proposals for electric powers lines are treated as new nationally significant infrastructure. This means decisions on large- scale wind projects will be taken by democratically accountable ministers (for wind in England and Wales this is the Secretary of State for Energy and Climate Change), who will make decisions in accordance with the National Policy Statements and any other matters that are relevant to the local area, including local plans.</p>\n\n<p>Projects below 50MW are dealt with at local authority level in England in accordance with the polices set out in the National Planning Policy Framework (NPPF). This commits to safeguarding the natural and historic environment, protecting areas of outstanding natural beauty, sites of special scientific interest and areas of national heritage importance. The NPPF requires local authorities to have:</p>\n\n<ul>\n  <li>a positive strategy to promote energy from renewable and low-carbon sources</li>\n  <li>consider identifying suitable areas for renewable and low-carbon energy sources</li>\n  <li>supporting infrastructure where this would help secure the development of such sources</li>\n</ul>\n\n<p>The NPPF also makes it clear that local planning authorities should design their policies to make sure any adverse impacts from renewable and low-carbon energy developments, including cumulative landscape and visual impacts, are addressed satisfactorily.</p>\n\n<p>We are also introducing neighbourhood planning and neighbourhood development orders through the <a rel=\"external\" href=\"http://www.legislation.gov.uk/ukpga/2011/20/contents/enacted\">Localism Act.</a> This will let communities draw up neighbourhood plans to shape development in their own locality and permit development without the need for planning applications. In the past the planning system hasn’t given local communities enough influence over decisions that make a big difference to their lives. New rights in the Localism Act will mean local people can lead the creation of neighbourhood plans, supported by the local planning authority. It is intended that once written the plan will be independently examined and put to a referendum of local people for approval.</p>\n\n<p>Alongside the planning framework, we are keen that communities can benefit from the development of windfarms, for example through the retention of business rates and the Community Benefit Protocol.</p>\n\n<h3 id=\"devolved-administrations\">Devolved administrations</h3>\n\n<p>Information about wind energy and planning policy in the devolved administrations can be found on the websites of the respective parliaments:</p>\n\n<ul>\n  <li><a rel=\"external\" href=\"http://www.scottish.parliament.uk\">Scottish Parliament</a></li>\n  <li><a rel=\"external\" href=\"http://www.assemblywales.org/\">Welsh Assembly</a></li>\n  <li><a rel=\"external\" href=\"http://www.northernireland.gov.uk/index.htm\">Northern Ireland Executive</a></li>\n</ul>\n\n<h2 id=\"wind-turbines-aviation-and-radar\">Wind turbines, aviation and radar</h2>\n\n<p>Wind turbines can potentially impact upon the radar the aviation industry needs to operate safely and effectively. Impacts could include physical obstructions; the generation of unwanted returns on Primary Surveillance Radar (<abbr title=\"Primary Surveillance Radar\">PSR</abbr>); and effects on the overall performance of communication, navigation and surveillance equipment and turbulence.</p>\n\n<p>Technological solutions are available, but each area of aviation demands its own solutions. Government and the aviation and wind industries are working collaboratively to resolve these issues to avoid the deployment of wind turbines having an impact on the safeguarding requirements for airspace users, whilst taking all necessary steps to protect aviation safety.</p>\n\n<h3 id=\"planning-impacts-and-safeguarding\">Planning impacts and safeguarding</h3>\n\n<p>Planning objections and conditions can be raised by the military (Ministry of Defence) or civilian bodies (<abbr title=\"National Air Traffic Services\">NATS</abbr>, UK Civil Aviation Authority and airport operators) and the issue is a significant barrier to the deployment of both onshore and offshore wind power. A <a rel=\"external\" href=\"http://www.renewableuk.com/\">RenewableUK</a> member’s survey reported that approximately 3GW of wind farm applications that were submitted for planning approval in 2013 were subject to objections or conditions from the aviation sector. The industry estimates that radar issues account for approximately 12GW of objections in the planning system as a whole.</p>\n\n<p>Many civil licensed aerodromes are safeguarded; either through statute or through arrangements with the local planning authority (LPA). Safeguarding is a process of consultation between an LPA and consultees to ensure that the operation and development of the aerodrome are not inhibited by buildings, structures, erections or works which infringe protected surfaces, obscure runway approach lights or have the potential to impair the performance of aerodrome communication, navigation and surveillance systems. The distance from the aerodrome that consultation may be required for a proposed wind turbine development will depend on the facilities and type of operation at the aerodrome concerned.</p>\n\n<p><a rel=\"external\" href=\"http://www.caa.co.uk/application.aspx?catid=33&amp;pagetype=65&amp;appid=11&amp;mode=detail&amp;id=200\">The Civil Aviation Authority’s (<abbr title=\"Civil Aviation Authority\">CAA</abbr>) CAP 670 ‘Air Traffic Services Safety Requirements’</a> provides further information. <a rel=\"external\" href=\"https://www.gov.uk/government/publications/wind-farms-ministry-of-defence-safeguarding/wind-farms-mod-safeguarding\">Guidance on Ministry of Defence safeguarding</a> is also available.</p>\n\n<h3 id=\"current-mitigation-solutions\">Current mitigation solutions</h3>\n\n<p>A number of mitigation techniques are available to help counter the effects of wind turbines on radars. These can vary from interim work-rounds (eg moving the locations of the wind turbines) to the use of in-fill radars. Further information is available in <a rel=\"external\" href=\"https://www.caa.co.uk/application.aspx?catid=33&amp;pagetype=65&amp;appid=11&amp;mode=detail&amp;id=2358\">the <abbr title=\"Civil Aviation Authority\">CAA</abbr>’s CAP 764 ‘Policy and Guidelines on Wind Turbines’ document</a>. </p>\n\n<h3 id=\"the-aviation-plan\">The Aviation Plan</h3>\n\n<p>The Aviation Plan aims to identify, develop and enable the implementation of mitigation measures to reduce the impacts of wind turbines on radar and aviation to acceptable levels, whilst taking all necessary steps to protect the safety of civilian and military air operations. It encourages a constructive dialogue between the wind and aviation industries so that the development of strategic approaches are explored and progressed. \nThe Aviation Plan was first published in 2008. The ‘Aviation Plan: 2015 Update’ is a refreshed and updated version of the original document that recognises recent achievements and seeks to identify and address the challenges still to be overcome.</p>\n\n<p><a rel=\"external\" href=\"https://www.gov.uk/government/publications/the-aviation-plan-2015-update\">The Aviation Plan: 2015 Update Document</a></p>\n\n<h3 id=\"the-aviation-management-board\">The Aviation Management Board</h3>\n\n<p><a rel=\"external\" href=\"https://www.gov.uk/government/groups/aviation-management-board-aviation-advisory-panel-and-fund-management-board\">The Aviation Management Board (<abbr title=\"Aviation Management Board\">AMB</abbr>)</a> has overall responsibility for overseeing the effective delivery of the Aviation Plan and its agreed programmes of work. It endorses the programme of work set out in the Plan and tasks those responsible with managing the work programmes that aim to deliver mitigation solutions. The <abbr title=\"Aviation Management Board\">AMB</abbr>’s Chair and Secretariat are provided by DECC who ensure that its progress is reported to Ministers.</p>\n\n<h3 id=\"further-information-and-relevant-publications\">Further information and relevant publications</h3>\n\n<p>The following websites provide useful information and resources:</p>\n\n<ul>\n  <li><a rel=\"external\" href=\"http://www.planningportal.gov.uk/permission/commonprojects/windturbines\">Planning Portal</a></li>\n  <li><a rel=\"external\" href=\"https://www.gov.uk/government/publications/wind-farms-ministry-of-defence-safeguarding\">MOD Safeguarding</a></li>\n  <li><a rel=\"external\" href=\"http://www.caa.co.uk/default.aspx?catid=1959\">Civil Aviation Authority</a></li>\n  <li><a rel=\"external\" href=\"http://www.renewableuk.com/en/our-work/aviation-and-radar/\">Renewable UK</a></li>\n  <li><a rel=\"external\" href=\"http://www.nats.aero/services/information/wind-farms/\"><abbr title=\"National Air Traffic Services\">NATS</abbr></a></li>\n  <li><a rel=\"external\" href=\"http://www.scotland.gov.uk/Topics/Business-Industry/Energy/Infrastructure/Energy-Consents/Guidance\">The Scottish Government</a></li>\n  <li><a rel=\"external\" href=\"https://www.gov.uk/government/publications/wind-turbine-study-raytheon-report\">UK <abbr title=\"National Air Traffic Services\">NATS</abbr> Wind Farm Study</a></li>\n  <li><a rel=\"external\" href=\"https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/38701/2379-mou-2010-update-wind-turbines.pdf\">Wind Turbines and Aviation Radar (Mitigation Issues) Memorandum of Understanding 2011 update</a></li>\n</ul>\n\n<h2 id=\"support-and-resources-for-local-projects\">Support and resources for local projects</h2>\n\n<p>We recognise the important role local authorities and communities play in helping to deliver our climate change and renewable energy goals. Alongside the planning system for onshore wind, we are working to create a new relationship between renewable energy projects and the communities that host them. This is because we believe communities should be rewarded for the contribution they are making to wider society and local authorities supported in making decisions on local energy projects.</p>\n\n<h3 id=\"community-benefits\">Community benefits</h3>\n\n<p>To encourage investment and growth in local renewable energy projects, we have committed to ensuring business rates for renewable projects are retained in full by local authorities so they can be used to directly benefit the local area, rather than collected and redistributed nationally. See <a rel=\"external\" href=\"http://www.communities.gov.uk/publications/localgovernment/businessratesrenewable\">Communities and local government: business rates retention scheme - renewable energy projects - a statement of intent</a> for full details.</p>\n\n<p>We also welcome the Community Engagement Protocol announced by renewableUK. The protocol specifies a £1,000 minimum payment per year per megawatt of installed wind power during the lifetime of the wind farm. At present most benefits are cash payments but communities can also benefit through job creation, training and energy efficiency measures. The decision on how the funds will be allocated will rest with the community living in the vicinity of the wind farm. </p>\n\n<h3 id=\"support-for-local-planning\">Support for local planning</h3>\n\n<p>To help local authorities and community groups develop local low-carbon energy projects, including onshore wind, the following resources are available:</p>\n\n<ul>\n  <li>\n<a rel=\"external\" href=\"http://ceo.decc.gov.uk\">Community Energy Online (CEO)</a> - DECC’s Community Energy Portal aimed at local authorities and community groups, which provides how-to guides and explains regulation and access to financing for all forms of energy efficiency and community energy projects</li>\n  <li>\n<a rel=\"external\" href=\"http://www.local.gov.uk/web/guest/the-lga-and-climate-change/-/journal_content/56/10171/3574359/ARTICLE-TEMPLATE\">Climate Local</a> -  a local government initiative to drive inspire and support council action on climate change, providing councils a chance to demonstrate their commitment to addressing climate change, as well as support in meeting these commitments, including through sharing learning between groups</li>\n  <li>\n<a rel=\"external\" href=\"http://www.project-gpwind.eu\">Good practice wind</a> - shares best practice and guidance on developing windfarms and involving communities</li>\n  <li>\n<a rel=\"external\" href=\"http://www.climateuk.net\">Climate UK</a> - offers both local and national support and expertise to projects that look to tackle climate change</li>\n  <li>\n<a href=\"http://www.dev.gov.uk/government/publications/regional-renewable-energy-capacity-assessments-review-of-approaches\">Renewable &amp; low-carbon capacity assessment methodology</a> </li>\n  <li>a DECC publication to ensure a robust evidence base supports the deployment of renewable energy \nThe methodology was adopted by the English regions and the approach evaluated by the National Non Food Crop Centre.</li>\n</ul>\n\n<h2 id=\"deployment-and-data\">Deployment and data</h2>\n\n<h3 id=\"generation\">Generation</h3>\n\n<p>In 2011 onshore wind generated 10,372 GWh of electricity, enough to power 2.4 million homes. This represented about 44% of UK renewable electricity production and just under 4% of all electricity produced.</p>\n\n<p>DECC publishes precise figures of wind electricity outputs that show monthly generation from major power producers and total annual generation from all wind farms in the <a rel=\"external\" href=\"https://www.gov.uk/government/organisations/department-of-energy-climate-change/series/digest-of-uk-energy-statistics-dukes\">Digest of UK energy statistics (DUKES)</a>. </p>\n\n<p>Full version of the data tables can be found on the <a rel=\"external\" href=\"http://www.decc.gov.uk/en/content/cms/statistics/energy_stats/source/renewables/renewables.aspx\">Energy statistics: Renewables statistics</a> web page.</p>\n\n<h3 id=\"deployment\">Deployment</h3>\n\n<p>The <a rel=\"external\" href=\"https://restats.decc.gov.uk/cms/welcome-to-the-restats-web-site\">Renewable Statistics (RESTATS)</a> website holds statistical information on both operational and planned renewable energy projects, as well as interactive maps showing their locations across the UK.</p>\n\n<h2 id=\"windspeed-database\">Windspeed database</h2>\n\n<p>This wind speed database estimates the annual mean wind speed throughout the UK, using an air flow model to estimate the effect of topography on wind speed</p>\n\n<p><a rel=\"external\" href=\"http://www.decc.gov.uk/en/windspeed/default.aspx\">Access the interactive database online</a></p>\n\n<p>If you want to refer to instructions while you use the database, or know more about the kind of reports that the database can provide, you’ll find help and examples on the information sheet.</p>\n\n<section class=\"attachment embedded\" id=\"attachment_1075959\">\n  <div class=\"attachment-thumb\">\n      <a aria-hidden=\"true\" class=\"thumbnail\" href=\"/government/uploads/system/uploads/attachment_data/file/38721/1402-windspeed-database-information-sheet.pdf\"><img alt=\"\" src=\"https://assets.digital.cabinet-office.gov.uk/government/uploads/system/uploads/attachment_data/file/38721/thumbnail_1402-windspeed-database-information-sheet.pdf.png\"></a>\n  </div>\n  <div class=\"attachment-details\">\n    <h2 class=\"title\"><a aria-describedby=\"attachment-1075959-accessibility-help\" href=\"/government/uploads/system/uploads/attachment_data/file/38721/1402-windspeed-database-information-sheet.pdf\">Database information sheet</a></h2>\n    <p class=\"metadata\">\n        <span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">39.1KB</span>, <span class=\"page-length\">4 pages</span>\n    </p>\n\n\n      <div data-module=\"toggle\" class=\"accessibility-warning\" id=\"attachment-1075959-accessibility-help\">\n        <h2>This file may not be suitable for users of assistive technology.\n          <a class=\"toggler\" href=\"#attachment-1075959-accessibility-request\" data-controls=\"attachment-1075959-accessibility-request\" data-expanded=\"false\">Request a different format.</a>\n        </h2>\n        <p id=\"attachment-1075959-accessibility-request\" class=\"js-hidden\">\n          If you use assistive technology and need a version of this document\nin a more accessible format, please email\n<a href=\"mailto:?body=Details%20of%20document%20required%3A%0A%0A%20%20Title%3A%20Database%20information%20sheet%0A%20%20Original%20format%3A%20pdf%0A%0APlease%20tell%20us%3A%0A%0A%20%201.%20What%20makes%20this%20format%20unsuitable%20for%20you%3F%0A%20%202.%20What%20format%20you%20would%20prefer%3F%0A%20%20%20%20%20%20&amp;subject=Request%20for%20%27Database%20information%20sheet%27%20in%20an%20alternative%20format\"></a>.\nPlease tell us what format you need. It will help us if you say what assistive technology you use.\n\n        </p>\n      </div>\n  </div>\n</section>\n\n<h3 id=\"disclaimer\">Disclaimer</h3>\n\n<p>This has been taken from the windspeed database information sheet:</p>\n\n<ul>\n  <li>This database is being maintained for reference and archive purposes only and is no longer being updated. Users should note that this database uses historic information and not live, up-to-date data.</li>\n  <li>The Department of Trade and Industry (DTI) originally developed the database at some point before 2001, and as far as is known the data that was used to build up the database was drawn from the mid-1970s to mid-1980s.</li>\n  <li>No support can be provided for queries in connection with this data or its use. Guidance on the usage of this data is provided on the windspeed database information sheet. Users are encouraged to follow operating instructions carefully.</li>\n  <li>Any results derived from this database should be treated as an approximate and high-level guide only and should be always followed by on-site measurements to ensure a proper assessment.</li>\n  <li>The windspeed data is not specifically designed to be suitable for a particular purpose or use. The user assumes full responsibility for using the data.</li>\n</ul>\n\n</div>",
    "first_public_at": "2013-01-22T12:03:00+00:00",
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": true,
    "emphasised_organisations": ["d65d4203-01f5-4920-a3b1-f614bfd8e83e"]
  },
  "links": {
    "organisations": [
      {
        "content_id": "d65d4203-01f5-4920-a3b1-f614bfd8e83e",
        "title": "Department of Energy & Climate Change",
        "base_path": "/government/organisations/department-for-environment-food-rural-affairs",
        "api_url": "https://www.gov.uk/api/organisations/department-of-energy-climate-change",
        "web_url": "https://www.gov.uk/government/organisations/department-of-energy-climate-change",
        "locale": "en",
        "analytics_identifier": "D11"
      }
    ],
    "parent": [
      {
        "content_id": "0d59f5e7-a230-4bac-b02c-624a59a34dab",
        "title": "Low carbon energy",
        "base_path": "/topic/climate-change-energy/low-carbon-energy",
        "api_url": "https://www.gov.uk/api/content/topic/climate-change-energy/low-carbon-energy",
        "web_url": "https://www.gov.uk/topic/climate-change-energy/low-carbon-energy",
        "locale": "en",
        "parent": [
          {
            "content_id": "57c6699d-ceda-4168-9d23-3fed774ca776",
            "title": "Climate change and energy",
            "base_path": "/topic/climate-change-energy",
            "api_url": "https://www.gov.uk/api/content/topic/climate-change-energy",
            "web_url": "https://www.gov.uk/topic/climate-change-energy",
            "locale": "en"
          }
        ]
      }
    ],
    "related_guides": [
      {
        "content_id": "0d59f5e7-a230-4bac-b02c-624a59a34dab",
        "title": "Offshore wind: part of the UK's energy mix",
        "base_path": "/guidance/offshore-wind-part-of-the-uks-energy-mix",
        "api_url": "https://www.gov.uk/api/content/guidance/offshore-wind-part-of-the-uks-energy-mix",
        "web_url": "https://www.gov.uk/guidance/offshore-wind-part-of-the-uks-energy-mix",
        "locale": "en"
      }
    ],
    "topics": [
      {
        "content_id": "0d59f5e7-a230-4bac-b02c-624a59a34dab",
        "title": "Low carbon energy",
        "base_path": "/topic/climate-change-energy/low-carbon-energy",
        "api_url": "https://www.gov.uk/api/content/topic/climate-change-energy/low-carbon-energy",
        "web_url": "https://www.gov.uk/topic/climate-change-energy/low-carbon-energy",
        "locale": "en"
      },
      {
        "content_id": "57c6699d-ceda-4168-9d23-3fed774ca776",
        "title": "Climate change and energy",
        "base_path": "/topic/climate-change-energy",
        "api_url": "https://www.gov.uk/api/content/topic/climate-change-energy",
        "web_url": "https://www.gov.uk/topic/climate-change-energy",
        "locale": "en"
      }
    ]
  }
}

```

### related_mainstream_detailed_guide.json
```json
{
  "content_id": "5d278772-7631-11e4-a3cb-005056011aef",
  "base_path": "/guidance/living-in-fiji--2",
  "description": "Advice for British people living in Fiji, including information on health, education, benefits, residence requirements and more.",
  "public_updated_at": "2014-01-22T07:11:48+00:00",
  "title": "Living in Fiji",
  "updated_at": "2014-01-22T07:11:48+00:00",
  "schema_name": "detailed_guide",
  "document_type": "detailed_guide",
  "format": "detailed_guide",
  "locale": "en",
  "details": {
    "body": "<div class=\"govspeak\"><h2 id=\"introduction\">Introduction</h2>\n<p>This guide sets out essential information for British nationals residing in Fiji, including advice on health, benefits, residence requirements and more. We are unable to provide any guidance on general lifestyle enquiries apart from the information and links listed below. See <a rel=\"external\" href=\"https://www.gov.uk/government/world/organisations/british-high-commission-suva\">our information on what consulates can and cannot do</a> for British nationals. This information supplements the travel advice for <a rel=\"external\" href=\"https://www.gov.uk/foreign-travel-advice/fiji\">Fiji</a>.</p>\n\n<h2 id=\"health\">Health</h2>\n<p>The availability of medical care varies across Viti Levu and Vanua Levu and may not meet the standards of care in the UK. Although adequate in some areas, medical care is limited in more remote areas. Treatment can be very expensive. Make sure you have comprehensive travel health insurance and accessible funds to cover the cost of any medical treatment abroad and repatriation to the UK. Make sure that your insurance policy provides for the following:</p>\n\n<ul>\n  <li>an air ambulance, in case you need to be flown home</li>\n  <li>full medical cover (bills can be very expensive)</li>\n  <li>repatriation in the event of a death</li>\n  <li>bringing your family to Fiji in the event of your illness or injury</li>\n</ul>\n\n<p>If you are hospitalised in Fiji, the British High Commission can contact the hospital to check on your progress, and visit you within 24 hours of notification of your hospitalisation. We can also contact your family or friends in the UK through the Foreign &amp; Commonwealth Office (FCO) in London.</p>\n\n<p>If you are suffering from mental illness, we will do our best to help you find the appropriate support and advice wherever you are.</p>\n\n<p>If you need emergency medical assistance dial 911 for an ambulance.</p>\n\n<h2 id=\"education\">Education</h2>\n<p>The Fijian government, through the <a rel=\"external\" href=\"http://www.education.gov.fj/\">Ministry of Education,National Heritage, Culture and Arts</a>, provides free education at public schools for Fijian citizens up to the age of 18.  </p>\n\n<h2 id=\"employment-and-recognised-qualifications\">Employment and recognised qualifications</h2>\n<p>All foreign nationals wishing to work and live in Fiji are required to have a relevant work permit issued by the Fijian Immigration.  Using a visa with the wrong category for working in Fiji, or overstaying your visa, can lead to prosecution, potentially resulting in detention and deportation at your own expense.</p>\n\n<h2 id=\"entry-and-residence-requirements\">Entry and residence requirements</h2>\n<p>Visas are not required for visits to Fiji of up to 4 months. You must have an onward or return ticket and a valid visa for the next country you are travelling to. If you are visiting Fiji on business you will be granted a stay for 14 days on arrival.</p>\n\n<p>If you plan to stay for longer than 4 months, you will need to apply for a visa from the <a rel=\"external\" href=\"http://www.fijihighcommission.org.uk/\">Fiji High Commission in London</a>.</p>\n\n<p>Your passport should be valid for a minimum period of 6 months from the date of entry into Fiji.</p>\n\n<p>Yachts can only enter Fiji through Suva, Lautoka, Savusavu and Levuka.</p>\n\n<p>You no longer need to register with the British High Commission Suva if you are staying in Fiji. Please read and subscribe to email updates on our <a rel=\"external\" href=\"https://www.gov.uk/foreign-travel-advice/fiji\">Travel Advice</a>. You can also stay in touch with us on <a rel=\"external\" href=\"https://www.facebook.com/ukinsouthpacific\">Facebook</a>.</p>\n\n<h3 id=\"dual-citizenship\">Dual citizenship</h3>\n<p>If you are a British national and you wish to apply for Fijian citizenship, please contact the <a rel=\"external\" href=\"http://www.immigration.gov.fj/index.php/navigational-aids\">Department of Immigration in Fiji</a>.\nFiji Immigration\n969 Rodwell Road\nSuva.\nTelephone: +679 312622</p>\n\n<h2 id=\"benefits\">Benefits</h2>\n<p>You may be entitled to claim some <a rel=\"external\" href=\"https://www.gov.uk/benefits-if-you-are-abroad\">UK benefits and state pension while living abroad</a>.\nIf you are moving to Fiji, you should tell the relevant UK government offices that deal with your benefits, pensions and tax that you are <a rel=\"external\" href=\"https://www.gov.uk/moving-or-retiring-abroad\">moving or retiring abroad</a>.</p>\n\n<h2 id=\"driving-licences-and-vehicles\">Driving licences and vehicles</h2>\n<p>It is not necessary to swap your British driving licence for a short stay but if you live in Fiji you must visit the <a rel=\"external\" href=\"http://www.ltafiji.com/index.php\">Land Transport Authority</a> for a local driving licence.</p>\n\n<h2 id=\"uk-state-pension-life-certificates\">UK State pension life certificates</h2>\n<p>The Department for Work and Pensions (DWP) has changed their policy on who can now sign a life certificate. This is now the same as the list of people who can countersign a passport photograph. Please read the DWP’s guide on getting a <a rel=\"external\" href=\"https://www.gov.uk/state-pension-if-you-retire-abroad\">state pension if you retire abroad</a>.</p>\n\n<h2 id=\"guidance-on-bringing-medication-into-fiji\">Guidance on bringing medication into Fiji</h2>\n<p>Penalties for importing and using illegal drugs are severe. Remember to bring your prescription from your doctor or hospital if you are using prescription medicine.</p>\n\n<h2 id=\"leaving-fiji\">Leaving Fiji</h2>\n<p>If you live in Fiji and are considering returning to live in the UK, you should consider how you will support yourself and how non-British members of your family may be able to accompany you. There is <a rel=\"external\" href=\"https://www.gov.uk/moving-or-retiring-abroad\">information</a> available to help you make informed choices about living abroad and thinking about returning to the UK.</p>\n\n<h3 id=\"national-insurance\">National Insurance</h3>\n<p>If you have not made full National Insurance (NI) contributions, remember you may not be eligible for state benefits or support. HM Revenue &amp; Customs provide some useful information on <a rel=\"external\" href=\"http://www.hmrc.gov.uk/cnr/\">returning to live in the UK for non-residents</a>, including how to make NI contributions from abroad.</p>\n\n<h3 id=\"healthcare\">Healthcare</h3>\n<p>Your entitlement to free NHS treatment depends on the length and purpose of your residence in the UK, not your nationality. You must be able to show UK residency to be eligible for free treatment, even if you are a British citizen. The <a rel=\"external\" href=\"http://www.adviceguide.org.uk/england.htm\">Citizens’ Advice Bureau</a> or <a rel=\"external\" href=\"http://www.nhs.uk/Pages/HomePage.aspx\">NHS</a> can provide further information.</p>\n\n<h2 id=\"disclaimer\">Disclaimer</h2>\n<p>This information is provided as a general guide and is based upon information provided to the embassy by the relevant local authorities and may be subject to change at any time with little or no notice. The FCO and the British High Commission will not be liable for any inaccuracies in this information. British nationals wishing to obtain any further information must contact the relevant local authority.</p>\n</div>",
    "first_public_at": "2014-01-22T07:07:00+00:00",
    "change_history": [
      {
        "public_timestamp": "2014-01-22T07:11:48+00:00",
        "note": "The latest updates for British nationals residing in Fiji."
      },
      {
        "public_timestamp": "2014-01-22T07:07:00+00:00",
        "note": "First published."
      }
    ],
    "tags": {
      "browse_pages": [],
      "topics": [],
      "policies": []
    },
    "related_mainstream_content": [
      "dd113259-fcaf-4e9b-83d5-d1148f33cf34", "f02fc2c9-f5ff-4ea2-acc4-730bbda957bb"
    ],
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "emphasised_organisations": ["9adfc4ed-9f6c-4976-a6d8-18d34356367c"],
    "political": false
  },
  "links": {
    "document_collections": [
      {
        "content_id": "5eb78a4e-7631-11e4-a3cb-005056011aef",
        "title": "Living in country guides",
        "base_path": "/government/collections/overseas-living-in-guides",
        "api_url": "https://www.gov.uk/api/content/government/collections/overseas-living-in-guides",
        "web_url": "https://www.gov.uk/government/collections/overseas-living-in-guides",
        "locale": "en"
      }
    ],
    "related_guides": [
      {
        "content_id": "0d59f5e7-a230-4bac-b02c-624a59a34dab",
        "title": "Living in Fiji",
        "base_path": "/guidance/living-in-fiji",
        "api_url": "https://www.gov.uk/api/content/guidance/living-in-fiji",
        "web_url": "https://www.gov.uk/guidance/living-in-fiji",
        "locale": "en"
      }
    ],
    "organisations": [
      {
        "content_id": "9adfc4ed-9f6c-4976-a6d8-18d34356367c",
        "title": "Foreign & Commonwealth Office",
        "base_path": "/government/organisations/foreign-commonwealth-office",
        "api_url": "https://www.gov.uk/api/organisations/foreign-commonwealth-office",
        "web_url": "https://www.gov.uk/government/organisations/foreign-commonwealth-office",
        "locale": "en",
        "analytics_identifier": "D13"
      }
    ],
    "related_guides": [
      {
        "content_id": "0d59f5e7-a230-4bac-b02c-624a59a34dab",
        "title": "Living in Fiji",
        "base_path": "/guidance/living-in-fiji",
        "api_url": "https://www.gov.uk/api/content/guidance/living-in-fiji",
        "web_url": "https://www.gov.uk/guidance/living-in-fiji",
        "locale": "en"
      }
    ],
    "related_mainstream": [
      {
        "content_id": "dd113259-fcaf-4e9b-83d5-d1148f33cf34",
        "title": "Overseas British passport applications",
        "base_path": "/overseas-passports",
        "api_url": "https://www.gov.uk/api/content/overseas-passports",
        "web_url": "https://www.gov.uk/overseas-passports",
        "locale": "en"
      },
      {
        "content_id": "f02fc2c9-f5ff-4ea2-acc4-730bbda957bb",
        "title": "Cancel a lost or stolen passport",
        "base_path": "/report-a-lost-or-stolen-passport",
        "api_url": "https://www.gov.uk/api/content/report-a-lost-or-stolen-passport",
        "web_url": "https://www.gov.uk/report-a-lost-or-stolen-passport",
        "locale": "en"
      }
    ]
  }
}

```

### translated_detailed_guide.json
```json
{
  "analytics_identifier": null,
  "base_path": "/guidance/prepare-a-charity-annual-return",
  "content_id": "5fec94c4-7631-11e4-a3cb-005056011aef",
  "description": "You must send an annual return (or update your details) every year if your charity is registered in England or Wales.",
  "details": {
    "body": "<div class=\"govspeak\"><h2 id=\"charity-annual-returns\">Charity annual returns</h2>\n\n<p>Over 6 million people search for and <a href=\"https://www.gov.uk/find-charity-information\">find charities\u2019 details online</a> every year. The annual return you complete tells potential donors, funders, volunteers and beneficiaries about your charity. For example:</p>\n\n<ul>\n  <li>how people can contact your charity</li>\n  <li>what it is set up to do</li>\n  <li>how it meets its aims</li>\n  <li>how much money it makes and spends</li>\n  <li>where it operates</li>\n</ul>\n\n<p>You can find most of the information you need in your charity\u2019s accounts and trustees\u2019 annual report.</p>\n\n<h2 id=\"completing-annual-returns--the-law\">Completing annual returns \u2013 the law</h2>\n\n<div class=\"call-to-action\">\n<p>As a charity trustee, by law you must keep your charity\u2019s registered details up-to-date. You need to <a href=\"https://www.gov.uk/change-your-charitys-details\">update your charity\u2019s details</a> before you complete its annual return.</p>\n</div>\n\n<p>If your charity\u2019s income is more than \u00a310,000, you must complete an annual return within 10 months of the end of each financial reporting period. Charitable incorporated organisations (CIOs) must complete an annual return regardless of their income.</p>\n\n<p>If you fail to meet this legal requirement, your charity\u2019s details will be marked \u2018overdue\u2019. This could put off potential donors, funders or volunteers.</p>\n\n<p>After 6 months the Charity Commission may remove your charity\u2019s details altogether and consider whether further action is needed.</p>\n\n<p>If your charity is not a CIO and its income is under \u00a310,000, complete the annual return to meet your legal obligation to keep your registered details up-to-date.</p>\n\n<h2 id=\"what-a-charity-annual-return-includes\">What a charity annual return includes</h2>\n\n<p>Your charity annual return is an online form - before you start, you\u2019ll need:</p>\n\n<ul>\n  <li>your charity\u2019s online services password</li>\n  <li>your registered charity number</li>\n  <li>registration numbers for any linked charities (if applicable)</li>\n</ul>\n\n<h3 id=\"financial-information\">Financial information</h3>\n\n<p>From your charity\u2019s latest accounts, provide:</p>\n\n<ul>\n  <li>start and end dates for the financial period you\u2019re reporting (for example 01/04/2013 to 31/03/2014)</li>\n  <li>total income and total spending for this reporting period</li>\n  <li>total spending outside England and Wales (if applicable)</li>\n</ul>\n\n<p>If your charity\u2019s income is over \u00a325,000, you\u2019ll need to submit a PDF copy of its accounts \u2013 these do not need to be signed. CIOs must submit accounts regardless of their income. These accounts need to be agreed by the trustees and you should also include a PDF copy of your independent examiner or auditor\u2019s report.</p>\n\n<p>If your charity\u2019s income is over \u00a325,000, you also need to send its trustees\u2019 annual report (TAR). CIOs must submit a TAR regardless of their income.</p>\n\n<p>If your charity\u2019s income is over \u00a3500,000, you\u2019ll need to include extra financial information from its accounts in the form.</p>\n\n<h3 id=\"serious-incident-reports\">Serious incident reports</h3>\n\n<p>If your charity has an income of \u00a325,000 or more, you must state if any serious incidents took place in the last year, including any that you should have reported but did not.</p>\n\n<h2 id=\"when-to-complete-your-annual-return\">When to complete your annual return</h2>\n\n<p>Complete your charity\u2019s annual return as soon as you approve its latest accounts and trustees\u2019 annual report.</p>\n\n<div class=\"call-to-action\">\n<p>If your charity\u2019s income is more than \u00a310,000, by law, you must complete an annual return within 10 months of the financial reporting period ending. All CIOs must complete an annual return regardless of their income.</p>\n</div>\n\n<p>As trustees, you\u2019re responsible for making sure your charity\u2019s annual return is completed on time. If you delegate this task \u2013 for example, to a member of staff \u2013 make sure they know what to do and when it is due.</p>\n\n<p>Plan ahead to make sure your charity completes its annual return on time. You should also:</p>\n\n<ul>\n  <li>\n<a href=\"https://www.gov.uk/change-your-charitys-details\">update the charity\u2019s details</a> whenever something changes, such as a trustee being replaced</li>\n  <li>keep your charity\u2019s password safe, particularly if the person who has it leaves the charity</li>\n  <li>arrange handover training if someone takes over responsibility for completing the annual return</li>\n  <li>arrange a trustee meeting to agree the accounts and trustees\u2019 annual report within two months of the financial period ending</li>\n</ul>\n\n<div class=\"call-to-action\">\n<p><a href=\"https://www.gov.uk/send-charity-annual-return\">Complete your charity\u2019s annual return now</a>.</p>\n</div>\n</div>",
    "change_history": [
      {
        "note": "First published.",
        "public_timestamp": "2013-05-23T00:00:00.000+01:00"
      }
    ],
    "emphasised_organisations": [
      "489e651f-34c8-4b34-bdd7-e13c2324cde3"
    ],
    "first_public_at": "2013-05-23T00:00:00.000+01:00",
    "government": {
      "current": false,
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government"
    },
    "national_applicability": {
      "england": {
        "applicable": true,
        "label": "England"
      },
      "northern_ireland": {
        "alternative_url": "",
        "applicable": false,
        "label": "Northern Ireland"
      },
      "scotland": {
        "alternative_url": "",
        "applicable": false,
        "label": "Scotland"
      },
      "wales": {
        "applicable": true,
        "label": "Wales"
      }
    },
    "political": false,
    "related_mainstream_content": [],
    "tags": {
      "browse_pages": [],
      "policies": [],
      "topics": [
        "running-charity/managing-charity",
        "running-charity/money-accounts"
      ]
    }
  },
  "document_type": "detailed_guidance",
  "expanded_links": {
    "available_translations": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/prepare-a-charity-annual-return.cy",
        "base_path": "/guidance/prepare-a-charity-annual-return.cy",
        "content_id": "5fec94c4-7631-11e4-a3cb-005056011aef",
        "description": "Mae'n rhaid i chi anfon ffurflen flynyddol (neu ddiweddaru eich manylion) bob blwyddyn os yw'ch elusen wedi cofrestru yng Nghymru neu Loegr.",
        "locale": "cy",
        "public_updated_at": "2013-05-22T23:00:00.000Z",
        "title": "Paratoi ffurflen flynyddol elusen",
        "web_url": "https://www.gov.uk/guidance/prepare-a-charity-annual-return.cy"
      },
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/prepare-a-charity-annual-return",
        "base_path": "/guidance/prepare-a-charity-annual-return",
        "content_id": "5fec94c4-7631-11e4-a3cb-005056011aef",
        "description": "You must send an annual return (or update your details) every year if your charity is registered in England or Wales.",
        "locale": "en",
        "public_updated_at": "2013-05-22T23:00:00.000Z",
        "title": "Prepare a charity annual return",
        "web_url": "https://www.gov.uk/guidance/prepare-a-charity-annual-return"
      }
    ],
    "organisations": [
      {
        "analytics_identifier": "D98",
        "api_url": "https://www.gov.uk/api/content/government/organisations/charity-commission",
        "base_path": "/government/organisations/charity-commission",
        "content_id": "489e651f-34c8-4b34-bdd7-e13c2324cde3",
        "description": null,
        "expanded_links": {},
        "locale": "en",
        "public_updated_at": "2014-10-15T14:35:31.000Z",
        "title": "The Charity Commission",
        "web_url": "https://www.gov.uk/government/organisations/charity-commission"
      }
    ],
    "parent": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/topic/running-charity/managing-charity",
        "base_path": "/topic/running-charity/managing-charity",
        "content_id": "cf2ab891-5bd9-4788-8254-f9444423719c",
        "description": "List of information about Managing your charity.",
        "expanded_links": {
          "parent": [
            {
              "analytics_identifier": null,
              "api_url": "https://www.gov.uk/api/content/topic/running-charity",
              "base_path": "/topic/running-charity",
              "content_id": "68f2ac58-4394-442a-b309-6a7f372f345e",
              "description": "List of information about Setting up and running a charity.",
              "expanded_links": {},
              "locale": "en",
              "public_updated_at": "2015-08-11T14:45:10.000Z",
              "title": "Setting up and running a charity",
              "web_url": "https://www.gov.uk/topic/running-charity"
            }
          ]
        },
        "locale": "en",
        "public_updated_at": "2016-03-21T13:12:32.000Z",
        "title": "Managing your charity",
        "web_url": "https://www.gov.uk/topic/running-charity/managing-charity"
      }
    ],
    "related_guides": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/charity-commission-services-log-in-or-get-a-password",
        "base_path": "/guidance/charity-commission-services-log-in-or-get-a-password",
        "content_id": "601aa6ca-7631-11e4-a3cb-005056011aef",
        "description": "Start or continue your charity's annual return or registration application, plus how to get a new or replacement password.",
        "expanded_links": {},
        "locale": "en",
        "public_updated_at": "2013-03-31T23:00:00.000Z",
        "title": "Charity Commission services: log in or get a password",
        "web_url": "https://www.gov.uk/guidance/charity-commission-services-log-in-or-get-a-password"
      },
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/prepare-a-charity-trustees-annual-report",
        "base_path": "/guidance/prepare-a-charity-trustees-annual-report",
        "content_id": "5feebf0e-7631-11e4-a3cb-005056011aef",
        "description": "What to put in your trustees' annual report, depending on your charity's income and the value of its assets.",
        "expanded_links": {},
        "locale": "en",
        "public_updated_at": "2013-05-09T23:00:00.000Z",
        "title": "Prepare a charity trustees' annual report",
        "web_url": "https://www.gov.uk/guidance/prepare-a-charity-trustees-annual-report"
      }
    ],
    "topics": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/topic/running-charity/money-accounts",
        "base_path": "/topic/running-charity/money-accounts",
        "content_id": "6db5a402-5916-4820-89a6-a19c6c9e085e",
        "description": "List of information about Charity money, tax and accounts.",
        "expanded_links": {},
        "locale": "en",
        "public_updated_at": "2015-08-11T15:10:00.000Z",
        "title": "Charity money, tax and accounts",
        "web_url": "https://www.gov.uk/topic/running-charity/money-accounts"
      },
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/topic/running-charity/managing-charity",
        "base_path": "/topic/running-charity/managing-charity",
        "content_id": "cf2ab891-5bd9-4788-8254-f9444423719c",
        "description": "List of information about Managing your charity.",
        "expanded_links": {},
        "locale": "en",
        "public_updated_at": "2016-03-21T13:12:32.000Z",
        "title": "Managing your charity",
        "web_url": "https://www.gov.uk/topic/running-charity/managing-charity"
      }
    ]
  },
  "first_published_at": "2016-02-29T09:24:10.000+00:00",
  "format": "detailed_guide",
  "links": {
    "available_translations": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/prepare-a-charity-annual-return.cy",
        "base_path": "/guidance/prepare-a-charity-annual-return.cy",
        "content_id": "5fec94c4-7631-11e4-a3cb-005056011aef",
        "description": "Mae'n rhaid i chi anfon ffurflen flynyddol (neu ddiweddaru eich manylion) bob blwyddyn os yw'ch elusen wedi cofrestru yng Nghymru neu Loegr.",
        "document_type": "detailed_guidance",
        "links": {
          "lead_organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "parent": [
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ],
          "related_guides": [
            "601aa6ca-7631-11e4-a3cb-005056011aef",
            "5feebf0e-7631-11e4-a3cb-005056011aef"
          ],
          "topics": [
            "6db5a402-5916-4820-89a6-a19c6c9e085e",
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ]
        },
        "locale": "cy",
        "public_updated_at": "2013-05-22T23:00:00.000+00:00",
        "schema_name": "detailed_guide",
        "title": "Paratoi ffurflen flynyddol elusen",
        "web_url": "https://www.gov.uk/guidance/prepare-a-charity-annual-return.cy"
      },
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/prepare-a-charity-annual-return",
        "base_path": "/guidance/prepare-a-charity-annual-return",
        "content_id": "5fec94c4-7631-11e4-a3cb-005056011aef",
        "description": "You must send an annual return (or update your details) every year if your charity is registered in England or Wales.",
        "document_type": "detailed_guidance",
        "links": {
          "lead_organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "parent": [
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ],
          "related_guides": [
            "601aa6ca-7631-11e4-a3cb-005056011aef",
            "5feebf0e-7631-11e4-a3cb-005056011aef"
          ],
          "topics": [
            "6db5a402-5916-4820-89a6-a19c6c9e085e",
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ]
        },
        "locale": "en",
        "public_updated_at": "2013-05-22T23:00:00.000+00:00",
        "schema_name": "detailed_guide",
        "title": "Prepare a charity annual return",
        "web_url": "https://www.gov.uk/guidance/prepare-a-charity-annual-return"
      }
    ],
    "document_collections": [],
    "organisations": [
      {
        "analytics_identifier": "D98",
        "api_url": "https://www.gov.uk/api/content/government/organisations/charity-commission",
        "base_path": "/government/organisations/charity-commission",
        "content_id": "489e651f-34c8-4b34-bdd7-e13c2324cde3",
        "description": null,
        "details": {
          "brand": "department-for-business-innovation-skills",
          "logo": {
            "crest": null,
            "formatted_title": "Charity Commission"
          }
        },
        "document_type": "placeholder_organisation",
        "links": {},
        "locale": "en",
        "public_updated_at": "2014-10-15T14:35:31.000+00:00",
        "schema_name": "placeholder_organisation",
        "title": "The Charity Commission",
        "web_url": "https://www.gov.uk/government/organisations/charity-commission"
      }
    ],
    "parent": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/topic/running-charity/managing-charity",
        "base_path": "/topic/running-charity/managing-charity",
        "content_id": "cf2ab891-5bd9-4788-8254-f9444423719c",
        "description": "List of information about Managing your charity.",
        "document_type": "topic",
        "links": {
          "parent": [
            "68f2ac58-4394-442a-b309-6a7f372f345e"
          ]
        },
        "locale": "en",
        "public_updated_at": "2016-03-21T13:12:32.000+00:00",
        "schema_name": "topic",
        "title": "Managing your charity",
        "web_url": "https://www.gov.uk/topic/running-charity/managing-charity"
      }
    ],
    "related_guides": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/charity-commission-services-log-in-or-get-a-password",
        "base_path": "/guidance/charity-commission-services-log-in-or-get-a-password",
        "content_id": "601aa6ca-7631-11e4-a3cb-005056011aef",
        "description": "Start or continue your charity's annual return or registration application, plus how to get a new or replacement password.",
        "document_type": "detailed_guidance",
        "links": {
          "lead_organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "parent": [
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ],
          "related_guides": [
            "5f525ead-7631-11e4-a3cb-005056011aef",
            "5fec94c4-7631-11e4-a3cb-005056011aef"
          ],
          "related_mainstream": [
            "4688ad1e-6a55-4471-9c59-092c942b6349"
          ],
          "topics": [
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ]
        },
        "locale": "en",
        "public_updated_at": "2013-03-31T23:00:00.000+00:00",
        "schema_name": "detailed_guide",
        "title": "Charity Commission services: log in or get a password",
        "web_url": "https://www.gov.uk/guidance/charity-commission-services-log-in-or-get-a-password"
      },
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/guidance/prepare-a-charity-trustees-annual-report",
        "base_path": "/guidance/prepare-a-charity-trustees-annual-report",
        "content_id": "5feebf0e-7631-11e4-a3cb-005056011aef",
        "description": "What to put in your trustees' annual report, depending on your charity's income and the value of its assets.",
        "document_type": "detailed_guidance",
        "links": {
          "lead_organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "organisations": [
            "489e651f-34c8-4b34-bdd7-e13c2324cde3"
          ],
          "parent": [
            "6db5a402-5916-4820-89a6-a19c6c9e085e"
          ],
          "related_guides": [
            "5f162fca-7631-11e4-a3cb-005056011aef",
            "5fec94c4-7631-11e4-a3cb-005056011aef"
          ],
          "related_mainstream": [
            "4688ad1e-6a55-4471-9c59-092c942b6349"
          ],
          "topics": [
            "9430260c-677d-4da9-b61e-bb3b524cdad9",
            "6db5a402-5916-4820-89a6-a19c6c9e085e",
            "cf2ab891-5bd9-4788-8254-f9444423719c"
          ]
        },
        "locale": "en",
        "public_updated_at": "2013-05-09T23:00:00.000+00:00",
        "schema_name": "detailed_guide",
        "title": "Prepare a charity trustees' annual report",
        "web_url": "https://www.gov.uk/guidance/prepare-a-charity-trustees-annual-report"
      }
    ],
    "topics": [
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/topic/running-charity/money-accounts",
        "base_path": "/topic/running-charity/money-accounts",
        "content_id": "6db5a402-5916-4820-89a6-a19c6c9e085e",
        "description": "List of information about Charity money, tax and accounts.",
        "document_type": "topic",
        "links": {
          "parent": [
            "68f2ac58-4394-442a-b309-6a7f372f345e"
          ]
        },
        "locale": "en",
        "public_updated_at": "2015-08-11T15:10:00.000+00:00",
        "schema_name": "topic",
        "title": "Charity money, tax and accounts",
        "web_url": "https://www.gov.uk/topic/running-charity/money-accounts"
      },
      {
        "analytics_identifier": null,
        "api_url": "https://www.gov.uk/api/content/topic/running-charity/managing-charity",
        "base_path": "/topic/running-charity/managing-charity",
        "content_id": "cf2ab891-5bd9-4788-8254-f9444423719c",
        "description": "List of information about Managing your charity.",
        "document_type": "topic",
        "links": {
          "parent": [
            "68f2ac58-4394-442a-b309-6a7f372f345e"
          ]
        },
        "locale": "en",
        "public_updated_at": "2016-03-21T13:12:32.000+00:00",
        "schema_name": "topic",
        "title": "Managing your charity",
        "web_url": "https://www.gov.uk/topic/running-charity/managing-charity"
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "phase": "live",
  "public_updated_at": "2013-05-22T23:00:00.000+00:00",
  "publishing_app": "whitehall",
  "rendering_app": "whitehall-frontend",
  "schema_name": "detailed_guide",
  "title": "Prepare a charity annual return",
  "updated_at": "2016-06-29T08:00:38.144Z",
  "withdrawn_notice": {}
}

```

### withdrawn_detailed_guide.json
```json
{
  "content_id": "c9e77115-22aa-45a2-8c0d-827d92462758",
  "base_path": "/guidance/eu-rules-on-the-use-of-chemicals",
  "description": "Guidance on implementing REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) in businesses.",
  "public_updated_at": "2016-02-18T15:45:44.000+00:00",
  "title": "EU rules on the use of chemicals",
  "updated_at": "2015-01-28T13:09:02Z",
  "schema_name": "detailed_guide",
  "document_type": "detailed_guide",
  "format": "detailed_guide",
  "locale": "en",
  "withdrawn_notice": {
    "explanation": "<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>",
    "withdrawn_at": "2015-01-28T13:05:30Z"
  },
  "details": {
    "body": "<div class=\"govspeak\"><h2 id=\"overview\">Overview</h2>\n\n<p><abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> entered into force on 1 June 2007 and is being implemented in stages to be completed by 1 June 2018. With over 30,000 substances on the EU market above 1 tonne per year, <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> was needed to address the issues including:</p>\n\n<ul>\n  <li>delays in assessing substances in previous regulations</li>\n  <li>increasing public concern and</li>\n  <li>very limited information available on hazards and risks to human health and the environment</li>\n</ul>\n\n<p>The main objective of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> is a high level of protection of human health and the environment, while maintaining the competitiveness and innovation of the EU chemicals industry. <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> provides a single regulatory framework for the control of chemicals, replacing the previous patchwork of controls, and ensures information on the properties of chemicals is transmitted down the supply chain, and enabling them to be safely handled.</p>\n\n<h2 id=\"next-steps-for-businesses\">Next steps for businesses</h2>\n\n<p>Now that the first phase-in registration deadline of 30 November 2010 has passed, businesses need to be careful not to relax too much, as there remains a lot to do regarding ongoing <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> implementation. </p>\n\n<p>Top of that list is the need to ensure that if you have been notified by the European Chemicals Agency (<abbr title=\"European Chemicals Agency\">ECHA</abbr>) that more information is needed for your registration, you must provide that by the deadline <abbr title=\"European Chemicals Agency\">ECHA</abbr> gives you for that, otherwise you may have to stop manufacturing or importing until you have submitted a successful registration.</p>\n\n<p>For business that have successfully registered, the focus now needs to be on communicating updates to the Safety Data Sheets (<abbr title=\"Safety Data Sheets\">SDSs</abbr>) in your supply chains, particularly including the new extended <abbr title=\"Safety Data Sheet\">SDS</abbr> with exposure scenarios.</p>\n\n<p>For businesses that have to register by 1 June 2013, don’t be fooled into thinking that you have plenty of time. </p>\n\n<p>Experience the first time around shows that preparations take much more time than initially thought, and the main thing to be concentrating on now is developing good supply chain communications between suppliers and downstream users to ensure all relevant information for registration is gathered.</p>\n\n<p>Make sure that your Substance Information Exchange Forum (<abbr title=\"Substance Information Exchange Forum\">SIEF</abbr>) is working, and there is a Lead Registrant in charge - if there isn’t consider doing that role yourself in order to get things moving quickly; it may cost you a bit more, but you certainly cannot afford to do nothing.  Your costs will pay back over the next couple of years.</p>\n\n<p>To find out more about <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> and the UK Enforcement Regime for <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> including frequently asked questions, visit the <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">UK <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Competent Authority’s website</a>.</p>\n\n<p>You can also contact the <abbr title=\"Department for Environment, Food and Rural Affairs\">Defra</abbr> <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> team by email at <a href=\"mailto:reachteam@defra.gsi.gov.uk\">reachteam@defra.gsi.gov.uk</a></p>\n\n<p><a rel=\"external\" href=\"http://www.opsi.gov.uk/si/si2008/uksi_20082852_en_1\">The <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Enforcement Regulations 2008 (SI 2008 No.2852)</a> provide for the enforcement of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> by</p>\n\n<ul>\n  <li>allocating responsibility for <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> to a number of enforcing authorities</li>\n  <li>providing these enforcing authorities with the powers they need; requiring enforcing authorities to cooperate and share information with other bodies connected to <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> enforcement and</li>\n  <li>setting the offences and penalties for contraventions of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> requirements.</li>\n</ul>\n\n<h2 id=\"animal-testing\">Animal testing</h2>\n\n<p><abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> makes it mandatory to share all existing animal test data within SIEFs, to avoid the need for duplicate tests. <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> has strong provisions to minimise the use of animal testing and the numbers of animals used in tests. The UK played a leading role in getting these provisions into the <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> legal text.</p>\n\n<p>When putting together proposals for additional testing of substances to gather missing information for substance registrations, businesses must comply with the <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> requirements on the use of animal testing.</p>\n\n<p>You can find more information on these requirements on the <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/resources/18animaltesting.pdf\">UK <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Competent Authority’s website</a>.</p>\n\n<h2 id=\"authorisation\">Authorisation</h2>\n\n<p>The first set of six substances of very high concern (<abbr title=\"substances of very high concern\">SVHC</abbr>) have now been placed on <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Annex XIV, which means that in three to four years’ time they will be banned unless authorisations to continue specific uses have been granted by the European Commission. To find out what these substances are, and more information on the <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> authorisation process, visit the <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/resources/19authorisation.pdf\">UK <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Competent Authority’s website</a>.</p>\n\n<h2 id=\"evaluation\">Evaluation</h2>\n\n<p>Now that the first registration deadline has passed, the evaluation element of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> starts to work. There are two parts to this - dossier evaluation, where testing proposals are assessed and registration dossiers are checked for compliance, and substance evaluation, where substances considered to be of concern may be further examined by Member State Competent Authorities.</p>\n\n<p>Dossier evaluation is starting now, while substance evaluation will begin in earnest in 2012.</p>\n\n<p>More information on <a rel=\"external\" href=\"http://echa.europa.eu/reach/evaluation_en.asp\">evaluation is available from the <abbr title=\"European Chemicals Agency\">ECHA</abbr> website</a>.</p>\n\n<h2 id=\"restriction\">Restriction</h2>\n\n<p>Restriction is the alternative method in <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> of controlling hazardous substances that do not fully meet the criteria for authorisation. It imposes harmonised controls on the uses of such substances across the EU, up to and including a complete ban as appropriate. Current restrictions are listed in <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Annex XVII.</p>\n\n<h3 id=\"the-uk-reach-competent-authority-steering-committee\">The UK <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Competent Authority Steering Committee</h3>\n\n<p>The Competent Authority is overseen by a Steering Committee which comprises representatives of the four responsible authorities for <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> in the UK (ie the Secretary of State for the Environment, Food, and Rural Affairs, Scottish government ministers, Welsh Assembly government ministers, and Northern Ireland ministers), and other government departments with a significant interest in the implementation of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr>.</p>\n\n<p>The Committee agrees the policies that the UK representatives put forward at EU-level <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> meetings, and also advises, supports, and holds to account the UK <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Competent Authority as it delivers its tasks.  </p>\n\n<p>Read the <span id=\"attachment_891446\" class=\"attachment-inline\">\n  <a href=\"/government/uploads/system/uploads/attachment_data/file/399112/steering-committee-tor-1007.pdf\">Competent Authority Steering Committee's terms of reference</a>\n  (<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">565KB</span>, <span class=\"page-length\">2 pages</span>)\n</span>\n and latest minutes - <span id=\"attachment_891447\" class=\"attachment-inline\">\n  <a href=\"/government/uploads/system/uploads/attachment_data/file/399113/steering-committee-minutes-110127.pdf\">Competent Authority Steering Committee: minutes, 27 January 2011</a>\n  (<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">698KB</span>, <span class=\"page-length\">10 pages</span>)\n</span></p>\n\n<p>For earlier minutes, please contact the <abbr title=\"Department for Environment, Food and Rural Affairs\">Defra</abbr> <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> team by email at <a href=\"mailto:reachteam@defra.gsi.gov.uk\">reachteam@defra.gsi.gov.uk</a>.</p>\n\n<h3 id=\"guidance-on-the-reach-processes\">Guidance on the Reach processes</h3>\n\n<p>Due to the complex nature of implementing <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> there are a series of guidance documents that are aimed to help all stakeholders with their preparation for fulfilling their obligations under the <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Regulation. These documents cover detailed guidance for a range of essential <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> process as well as for some specific scientific and/or technical methods that industry or authorities need to make use of under <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr>.</p>\n\n<p>These documents have been developed with the participation of many stakeholders: Industry, Member States and NGOs. The objective of these documents is to facilitate the implementation of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> by describing good practice on how to fulfil their obligations. Further information can be found at the <a rel=\"external\" href=\"http://guidance.echa.europa.eu/guidance_en.htm\"><abbr title=\"European Chemicals Agency\">ECHA</abbr> website</a> and at the <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/guidance.htm\">UK <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> Competent Authority’s website</a>.</p>\n\n<h3 id=\"evaluation-of-the-eu-reach-regulation\">Evaluation of the EU <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> regulation</h3>\n\n<p><abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> requires each EU Member State to report to the European Commission every five years, starting from 1 June 2010, on the operation of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> in their respective territories. Within the UK, queries on <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> operation and impacts may also come from a number of sources, such as Parliament, governments, industry, and non-governmental stakeholders.</p>\n\n<p>A study commissioned by <abbr title=\"Department for Environment, Food and Rural Affairs\">Defra</abbr> drew up a detailed list of possible indicators, likely costs, what the confounding factors may be in measuring them successfully, and thus their feasibility and suitability for reporting on <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> impacts.  <abbr title=\"Department for Environment, Food and Rural Affairs\">Defra</abbr> is now considering how best to use this information in developing a system for monitoring and evaluating the operation and impact of <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> in the UK.  A copy of the scoping study is available here.</p>\n\n<ul>\n  <li>\n    <p><span id=\"attachment_891448\" class=\"attachment-inline\">\n<a href=\"/government/uploads/system/uploads/attachment_data/file/399115/eu-reach-clp-regs-report.pdf\">Scoping study for the evaluation of EU <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> and CLP regulations final report</a>\n(<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">2.63MB</span>, <span class=\"page-length\">190 pages</span>)\n</span></p>\n  </li>\n  <li>\n    <p><span id=\"attachment_891449\" class=\"attachment-inline\">\n<a href=\"/government/uploads/system/uploads/attachment_data/file/399117/eu-reach-clp-regs-report-annexes.pdf\">Annex 1 to 4: <abbr title=\"Registration, Evaluation, Authorisation and Restriction of Chemicals\">REACH</abbr> and CLP evaluation scoping study</a>\n(<span class=\"type\"><abbr title=\"Portable Document Format\">PDF</abbr></span>, <span class=\"file-size\">1.25MB</span>, <span class=\"page-length\">108 pages</span>)\n</span></p>\n  </li>\n</ul>\n\n</div>",
    "first_public_at": "2012-09-12T10:00:00+01:00",
    "change_history": [
      {
        "public_timestamp": "2015-01-28T13:05:30Z",
        "note": "This page was archived on 28 January 2015 to remove duplication of information. The most up to date information on REACH can be found on the HSE website."
      },
      {
        "public_timestamp": "2012-09-12T10:00:00+01:00",
        "note": "First published."
      }
    ],
    "tags": {
      "browse_pages": [

      ],
      "topics": [

      ],
      "policies": [

      ]
    },
    "government": {
      "title": "2010 to 2015 Conservative and Liberal Democrat coalition government",
      "slug": "2010-to-2015-conservative-and-liberal-democrat-coalition-government",
      "current": false
    },
    "political": false,
    "emphasised_organisations": [
      "de4e9dc6-cca4-43af-a594-682023b84d6c"
    ],
    "withdrawn_notice": {
      "explanation": "<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>",
      "withdrawn_at": "2015-01-28T13:05:30Z"
    }
  },
  "links": {
    "organisations": [
      {
        "content_id": "de4e9dc6-cca4-43af-a594-682023b84d6c",
        "title": "Department for Environment, Food & Rural Affairs",
        "base_path": "/government/organisations/department-for-environment-food-rural-affairs",
        "api_url": "https://www.gov.uk/api/organisations/department-for-environment-food-rural-affairs",
        "web_url": "https://www.gov.uk/government/organisations/department-for-environment-food-rural-affairs",
        "locale": "en",
        "analytics_identifier": "D7"
      }
    ]
  }
}

```



