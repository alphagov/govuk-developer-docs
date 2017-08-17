---
owner_slack: '#2ndline'
title: Monitor sidekiq queues for your application
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-06-28
review_in: 6 months
---

[Sidekiq] comes with a web application, [`Sidekiq::Web`](https://github.com/mperham/sidekiq/wiki/Monitoring) that can display the current state of a [Sidekiq] installation. We have [configured this](https://github.com/alphagov/sidekiq-monitoring) to monitor multiple [Sidekiq] configurations used throughout [GOV.UK].

We have restricted public access as the Web UI allows modifying the state of [Sidekiq] queues.

To gain access you should setup SSH port forwarding to a backend box belonging to the environment you wish to monitor when connected to the Bardeen wireless network or the VPN:

```bash
$ ssh backend-1.backend.integration -CNL 9000:127.0.0.1:80
```

Then visit [http://127.0.0.1:9000](http://127.0.0.1:9000) to see a list of [Sidekiq] configurations you can monitor.

You can also monitor Sidekiq queue lengths using [this Grafana dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/sidekiq.json).

To view your local Sidekiq queue, go to the [sidekiq-monitoring app](https://github.com/alphagov/sidekiq-monitoring) in the vm and run `./bin/foreman start` for all applications, or `./bin/foreman run <app_name>` for a specific app. In the output of sidekiq-monitoring, you'll find the port number of the app whose queue you want to view. Make a note of it, then in your local machine, go to govuk-puppet/development-vm and run:

```bash
$ vagrant ssh  -- -CNL <port_number>:localhost:<port_number>
```

Then visit `http://localhost:<port_number>/<app_name>` to see a list of Sidekiq configurations you can monitor.

See also: [Add sidekiq-monitoring to your application](setting-up-new-sidekiq-monitoring-app.html).

[gov.uk]: https://www.gov.uk/
[sidekiq]: http://sidekiq.org/
