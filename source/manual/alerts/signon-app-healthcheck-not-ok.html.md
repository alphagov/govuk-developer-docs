---
owner_slack: "#govuk-2ndline"
title: Signon app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-09-11
review_in: 12 months
---

[signon]: https://signon.publishing.service.gov.uk/api_users
[deploy-puppet]: https://deploy.production.govuk.digital/job/Deploy_Puppet/
[restart-app]: /manual/restart-application.html
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[gds-api-adapters]: https://github.com/alphagov/gds-api-adapters/blob/master/lib/gds_api.rb

See also: [how healthcheck alerts work on GOV.UK](app-healthcheck-not-ok.html)

## Rotating API Tokens

One or more tokens for API Users are about to expire. You should rotate
expiring tokens to ensure the associated application keeps working.

As a working example, let's say we have an alert like *Content Publisher token
for Publishing API expires in X days*. In this example, the API User is
*Content Publisher* and the application is *Publishing API*.

- First login to [Signon], go to API Users and click on the API User.

> Check the *Last synced at* time to see if the API User is still using the
> application. If you are confident the token is unused, the you can just
> click the *Revoke* button to remove it and there's no need to continue.

- Click *Add application token*, select the application and click *Create
  access token*.
- Copy the new token and prepare to replace it in [govuk-secrets].

> How to do the last step depends on the application, but it should be
> something like `rake eyaml:edit[integration,apps]`, depending on the
> environment you're working on.

- Find a line like `govuk::apps::content_publisher::publishing_api_bearer_token...`
- Replace the long string within `GPG[xxxxxx]` with the new token.
- Make a PR with your change and once it is merged deploy the change with
  Puppet.

> Changes to govuk-secrets do not automatically trigger a Puppet deploy. One
> way to work around this is to [rebuild the last release][deploy-puppet]. You
> then need to wait for Puppet to run on each of the affected machines.

- Check the token is there with `govuk_setenv content-publisher env | grep -i token`
- Check the app can still access the remote application APIs with the new token.
- Once you're happy the new token works, you can *Revoke* the old one in Signon.

> How to check the new token works depends on the application. One way to check
> the token works is to manually open a console for the application and call
> one of the remote APIs using [gds-api-adapters][].

Finally, most applications should automatically restart when Puppet updates the
token on each machine, but you may need to [do this manually][restart-app] so
that it picks up the new token from the environment.
