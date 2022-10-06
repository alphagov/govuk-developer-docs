---
owner_slack: "#govuk-2ndline-tech"
title: Incorrect postcode data
parent: "/manual.html"
layout: manual_layout
section: 2nd line
---

We get our postcode data from Locations API, which uses OS Places API (Ordnance Survey) under the hood. Locations API postcodes [keep themselves up to date automatically](https://github.com/alphagov/locations-api/blob/main/docs/postcodes-added-cached-updated.md#how-postcodes-are-updated) and should never be more than about a week out of date.

In case the data is incorrect, a first step would be checking the Locations API result with the OS Places API result.

```shell
gds govuk connect --environment integration app-console locations-api
```

```ruby
# The OS Places API response
token_manager = OsPlacesApi::AccessTokenManager.new
response = HTTParty.get(
  "https://api.os.uk/search/places/v1/postcode",
  {
    query: { postcode: "E18QS", output_srs: "WGS84", "dataset": "DPA,LPI" },
    headers: { "Authorization": "Bearer #{token_manager.access_token}" },
  }

# The information we currently have in Locations API
Postcode.find_by(postcode: "E18QS").results
```

If the results are not the same (especially the Local Custodian Code), then either the user happens to have looked up the postcode in the exact week where it has been updated by OS Places API but we haven't updated our cache yet, or - more likely - our mechanism for self-updating postcodes has broken, and requires further investigation.

This is how you can manually force Locations API to update its cache for a given postcode:

```ruby
token_manager = OsPlacesApi::AccessTokenManager.new
OsPlacesApi::Client.new(token_manager).update_postcode("E18QS")

# check if the record was updated
Postcode.find_by(postcode: "E18QS").updated_at
```
