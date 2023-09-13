---
owner_slack: "#govuk-2ndline-tech"
title: Rotate Fastly API Keys for Emergency Alerts
section: Emergency Alerts
layout: manual_layout
parent: "/manual.html"
---

The Emergency Alerts team (formerly Notify) will occasionally request GOV.UK's help rotating some Fastly API keys which they use to purge Emergency Alerts
pages from the Fastly cache.

The process should be roughly:

* Make sure you can clone [Notify's secrets repository](https://github.com/alphagov/notifications-credentials/) (it's private, so you may need to be added)
* Sign in to Fastly using the Emergency Alerts account [(credentials in govuk-secrets)](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/fastly/notify_emergency_alerts_account.gpg) (private repository)
* Visit [Account / Personal API tokens](https://manage.fastly.com/account/personal/tokens) in Fastly
* Search for "/alerts" to find the current keys, ready to delete later (see end of doc)
* Click Create Token
* Re-enter the account password
* Name the token using the pattern `GOV.UK Emergency Alerts /alerts $ENVIRONMENT $YEAR`
* Choose the specific service `$ENVIRONMENT GOV.UK`
* Select only purge select as the Scope
* Select "Never expire" for the expiration

![Screenshot of the Fastly user interface for configuring an API key](/manual/images/fastly-api-key-emergency-alerts.png)

* Click Create Token
* From the notifications-credentials repository, run `PASSWORD_STORE_DIR=$(pwd) pass insert credentials/fastly/${ENVIRONMENT}/api_key` to encrypt the api_key for the Emergency Alerts team
* Once you've updated the API keys for all the environments, raise a PR [like this original PR](https://github.com/alphagov/notifications-credentials/pull/213) with the Emergency Alerts team
* Once the Emergency Alerts team have confirmed that they have deployed the new API keys no longer need the old keys, use the Fastly user interface to delete the old keys
