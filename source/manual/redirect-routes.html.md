---
owner_slack: "#govuk-developers"
title: Redirect a route
section: Routing
layout: manual_layout
parent: "/manual.html"
related_repos: [short-url-manager]
---

There are a number of different ways of applying redirects on GOV.UK.
Here is a guide for choosing the right one:

- Is the redirect a short URL, such as `gov.uk/dfe`?
  [Use Short URL Manager][short-url-manager-section].
- Are you redirecting a HMRC manual?
  Read the [HMRC section][hmrc-manuals-section].
- Are you redirecting from a campaign site?
  Read the [campaign sites section][campaign-sites-section].

That covers the service-specific redirects. We then have several options
for applying redirects to most GOV.UK content:

- Is the redirect correctly showing in Publishing API, but not in Content Store?
  Try [re-presenting the content item downstream][represent-content-item-section].
- Does the redirect not exist anywhere yet?
  You'll need to [apply a redirect from within the relevant publishing app][apply-redirect-from-publishing-app-section].

## Manually apply a redirect from any publishing app

[apply-redirect-from-publishing-app-section]: #manually-apply-a-redirect-from-any-publishing-app

The preferred method of creating redirects is to use the publishing app that
originally published the content to set up the redirect.

Once you've established [which app owns the route][find-owning-app],
you should see if it is possible to set up the redirect from within the app
UI itself. This usually involves unpublishing the content, whereupon the app
gives the option to redirect the old route to another route. This approach
is preferred as it keeps the workflow and publishing history within the app,
as well as correctly propagating the changes through Publishing API and
Content Store.

Not all applications support unpublishing / setting redirects. In these
cases, you'll need to interact with Publishing API manually - see below.

> Note that this won't work if the thing you're redirecting originates from
> the Short URL Manager: there's [a rake task][short-url-manager-section-remove-route]
> for that.

You'll need to get the content ID of the current thing that exists at the
route you want to redirect from. This is generally just a case of visiting
the route prefixed with `/api/content` to expose its Content Store
information.

You may want to log into the Content Store app console in another shell:

`$ gds govuk connect app-console -e production content_store/content-store`

In the Content Store console, run
`content_item = ContentItem.find_by(content_id: "CONTENT_ID")` to get a
handle on the current state of the content item. Make sure content item
already has a `document_type` of `redirect` and the `redirects` property
has the `path` and `destination` properties.
If your content item doesn't have a redirect in Content Store, but you
know a redirect has been applied in Publishing API, you may need to
[re-present the edition in Publishing API][represent-content-item-section].

Assuming the redirect doesn't exist yet, and you know no attempt has been
made to redirect the item in Publishing API, your next step is to open a
console on the publishing app in question. Then run this command:

```ruby
GdsApi.publishing_api.unpublish(
  content_id,
  type: "redirect",
  explanation: "manually redirected by YOUR_NAME",
  alternative_path: "/new-path",
  discard_drafts: true
)
```

You should see a 200 response:

```
#<GdsApi::Response:0x00007f81feba4c30 @http_response=<RestClient::Response 200 "{\"content_i...">, @web_urls_relative_to=nil>
```

And you will see that the content item in the Content Store
console has been updated, if you run `content_item.reload` in
your other console.

When Content Store is updated with a new route, it should be updated in Router.
You should now be redirected when you visit the route in your browser.

### Manually re-present the content item in Publishing API

[represent-content-item-section]: #manually-re-present-the-content-item-in-publishing-api

