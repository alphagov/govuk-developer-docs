---
owner_slack: '#2ndline'
title: Monitor sidekiq queues for your application
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_at: 2017-04-28
review_in: 6 months
---

# Monitor sidekiq queues for your application

Sidekiq [monitoring applications](https://github.com/mperham/sidekiq/wiki/Monitoring) are sinatra applications that ship with the [sidekiq gem](http://sidekiq.org/). We have configured these to run as [standalone](https://github.com/mperham/sidekiq/wiki/Monitoring#standalone) apps on our backend machines.

An nginx vhost called `sidekiq-monitoring` hosts each of these standalone apps at various locations. For example, Whitehall's sidekiq monitoring app on integration is available at `sidekiq-monitoring.integration.publishing.service.gov.uk/whitehall`.

These vhost are blocked for public access, as they allow modifying the state of sidekiq queues. You can setup ssh port forwarding to access these apps. To access sidekiq monitoring apps running on integration:

* on the command line enter: `ssh backend-1.backend.integration -CNL 9000:127.0.0.1:80`
* open [http://127.0.0.1:9000](http://127.0.0.1:9000)

Also see [how to set up](setting-up-new-sidekiq-monitoring-app.html) sidekiq monitoring for your app
