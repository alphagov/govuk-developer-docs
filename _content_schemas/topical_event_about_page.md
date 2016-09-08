---
layout: content_schema
title:  Topical event about page
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/topical_event_about_page/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>access_limited</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>users</strong> <code>array</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>read_more</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>body</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>topical_event_about_page</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/topical_event_about_page/publisher_v2/links.json)

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

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/topical_event_about_page/frontend/schema.json)

<table class='schema-table'><tr><td><strong>analytics_identifier</strong> <code>string</code> or <code>null</code></td> <td>A short identifier we send to Google Analytics for multi-valued fields. This means we avoid the truncated values we would get if we sent the path or slug of eg organisations.</td></tr>
<tr><td><strong>base_path</strong> <code>string</code></td> <td>A path only. Query string and/or fragment are not allowed.</td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>description</strong> <code>string</code> or <code>null</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>read_more</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>body</strong> <code>string</code></td> <td></td></tr></table></td></tr>
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
<tr><td><strong>schema_name</strong> <code>string</code></td> <td>Allowed values: <code>topical_event_about_page</code></td></tr>
<tr><td><strong>title</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_notice</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>withdrawn_at</strong> </td> <td></td></tr></table></td></tr></table>

---

## Frontend examples


### slim.json
```json
{
  "content_id": "695149c6-4b08-4cd8-b1cf-b5254955d648",
  "base_path": "/government/topical-events/battle-of-the-somme-centenary-commemorations/about",
  "title": "Battle of the Somme Centenary Commemorations",
  "description": "2016 marks the centenary of the the Battle of the Somme.",
  "details": {
    "read_more": "Read more here",
    "body": "<p>The commemoration is being lead by the Department for Culture, Media and Sport, on behalf of the UK Government, and the French Government, in partnership with Commonwealth War Graves Commission and the Royal British Legion, to build a programme of events which reflect the significance of the First World War Somme campaign</p>"
  },
  "format": "topical_event_about_page",
  "links": {
    "parent": [
      {
        "content_id": "8b19c222-54e3-4e27-b0d7-67f8e2a677c9",
        "title": "Battle of the Somme Centenary",
        "base_path": "/government/topical-events/battle-of-the-somme-centenary-commemorations",
        "api_url": "https://www.gov.uk/api/content/government/topical-events/battle-of-the-somme-centenary-commemorations",
        "web_url": "https://www.gov.uk/government/topical-events/battle-of-the-somme-centenary-commemorations",
        "locale": "en",
        "details": {}
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2016-01-26T14:19:42.460Z",
  "updated_at": "2016-01-26T14:20:42.460Z",
  "schema_name": "topical_event_about_page",
  "document_type": "topical_event_about_page"
}

```

