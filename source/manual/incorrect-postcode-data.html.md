---
owner_slack: "#govuk-web-support"
title: Incorrect postcode data
parent: "/manual.html"
layout: manual_layout
section: Applications
---

We get our postcode data from Locations API, which uses OS Places API (Ordnance Survey) and the ONS Postcode Directory (Office for National Statistics) under the hood:

- OS Places Api: This is a detailed dataset, including individual addresses, local custodian codes (ie mapping to councils), and supports split postcodes. These records [keep themselves up to date automatically](https://github.com/alphagov/locations-api/blob/main/docs/postcodes-added-cached-updated.md#how-postcodes-are-updated) and should never be more than about a week out of date
- ONS Postcode Directory: This is a less detailed data set, which cannot map to a council (it only has a lat/long for postcodes), but also includes retired postcodes and large user postcodes. These records are [downloaded by an automated task](https://github.com/alphagov/locations-api/blob/main/docs/updating-ons-postcode-data.md) when an update is spotted in their RSS feed. It's refreshed roughly 2-3 times a year.

In case the data is incorrect, a first step would be checking the Locations API result with the OS Places API result.

```shell
kubectl -n apps exec -it deploy/locations-api -- rails c
```

```ruby
# The OS Places API response
client = OsPlacesApi::Client.new(OsPlacesApi::AccessTokenManager.new)
client.retrieve_locations_for_postcode("E18QS").results

# The information we currently have in Locations API
Postcode.find_by(postcode: "E18QS").results
```

### If OS Places API returns results

If the results are not the same (especially the Local Custodian Codes in the addresses), then either the user happens to have looked up the postcode in the exact week where it has been updated by OS Places API but we haven't updated our cache yet, or - more likely - our mechanism for self-updating postcodes has broken, and requires further investigation.

This is how you can manually force Locations API to update its cache for a given postcode:

```ruby
PostcodeManager.new.update_postcode("E18QS")

# check if the record was updated
Postcode.find_by(postcode: "E18QS").updated_at
```

### If OS Places API doesn't results, but there is a record

This is likely a case in which the returned results are from the ONS Postcode Directory. This is a lower-quality set of data for our purposes (it doesn't contain Local Custodian Codes, so can't be used for postcode matchers that need to find a council). You can check if the postcode is indeed an ONSPD record, and if so if it's retired or a Large User Postcode like this:

```ruby
Postcode.find_by(postcode: "E18QS").onspd?
Postcode.find_by(postcode: "E18QS").retired?
Postcode.find_by(postcode: "E18QS").large_user_postcode?
```

If a postcode is a Large User Postcode, it can't be used for council-type finders, and currently retired postcodes aren't detected.
