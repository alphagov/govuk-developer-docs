---
owner_slack: "#govuk-2ndline-tech"
title: Signon API User Token Expires Soon
parent: "/manual.html"
layout: manual_layout
section: Alertmanager alerts
---

[signon]: https://signon.publishing.service.gov.uk/api_users
[gds-api-adapters]: https://github.com/alphagov/gds-api-adapters/blob/master/lib/gds_api.rb

One or more tokens for API Users are about to expire. You should rotate
expiring tokens to ensure the associated application keeps working.

- First login to [Signon], go to API Users and click on the appropriate API User.

> Check the *Last synced at* time to see if the API User is still using the
> application. If you are confident the token is unused, the you can just
> click the *Revoke* button to remove it and there's no need to continue.

- Click *Add application token*, select the application and click *Create
  access token*.

- At this point the new token is created, and will be picked up automatically by a job that runs once a day (around 1am) to sync tokens to the applications in Kubernetes. If you want to check that the token has been updated, you can wait until the next day and query the app: `kubectl -n apps exec -it deploy/<your-app-name> -- printenv | grep BEARER_TOKEN`, then find the relevant token in the output and compare the first and last 8 characters with the hidden token shown in Signon.

## Updating the tokens immediately

If the tokens have actually expired, or need to be rotated immediately in an emergency, you won't want to wait for the daily sync. You can request it to run immediately:

- `kubectl create job --from cronjob/signon-sync-token-secrets-to-k8s signon-token-sync-$USER`
- You will then need to restart the relevant app to pick up the new token: `k rollout restart deploy/<your-app-name>`

At this point you can check that the app has the new token as above.

## Revoke the old token

Once the new token is in place, you should check that it can be used:

> How to check the new token works depends on the application. One way to check
> the token works is to manually open a console for the application and call
> one of the remote APIs using [gds-api-adapters][].
>
> For example, to open a console you can run
>
> `kubectl -n apps exec -it deploy/<your-app-name> -- rails c`
>
> The api call could be something like (example here with Publishing API)
>
> `gds_api = GdsApi::PublisingApi.new(Plek.new.find("publishing-api"), bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"])`
>
> `gds_api.lookup_content_id(base_path: "/")`
>
> If the token works, then the above should get us something other than an unauthorised error.
> You could test this out by setting up `gds_api` with an incorrect token, e.g. `bearer_token: "NOT_THE_REAL_TOKEN"`
> and checking that this gives a different response to when it is set up with the new token.

Once you've confirmed that the new token can be used, go back to [Signon] and revoke the old token.

## Special Cases

If the tokens are for `New London: Trade Tariff Admin (PaaS) token for New London: Trade Tariff Backend (PaaS)` see [Trade Tariff Admin on the Wiki](https://gov-uk.atlassian.net/wiki/spaces/PLOPS/pages/3155099649/Trade+Tariff+Admin)

If the tokens are for the `Signon API Client (permission and suspension updater)` you should contact the permissions team.
