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

Following a general election or other reason for governmental change the current Government in Whitehall will need to be closed, and a new one created.

#### Closing a government

Government's are listed at the [government path of Whitehall Admin](https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/governments).

1. Select the current government, and click the `Prepare to close this government` link.
2. Close the government.

This will close the current government and remove all [ministerial appointments](https://www.integration.publishing.service.gov.uk/government/ministers). Changes will instantly appear on the live site.

The Content Support team will be able to re-assign ministers once the new government has been opened.

#### Open a new government

[Create a new government](https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/governments/new)

This will instantly create a new government. Changes can be seen in the Rails console by running `Government.current`.

The new government should also instantly appear in the response from [/api/governments](https://www.integration.publishing.service.gov.uk/api/governments).

#### Republishing Political Content

Political Content is encapsulated by Whitehall's [PoliticalContentIdentifier](https://github.com/alphagov/whitehall/blob/master/lib/political_content_identifier.rb). You can identify a piece of political content by calling `PoliticalContentIdentifier.political?(edition)`.

Any political content published under a closed government is [historic](https://github.com/alphagov/whitehall/blob/e518218355d158bfff036a02e312dda714da0aa6/app/models/edition.rb#L647).

`historical` political content is given an explanatory banner on both the [content page](https://www.gov.uk/government/speeches/the-issuing-withdrawal-or-refusal-of-passports) and [search results](https://www.gov.uk/search/all?keywords=The+issuing%2C+withdrawal+or+refusal+of+passports&order=relevance).

There is a Rake task to republish all political content and ensure these banners are applied.

[election:republish_political_content](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=election:republish_political_content)

In Integration, this will republish around 92,000 documents.

The Publishing-API may take between 4 and 6 hours to process these. Currently they are running on the high-queues, and block any other publishing activity.

Grafana monitoring for
* [Publishing API](https://grafana.integration.publishing.service.gov.uk/dashboard/file/publishing-api.json?refresh=5s&orgId=1&from=now-6h&to=now)
* [SideKiq](https://grafana.integration.publishing.service.gov.uk/dashboard/file/sidekiq.json?refresh=1m&orgId=1&from=now-6h&to=now&var-Application=whitehall&var-Queues=All)
