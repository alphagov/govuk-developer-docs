---
owner_slack: "#govuk-2ndline"
title: 'Use Fabric scripts for one-off tasks'
section: Deployment
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-01-31
review_in: 6 months
---

<https://github.com/alphagov/fabric-scripts/>

The Fabric scripts are useful for running something on a set of machines. For instance, to restart all instances of the content store on backend boxes:

`fab $environment class:backend app.reload:content-store`

Check the `app.py` class for different methods you can use. To run more specific commands you can run the following (`sdo` for sudo):

`fab $environment class:backend sdo:"service content-store reload"`

For more information, check out the [Fabric scripts README](https://github.com/alphagov/fabric-scripts#readme>).