### topical_event_about_page.json
```json
{
  "content_id": "695149c6-4b08-4cd8-b1cf-b5254955d648",
  "base_path": "/government/topical-events/ebola-virus-government-response/about",
  "title": "How the UK government is responding to Ebola",
  "description": "The government is closely monitoring the spread of the Ebola virus in West Africa, and is taking action at home and abroad.",
  "details": {
    "read_more": "See how the government worked to prevent the spread of Ebola to the UK as well as tackling the disease at source in the main countries affected.",
    "body": "<div class='govspeak'><h2 id='response-in-the-uk'>Response in the UK</h2><div class='call-to-action'><p>The risk of Ebola to the UK remains low. The virus is only transmitted by direct contact with the blood or bodily fluids of an infected person.</p><ul> <li><a rel='external' href='http://www.nhs.uk/conditions/ebola-virus/pages/ebola-virus.aspx'>Read NHS Choices information on the low risk to the UK</a></li> <li><a href='https://www.gov.uk/government/news/chief-medical-officer-sally-davies-talks-about-the-low-risk-of-ebola-in-the-uk'>Watch Chief Medical Officer Dame Sally Davies talk about the low risk to the UK.</a></li></ul></div><p>You can also read a <a rel='external' href='https://publichealthmatters.blog.gov.uk/2014/10/15/expert-interview-is-ebola-a-risk-to-the-uk'>factsheet</a> about how the disease is transmitted and what <a href='https://www.gov.uk/government/organisations/public-health-england'>Public Health England</a> is doing to protect public health in England. </p><p>The <a rel='external' href='http://wales.gov.uk/topics/health/protection/communicabledisease/ebola/?lang=en'>Welsh,</a> <a rel='external' href='http://www.hps.scot.nhs.uk/travel/publicationsdetail.aspx?id=60886'>Scottish</a> and <a rel='external' href='http://www.nidirect.gov.uk/ebola'>Northern Irish</a> government websites describe what action is being taken by the devolved administrations.</p><h3 id='the-nhs-is-prepared'>The NHS is prepared</h3><p>UK hospitals have a proven record of dealing with imported infectious diseases. We have well developed and well tested NHS systems for managing unusual infectious diseases, supported by a wide range of experts.</p><p>These include experts at the Royal Free Infectious Disease Unit, the Liverpool School of Tropical Medicine and the London School of Hygiene and Tropical Medicine.</p><h3 id='screening-at-ports'>Screening at ports</h3><p>At Heathrow and Gatwick, UK Border Force staff work with PHE to identify those registered with the ‘PHE returning workers scheme’ who may have been at higher risk of being exposed to the Ebola virus and refer them for screening. Other passengers at lower risk will be asked to self-refer for screening. </p><p>At all other ports of entry to the UK, information is collected from passengers coming from an affected country and then given to PHE for a screening risk assessment to be carried out by telephone.</p><h2 id='response-in-africa'>Response in Africa</h2><p>The UK is working with the United Nations, the World Health Organisation and the wider international community to combat Ebola at the source in the African countries affected.</p><p>Britain is playing a leading role, particularly in Sierra Leone where it can best help to fight the crisis. The <a href='https://www.gov.uk/government/speeches/ebola-outbreak-an-update-on-the-uks-response-in-west-africa'>UK has committed a £427 million package</a> of direct support to help contain, control, treat and ultimately defeat Ebola.</p><p>This is in addition to the UK’s support to international agencies like the World Bank and the UN’s Central Emergency Response Fund as well as regular cargo flights – part funded by the EU – which are carrying UK aid to Sierra Leone.</p><p>The UK’s direct support includes:</p><h3 id='medical-help-on-the-ground'>Medical help on the ground</h3><p>Support for medical agencies in West Africa – such as the Red Cross and World Health Organisation – to <a href='https://www.gov.uk/government/news/britain-to-provide-new-assistance-to-combat-ebola-in-west-africa'>provide direct care and expertise, and to train health workers</a>.</p><h3 id='deployment-of-medical-experts'>Deployment of medical experts</h3><p>Hundreds of NHS staff who have <a rel='external' href='http://immersive.sh/dfid/3yRNFJAIc'>volunteered to travel to west Africa and help those affected by Ebola</a>.</p><p>Public Health England has also deployed a team of experts including epidemiologists to provide expert advice to the Sierra Leone Ministry of Health on managing the outbreak.</p><h3 id='treatment-centres-and-beds'>Treatment centres and beds</h3><p>Supporting more than <a href='https://www.gov.uk/government/news/update-on-ebola-response'>1,400 treatment and isolation beds</a> to combat the disease, protect communities and care for patients.</p><p>This includes building 6 Ebola treatment centres across the country, all of which are now operational and treating patients. It also includes support for safe isolation spaces in those areas where they are most needed.</p><h3 id='training-frontline-workers'>Training frontline workers</h3><p>Training over 4,000 healthcare workers, logisticians and hygienists including Sierra Leonean Army and Prison staff, led by <a href='https://www.gov.uk/government/news/uk-military-to-provide-further-measures-to-tackle-ebola'>UK military personnel</a> who ran the UK-led Ebola Training Academy in Freetown.</p><h3 id='community-care-units'>Community care units</h3><p>The roll out of <a href='https://www.gov.uk/government/news/cobr-meeting-on-ebola-16-october-2014'>community care centres</a> where people who suspect they might be suffering from the disease can seek swift, accurate diagnosis and appropriate care. Crucially this will ensure that people who do have Ebola are isolated as quickly as possible to help limit the spread of the disease.</p><h3 id='safe-burials'>Safe burials</h3><p>Providing £10 million to boost the capacity of burial teams to respond quickly, supporting more than 100 teams across the country. We are also supporting charities on the ground to work with communities to develop new, safe burial practices.</p><h3 id='help-to-find-hidden-cases'>Help to find hidden cases</h3><p>The UK is backing Sierra Leone’s own <a href='https://www.gov.uk/government/news/update-on-ebola-response'>Western Area Surge</a> to track down hidden cases of Ebola through logistical support and vehicles to get around.</p><h3 id='emergency-supplies'>Emergency supplies</h3><p>Practical items such as <a href='https://www.gov.uk/government/news/britain-to-extend-assistance-to-combat-ebola-in-west-africa'>food aid, medical kit, clean blankets and chlorine for hygiene and sanitising</a>, reaching out to families cut off in quarantine.</p><h3 id='scientific-research-and-testing'>Scientific research and testing</h3><p>Emergency <a href='https://www.gov.uk/government/news/emergency-research-call-launched-to-help-combat-ebola-outbreak'>research to understand how Ebola spreads</a>, and how to stop it. Plus building, running and staffing <a href='https://www.gov.uk/government/news/new-uk-ebola-centres-and-labs-in-sierra-leone'>3 new laboratories</a> in Sierra Leone to double the number of diagnostic tests that can be carried out every day.</p><h3 id='vaccine-trials'>Vaccine trials</h3><p>Support to <a href='https://www.gov.uk/government/news/ebola-vaccine-fast-track-trials-underway'>fast-track the human trials of an Ebola vaccine</a>, that could immunise health workers and others to prevent the virus spreading further.</p><h3 id='military-support'>Military support</h3><p>The sending of <a href='https://www.gov.uk/government/news/cobr-meeting-on-ebola-8-october-2014'>750 troops to help build treatment centres, provide logistical support, engineering expertise and hands on help</a> – as well as the deployment of Naval ship RFA Argus which can carry 3 helicopters to meet crucial transportation needs.</p><h3 id='logistical-hub'>Logistical hub</h3><p>The UK will set up <a href='https://www.gov.uk/government/news/the-uk-is-leading-the-international-drive-against-ebola-in-sierra-leone'>a forward command and control logistical hub in Sierra Leone</a> that will provide the backbone of infrastructure, commodities, training and management needed to scale up the response.</p><h3 id='rapid-release-funding'>Rapid release funding</h3><p>A <a href='https://www.gov.uk/government/news/ebola-uk-support-to-protect-health-services-in-sierra-leone'>£5 million emergency fund for aid agencies working on the ground</a> and in need of financial help to prevent disease and keep treatment centres open.</p><h3 id='support-for-health-services'>Support for health services</h3><p>Financial support to <a href='https://www.gov.uk/government/news/britain-to-extend-assistance-to-combat-ebola-in-west-africa'>strengthen the country’s own health systems in Sierra Leone and Liberia</a> and to help with government coordination.</p><h3 id='improved-public-information'>Improved public information</h3><p>Help to <a href='https://www.gov.uk/government/news/britain-to-extend-assistance-to-combat-ebola-in-west-africa'>increase the awareness and understanding of the disease</a> within local and remote communities, including radio messaging programmes.</p><h3 id='international-diplomatic-efforts'>International diplomatic efforts</h3><p>Sierra Leone and the UK has <a href='https://www.gov.uk/government/news/defeating-ebola-in-sierra-leone-conference'>called on governments and international donors around the world to join up in a concerted effort</a> to contain, control and ultimately defeat the Ebola outbreak.</p><h3 id='aid-matching-uk-public-donations'>Aid matching UK public donations</h3><p>The first £5 million of public donations to the <a rel='external' href='http://www.dec.org.uk/appeals/ebola-crisis-appeal'>Disasters Emergency Committee appeal</a> on the Ebola outbreak will be matched by UK aid.</p><h3 id='help-for-businesses-to-bounce-back'>Help for businesses to bounce back</h3><p>Financial <a href='https://www.gov.uk/government/news/new-deal-to-help-businesses-bounce-back-from-ebola-in-sierra-leone'>backing for small and medium businesses</a> to help get the economy growing once more.</p><h2 id='advice-for-travellers'>Advice for travellers</h2><p>The government advises against all but essential travel to Liberia, Sierra Leone and Guinea except for those involved in the direct response to the Ebola outbreak.</p><p>Get the latest travel advice for <a href='https://www.gov.uk/foreign-travel-advice/sierra-leone'>Sierra Leone</a>, <a href='https://www.gov.uk/foreign-travel-advice/liberia'>Liberia</a> and <a href='https://www.gov.uk/foreign-travel-advice/guinea'>Guinea</a>.</p><h2 id='advice-for-medics'>Advice for medics</h2><p>Read the <a href='https://www.gov.uk/government/collections/ebola-virus-disease-clinical-management-and-guidance'>clinical management advice and guidance</a>.</p><h2 id='advice-for-aid-workers'>Advice for aid workers</h2><p>If you’re joining the emergency response, get the latest <a href='https://www.gov.uk/government/publications/ebola-virus-disease-information-for-humanitarian-aid-workers'>advice for humanitarian workers</a>.</p><h2 id='how-you-can-help'>How you can help</h2><p>The best way to help those hit by the outbreak is to donate to our partners who are helping on the ground:</p><p><a rel='external' href='http://www.redcross.org.uk/ebolavirus'>Red Cross</a></p><p><a rel='external' href='http://www.msf.org.uk/ebola'>Doctors Without Borders / Medecins Sans Frontieres</a></p><p><a rel='external' href='http://www.unicef.org.uk/landing-pages/ebola-crisis-west-africa-donate/'>UNICEF</a></p><p><a rel='external' href='http://www.savethechildren.org.uk/about-us/emergencies/ebola-crisis'>Save the Children</a></p></div>"
  },
  "format": "topical_event_about_page",
  "links": {
    "parent": [
      {
        "content_id": "8b19c222-54e3-4e27-b0d7-67f8e2a677c9",
        "title": "Ebola virus: UK government response",
        "base_path": "/government/topical-events/ebola-virus-government-response",
        "api_url": "https://www.gov.uk/api/content/government/topical-events/ebola-virus-government-response",
        "web_url": "https://www.gov.uk/government/topical-events/ebola-virus-government-response",
        "locale": "en",
        "details": {
          "start_date": "2015-03-11T00:00:00.000+00:00",
          "end_date": "2016-03-11T00:00:00.000+00:00"
        }
      }
    ]
  },
  "locale": "en",
  "need_ids": [],
  "public_updated_at": "2016-01-26T14:19:42.460Z",
  "updated_at": "2016-01-26T14:20:42.460Z",
  "schema_name": "topical_event_about_page",
  "document_type": "topical_event_about_page"
}

```



