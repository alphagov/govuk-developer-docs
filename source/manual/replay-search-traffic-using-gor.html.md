---
owner_slack: "#govuk-search"
title: Replay Search Traffic using GoReplay
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
related_repos: [search-api, search-api-v2]
---

Sometimes we need to replay `production` traffic to `integration`, to test code changes.

This is done by exporting logs from kibana, reformatting them to `.gor` format, and then running them against `integration` using [GoReplay](https://goreplay.org/docs/).

Both search-api and search-api-v2 have a rake task `traffic_replay:format_logs` and a `KibanaLogFormatter` class so that traffic replay can be done with minimal set-up.

## Preparation Steps

### Download Search Traffic from Kibana

- Run query in Kibana to get search traffic received by `router`
  - Ensure that your data includes columns `@timestamp`, `logjson.request_uri` & `message`
- Export data as csv
  - Note that a maximum of 10,000 of rows can be exported to csv in one go
- Format column names
  - Change column name from `logjson\.request_uri` to `request_uri`
  - Change column name from `@timestamp` to `timestamp`
- Order csv file by `timestamp` (ascending)

### Reformat Search Traffic to `.gor` format

Format search traffic data csv into gor using `traffic_replay:format_logs` rake task

- Save the csv file locally to `/tmp` in search-api or search-api-v2 as required
- Reformat file to `.gor` format. From the repo folder locally run:
  - `bundle exec rake traffic_replay:format_logs\[tmp/<search-traffic-file>.csv\]`

### Prepare file permissions

- Remove extended attributes from the `.gor` file. From a terminal (not within Rubymine) run:
  - `xattr -d com.apple.provenance <gor_traffic_file>`
- Correct file permissions for the gor file:
  - `chmod 640 <gor_traffic_file>`

## Traffic Replay

### Use GoReplay to Replay Search Traffic to Integration

- Install GoReplay locally
  - `brew install gor`
- Replay the data to integration using GoReplay
  - `gor --input-file <gor_traffic_file> --output-http 'https://www.integration.publishing.service.gov.uk' --http-set-header 'User-Agent: Gor' --http-set-header 'Accept: application/json'`

> Note that GoReplay will replay the traffic at the rate it was recorded.
>
> See [Rate Limit or Quota Issues](#rate-limit-or-quota-issues) for guidance on how to vary the rate of replay.

### Check Search Traffic Received on Integration

Check kibana logs for integration to see if search traffic received.

- Filter for `User-agent: Gor`
  - Note that requests will not have a user agent of Gor by the time they hit `search-api` or `search-api-v2`, but you should be able to see requests from user agent Gor coming through to `finder-frontend` and `router`.
- Search on a `logjson.govuk_request_id` of a request with `User-agent: Gor` to see it flow through to `search-api` or `search-api-v2`, as applicable.

## Troubleshooting

### Rate Limit or Quota Issues

If you hit the integration rate limit or Google Cloud quota `Regional search requests. per minute per regional_location` you may need to slow the rate of replay.

```
# 0.25x original timing
gor --input-file "requests.gor|25%" --output-http="http://staging.example.com"

# cap the target at 50 rps
gor --input-file "requests.gor|25%" --output-http="http://staging.example.com|50"
```
