---
owner_slack: "#govuk-2ndline-tech"
title: Expiring API tokens in Signon
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# Expiring API tokens in Signon

[signon]: https://signon.publishing.service.gov.uk/api_users
[deploy-puppet]: https://deploy.production.govuk.digital/job/Deploy_Puppet/
[restart-app]: /manual/restart-application.html
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[gds-api-adapters]: https://github.com/alphagov/gds-api-adapters/blob/master/lib/gds_api.rb

One or more tokens for API Users are about to expire. You should rotate
expiring tokens to ensure the associated application keeps working.

> If the tokens are
> `New London: Trade Tariff Admin (PaaS) token for New London: Trade Tariff Backend (PaaS)`
> see [Trade Tariff Admin on the Wiki](https://gov-uk.atlassian.net/wiki/spaces/PLOPS/pages/3155099649/Trade+Tariff+Admin)

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
> something like `rake 'eyaml:edit[integration,apps]'` within the `puppet_aws` directory, depending on the
> environment you're working on. Some tokens are not configured in the 'app' namespace - for these
> run `rake 'eyaml:edit[integration]'`

- Find a line like `govuk::apps::content_publisher::publishing_api_bearer_token...`. To find the relevant line, it may be useful to search for the first few characters shown of the existing token on signon.
- Replace the long string within `GPG[xxxxxx]` with the new token.
- Make a PR with your change and once it is merged deploy the change with
  Puppet.

> Changes to govuk-secrets do not automatically trigger a Puppet deploy. One
> way to work around this is to [rebuild the last release][deploy-puppet] in the appropriate
> environment. You then need to wait for Puppet to run on each of the affected machines.

- Once puppet has been deployed you can check the new token is there by sshing into a machine and running a command such as `govuk_setenv content-publisher env | grep -i TOKEN_YOU_ARE_ROTATING`
- Check the app can still access the remote application APIs with the new token.
- Check the new token works (see below)
- If all this has been done, and puppet has been run on all the machines, you can *Revoke* the old token in Signon.

> How to check the new token works depends on the application. One way to check
> the token works is to manually open a console for the application and call
> one of the remote APIs using [gds-api-adapters][].
>
> For example, to open a console you can run
>
> `gds govuk connect -e integration app-console content-data-api`
>
> The api call could be something like
>
> `gds_api = GdsApi::Router.new(Plek.new.find("router-api"), bearer_token: ENV["ROUTER_API_BEARER_TOKEN"])`
>
> `gds_api.get_route("/foo")`
>
> If the token works, then the above should get us something other than an unauthorised error.
> You could test this out by setting up `gds_api` with an incorrect token, e.g. `bearer_token: "NOT_THE_REAL_TOKEN"`
> and checking that this gives a different response to when it is set up with the new token.

Finally, most applications should automatically restart when Puppet updates the
token on each machine, but you may need to [do this manually][restart-app] so
that it picks up the new token from the environment.
