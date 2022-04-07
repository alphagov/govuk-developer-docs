---
owner_slack: "#govuk-2ndline-tech"
title: Restart an application
parent: "/manual.html"
layout: manual_layout
section: Deployment
---

### Restarting one instance of an app

To restart an application on one machine, SSH into the machine then
run:

```bash
sudo service <app> restart
```

This will terminate any active requests to that instance of the app,
and so may cause a few errors.  Other instances of the app on
different machines will not restart.

### Restarting all instances of an app

To restart an application on all machines:

1. Go to the [Deploy_App Jenkins job][]
   - For `TARGET_APPLICATION`, choose the app to restart
   - For `DEPLOY_TASK`, choose `deploy:with_hard_restart`
   - For `TAG`, choose the [current release][]
2. Click "Build"

All the instances of the app will restart at roughly the same time, so
any pages served by the app will be briefly unavailable, and there
will be a spike of 5xx errors.

[Deploy_App Jenkins job]: https://deploy.blue.production.govuk.digital/job/Deploy_App/build
[current release]:https://release.publishing.service.gov.uk/applications
