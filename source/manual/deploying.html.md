---
owner_slack: "#govuk-2ndline"
title: Deploy an application to GOV.UK
parent: "/manual.html"
layout: manual_layout
section: Deployment
important: true
last_reviewed_on: 2018-10-18
review_in: 6 months
---

Teams are responsible for deploying their own work. We believe that [regular releases minimise the risk of major problems][reg] and improve recovery time. The [2nd line team][2l] is responsible for providing access to deploy software for teams who can't deploy it themselves.

If you are responding to a security incident, follow the steps to
[deploy fixes for a security vulnerability][sec].

[2l]: /manual/welcome-to-2nd-line.html
[reg]: https://gds.blog.gov.uk/2012/11/02/regular-releases-reduce-risk
[sec]: /manual/deploy-fixes-for-a-security-vulnerability.html

## 1. Test on integration

Code that is merged to `master` is automatically deployed to integration. You
should verify that your changes work there.

## 2. Check the context

The golden rule is that you only deploy what you can support.

- This means that deploys generally take place between 10am and 4pm, the core hours when most people are in the office.
- Check `#govuk-deploy` recent history and the channel topic. In some circumstances we may institute short deployment freezes, they will be announced in that channel.
- Announce your deployment in `#2ndline` if it’s potentially problematic.

## 3. Check your changes

Go to the [Release application](https://release.publishing.service.gov.uk) and find the application you want to deploy. Then select the release tag you want to deploy.

- Check what you will be deploying. If there's other people's code to deploy, ask them whether they're okay for the changes to go out.
- Check if there's a deploy note for the application, to see if there are any special instructions or reasons not to deploy.

## 4. Deploy to staging

From the [Release application](https://release.publishing.service.gov.uk), click the deploy buttons. If you have production access, this will bring you to the Jenkins job to deploy your change.

Once deployed to staging, you will need to:

- Perform manual testing
- [Monitor your app during deployment](/manual/deployment-dashboards.html)
- Check the results of the [smoke tests](https://github.com/alphagov/smokey)
- Keep an eye on any Icinga alerts related to your application
- Check Sentry for any new errors

## 5. Deploy to production

Again:

- Perform manual testing
- [Monitor your app during deployment](/manual/deployment-dashboards.html)
- Check the results of the [smoke tests](https://github.com/alphagov/smokey)
- Keep an eye on any Icinga alerts related to your application
- Check Sentry for any new errors

Stay around for a while just in case something goes wrong.

## Related reading

- [Releasing applications to GOV.UK](https://gdstechnology.blog.gov.uk/2014/09/10/releasing-applications-to-gov-uk/) (older post, using the badger)
- [Read RFC 70](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-070-path-towards-continuous-deployment-cd.md) for context on changes to the deploy process in May 2017
