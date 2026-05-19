---
owner_slack: "#govuk-search"
title: "Increase logging to debug site search"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
related_repos: [search-api-v2]
---
[link-1]: https://github.com/alphagov/govuk-docker/blob/main/projects/search-api-v2/docker-compose.yml#L49
[link-2]: https://github.com/googleapis/google-cloud-ruby/tree/main/google-cloud-discovery_engine#debug-logging

## Increase logging in `search-api-v2` locally

When making search requests to `search-api-v2`, the default level of logging allows developers to view
a limited amount of data sent to and from Discovery Engine. To debug issues, it can be useful to increase this level of
logging to view more detail in the request and response payloads.

To do this, set the environment variable `GOOGLE_SDK_RUBY_LOGGING_GEMS` to the value `all`. This can be done in `govuk-docker`,
[inside the relevant search-stack][link-1], before running the application locally.

See [Google Cloud docs][link-2] for more information.

## Increase logging in Google Cloud Platform

GCP Logs Explorer is the primary interface in Google Cloud for viewing, searching, and analyzing log data. It is a very
useful tool for troubleshooting issues and identifying errors. However, Search requests are categorized as Data Access
audit logs, which are disabled by default due to the high volume and potential cost of logging every single query.

To see Search requests in Logs Explorer, you need to manually enable Data Access logs for the Discovery Engine API by
following these steps in the Google Cloud Console:

- Go to the IAM & Admin > Audit Logs page.
- In the filter/search bar, type Discovery Engine to find the service.
- Check the box for the "Cloud Discovery Engine API".
- In the info panel on the right, select the Data Read and Data Write tabs and check the boxes to enable them.
- Click Save.

> Remember to revert these permissions once you have finished debugging, to avoid increased costs associated with the
additional logging.