Sometimes, Publishing API and Content Store can end up out of sync
with one another, whereby a redirect has been applied to a content
item in Publishing API but hasn't been successfully processed by
Content Store. In these cases, there are several
[rake tasks](https://github.com/alphagov/publishing-api/blob/main/lib/tasks/represent_downstream.rake)
we can use to re-present the content item from Publishing API to
Content Store.

First, you'll need the content ID of the content item. Here we have
a Publishing API console and we've retrieved the Unpublishing record
(which has the redirect information) for the content item. We find
its associated content ID and can then use this in one of the linked
rake tasks.

```
unpublishing = Unpublishing.find_by(alternative_path: "/foo")

unpublishing.edition.content_id
=> "ddcab6e2-8985-4646-9f3d-82d2f4770186"
```

## Find out which app owns the route

[find-owning-app]: #find-out-which-app-owns-the-route

Open a Content Store console:

```console
$ gds govuk connect app-console -e production content_store/content-store
```

Then search for the incoming path you are interested in:

```console
ContentItem.find_by(base_path: "/path-to-item").publishing_app
```

## Redirect using the Short URL Manager

[short-url-manager-section]: #redirect-using-the-short-url-manager

If the redirect is from a URL that is not a currently-published content item,
you should first look to use the [Short URL Manager][short-url-manager] to
create a redirect request. Requests are checked and approved by content
designers, after which they are made live.

Redirects created in Short URL Manager are published via the Publishing API.

Specific Signon [permissions][short-url-manager-permissions] are required to
make and approve redirect requests through the Short URL Manager. Additionally,
there is a `advanced_options` permission which enables creating redirects for
pages that are already owned by other apps, creating `prefix` type redirects,
and using non-default values for the `segments_mode`.

[short-url-manager]: https://short-url-manager.publishing.service.gov.uk
[short-url-manager-permissions]: https://github.com/alphagov/short-url-manager/#permissions

### Removing a route created in the Short URL Manager

[short-url-manager-section-remove-route]: #removing-a-route-created-in-the-short-url-manager

A Short URL route can be deleted from the `View short URL request` view in the UI of Short URL Manager.

Once the redirect is removed, the page will return a [410 Gone status](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/410).

### Removing a route completely so it can be replaced with another route

Removing a route in the previous section returns a 410 Gone status - this means that the URL can not be reused by another publication as the route is still being used.

To completely remove a route requires using the Rails console for several different apps using EKS.

If you have not accessed the cluster before, you will need to follow [the set up instructions](/kubernetes/get-started/set-up-tools/) first.

To access an app's Rails console you’ll need to set your region and context as below (swapping out the environment as appropriate):

```bash
export AWS_REGION=eu-west-1
eval $(gds aws govuk-integration-developer -e --art 8h)
kubectl config use-context <your-context-name>
```

You can then access an app's Rails console using the following command:

```bash
kubectl exec -n apps -it deploy/<app-name> -- rails c
```

Removing the route, we need to know the slug that should be deleted. These examples use `/example-path`.

In `publishing-api`, delete the reservation that makes sure that the route can't be used by any other app:

```ruby
PathReservation.find_by(base_path: "/example-path").delete
```

In `content-store` _and_ `draft-content-store`, remove the content item that used to inhabit the URL:

```ruby
ContentItem.find_by(base_path: "/example-path").delete
```

You should now be able to replace the route with another one.
For documents published in Mainstream Publisher, update and republish the content that should now sit at `/example-path`.

(In Mainstream Publisher the edition id can be found at the end of the URL. For example, the edition found at publisher.publishing.service.gov.uk/editions/<mark>5fb53d8fd3bf7f626687198c</mark> has the edition id `5fb53d8fd3bf7f626687198c`.)

```ruby
edition = Edition.find("<edition id>")

UpdateWorker.perform_async(edition.id.to_s)

RepublishWorker.perform_async(edition.id.to_s)
```

For documents published in other publishing apps that are not Mainstream Publisher, the instructions will differ.

The final step is to [clear the cache for the routes](/manual/purge-cache.html).

## Redirects for HMRC manuals

[hmrc-manuals-section]: #redirects-for-hmrc-manuals

There are rake tasks for redirecting HMRC manuals and HMRC manual sections, which can be [found in the hmrc-manuals-api repo](https://github.com/alphagov/hmrc-manuals-api/tree/main/lib/tasks).

An example of redirecting a HMRC manual section to another section would be to run `redirect_hmrc_section[original-parent-manual-slug,original-section-slug,new-parent-manual-slug,new-section-slug]`

## Redirects from campaign sites

[campaign-sites-section]: #redirects-from-campaign-sites

The campaigns platform is a WordPress site managed by GDS (Business, Priority
Response and Campaigns team) and supported by dxw. Redirects from a
`*.campaign.gov.uk` site require a support ticket. You should contact
[govuk.campaigns@digital.cabinet-office.gov.uk](mailto:govuk.campaigns@digital.cabinet-office.gov.uk) to raise a support ticket.
