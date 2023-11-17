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

* Click Create Token
* Using the GPG ID of the Emergency Alerts team you got before `gpg --armor --encrypt --recipient '<public key id>'` then paste in the new token (or tokens) and press CTRL-D
* Send the generated PGP MESSAGE to the Emergency Alerts team member
* That team member can then log into the relevant AWS environment (preview, staging, production) and update the relevant `fastly-api-key` in Parameter Store within AWS Systems Manager
* Emergency Alerts team should log into the AWS ECS console and navigate to the service eas-app-govuk-alerts within the eas-app-cluster
* Emergency Alerts team can then stop the running task within the eas-app-govuk-alerts dwiserviceapp.  That should then be restarted and will pull in the new credentials
* Emergency Alerts team should then test the relevant key is working correctly by rebuilding the public alerts site for that environment (it will automatically rebuild after the container app restarts)
* Once the Emergency Alerts team have confirmed that they have deployed the new API keys and they are working, use the Fastly user interface to delete the old keys
