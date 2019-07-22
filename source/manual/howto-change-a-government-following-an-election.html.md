---
owner_slack: "#govuk-2ndline"
title: Change a government following a general election
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-12
review_in: 6 months
---

### Change a government in Whitehall

Following a general election or other reason for governmental change
the current Government in Whitehall will need to be closed, and a new
one created.

#### Closing a government

Governments are listed at the [government path of Whitehall Admin][].

[government path of Whitehall Admin]: https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/governments

1. Select the current government, and click the `Prepare to close this
   government` link.
2. Close the government.

This will close the current government and remove all [ministerial
appointments][]. Changes will instantly appear on the live site.

The Content Support team will be able to re-assign ministers once the
new government has been opened.

[ministerial appointments]: https://www.integration.publishing.service.gov.uk/government/ministers

#### Open a new government

[Create a new government](https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/governments/new)

This will instantly create a new government. Changes can be seen in
the Rails console by running `Government.current`.

The new government should also instantly appear in the response from
[/api/governments][].

[/api/governments]: https://www.integration.publishing.service.gov.uk/api/governments

#### Applying a banner to political content published by the previous government

Content in Whitehall can be marked as political. Political content
which was published under a previous government is
[historic?][historic]. This is highlighted on the page, and in search
results. See these pages for example.

[A content page](https://www.gov.uk/government/speeches/the-issuing-withdrawal-or-refusal-of-passports)
[A search results page](https://www.gov.uk/search/all?keywords=The+issuing%2C+withdrawal+or+refusal+of+passports&order=relevance)

[historic]: https://github.com/alphagov/whitehall/blob/e518218355d158bfff036a02e312dda714da0aa6/app/models/edition.rb#L647

Marking content as political can happen automatically through the
[PoliticalContentIdentifier][]. The `political` flag on an `Edition`
can also be set manually.

[PoliticalContentIdentifier]: https://github.com/alphagov/whitehall/blob/master/lib/political_content_identifier.rb

##### Updating newly historic content

There is a Rake task to republish all political content and ensure
these banners are applied for political content which is now
associated with a previous government..

[election:republish_political_content](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=election:republish_political_content)

In Integration, this will republish around 92,000 documents. The
Publishing API may take between 4 and 6 hours to process these.

Grafana monitoring for
* [Publishing API](https://grafana.integration.publishing.service.gov.uk/dashboard/file/publishing-api.json?refresh=5s&orgId=1&from=now-6h&to=now)
* [Sidekiq](https://grafana.integration.publishing.service.gov.uk/dashboard/file/sidekiq.json?refresh=1m&orgId=1&from=now-6h&to=now&var-Application=whitehall&var-Queues=All)

This may trigger Icinga alerts for the publishing-api
* [Established connections for publishing-api exceeds 8](https://graphite.integration.govuk.digital/render/?width=1000&height=600&colorList=red,orange,blue,green,purple,brown&target=alias%28dashed%28constantLine%2810%29%29,%22critical%22%29&target=alias%28dashed%28constantLine%288%29%29,%22warning%22%29&target=publishing_api-ip-10-1-4-39_eu-west-1_compute_internal.tcpconns-3093-local.tcp_connections-ESTABLISHED)
* [high load on](https://grafana.integration.govuk.digital/dashboard/file/machine.json?refresh=1m&orgId=1&var-hostname=publishing_api-ip-10-1-4-39_eu-west-1_compute_internal)
