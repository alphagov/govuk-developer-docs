---
owner_slack: "#govuk-2ndline-tech"
title: Rotate Fastly API Keys for Emergency Alerts
section: Emergency Alerts
layout: manual_layout
parent: "/manual.html"
---

The GOV.UK Emergency Alerts team will occasionally request GOV.UK's help rotating some Fastly API keys which they use to purge Emergency Alerts
pages from the Fastly cache.

The process should be roughly:

* Sign in to Fastly using the Emergency Alerts account [(credentials in govuk-secrets)](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/fastly/notify_emergency_alerts_account.gpg) (private repository)
* Visit [Account / Personal API tokens](https://manage.fastly.com/account/personal/tokens) in Fastly
* Search for "GOV.UK Emergency Alerts /alerts" to find the current keys
* Click Create Token
* Re-enter the account password
* Name the token using the pattern `GOV.UK Emergency Alerts /alerts $ENVIRONMENT $YEAR`
* Choose the specific service `$ENVIRONMENT GOV.UK`
* Select only purge select as the Scope
* Select "Never expire" for the expiration

![Screenshot of the Fastly user interface for configuring an API key](/manual/images/fastly-api-key-emergency-alerts.png)

* Copy the token value and [send it to the Emergency Alerts team member securely](https://docs.publishing.service.gov.uk/manual/send-secret-using-gcp.html).
* Repeat for each environment requested. (You may wish to send all of the tokens across in one go, to save on the overhead).
* Once the Emergency Alerts team have confirmed that the new API keys are working (see below), you should delete the old keys via the Fastly UI.

The Emergency Alerts team member will then:

* Log into the relevant AWS environment (preview, staging, production) and update the relevant `fastly-api-key` in Parameter Store within AWS Systems Manager
* Log into the AWS ECS console and navigate to the service eas-app-govuk-alerts within the eas-app-cluster
* Stop the running task within the eas-app-govuk-alerts dwiserviceapp. (That should then be restarted and will pull in the new credentials).
* Test the relevant key is working correctly by rebuilding the public alerts site for that environment. (It will automatically rebuild after the container app restarts).
