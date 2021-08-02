---
owner_slack: "#govuk-2ndline"
title: Incorrect postcode data
parent: "/manual.html"
layout: manual_layout
section: 2nd line
---

We use postcode data from the ONS Postcode Directory (https://geoportal.statistics.gov.uk/search?q=ONS%20Postcode%20Directory%20(ONSPD) and Ordnance Survey for boundary
line data. We typically [import the data into Mapit](https://github.com/alphagov/mapit/blob/master/IMPORTING-DATA.md) every 6 months.

We sometimes receive Zendesk tickets about postcodes not returning the right results.
You can check the accuracy of the postcode by:

* Looking up the postcode on Mapit https://mapit.mysociety.org/postcode/<postcode>
  and have a look at the parents. There can be more than one parent which can be
  the case if the postcode sits between two boundaries
* Get the latitude/longitude and look it up on Google Maps

If the data is incorrect you can contact ONS Geography ons.geography@ons.gov.uk
and ask them to correct the data for the next postcode release.
