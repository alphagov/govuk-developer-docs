---
owner_slack: "#govuk-developers"
title: Deploy an application to GOV.UK
parent: "/manual.html"
layout: manual_layout
section: Deployment
important: true
last_reviewed_on: 2019-07-31
review_in: 6 months
---

Teams are responsible for deploying their own work. We believe that [regular releases minimise the risk of major problems][reg] and improve recovery time. The [2nd line team][2l] is responsible for providing access to deploy software for teams who can't deploy it themselves.

If you are responding to a security incident, follow the steps to [deploy fixes for a security vulnerability][sec].

[2l]: /manual/welcome-to-2nd-line.html
[reg]: https://gds.blog.gov.uk/2012/11/02/regular-releases-reduce-risk
[sec]: /manual/deploy-fixes-for-a-security-vulnerability.html

## Deploying a branch

It can be useful to test your branch in a non-local environment before it is merged to master. Note that you should only do this on Integration, unless you have a good reason to deploy to a different environment.

As you'll be deploying to Integration, note that your deployment could get overwritten at any time as apps on Integration are automatically overwritten by their master branches when PRs are merged.

Before deploying anything, check whether there is already a non-master branch deployed by looking at the Release application on production, or look at the [build history in Jenkins](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/). The Release app on staging and integration won't tell you, as they're synced from production overnight and aren't otherwise updated. If a non-master branch has been deployed, try and ask the person who deployed it if they're finished.

If you are deploying to staging or production, announce your deployment in `#govuk-deploy` so that people are aware a non-master branch is being built. It is not necessary to announce if you're deploying to Integration.

Go to the `Deploy_App` job in Jenkins and click 'Build with Parameters':

- `TARGET_APPLICATION` - choose the name of the repository you want to deploy
- `DEPLOY_TASK` - usually 'deploy' is most appropriate
- `TAG` - put the name of your branch
- Typically you can leave the checkboxes as they are

Click 'Build' and your application should be built to Integration.

## Deploying master

### 1. Test on integration

Code that is merged to `master` is automatically deployed to integration. You should verify that your changes work there.

### 2. Check the context

The golden rule is that you only deploy what you can support.

- This means that deployments generally take place between 9.30am and 5pm (4pm on Fridays), the core hours when most people are in the office.
- Check `#govuk-deploy` recent history and the channel topic. In some circumstances we may institute short deployment freezes, and they will be announced in that channel as well as other developer-relevant channels and possibly email.

### 3. Check your changes

Go to the [Release application](https://release.publishing.service.gov.uk) and find the application you want to deploy. Then select the release tag you want to deploy.

- Check what you will be deploying. If there's other people's code to deploy, ask them whether they're okay for the changes to go out.
- Check if there's a deploy note for the application, to see if there are any special instructions or reasons not to deploy. Individual app deploy freezes are usually announced here.
- Check in `#govuk-deploy` if someone's already in the process of deploying the app. This is particularly important for Puppet where there is a delay of 30 minutes between staging and production deployments. Deployments attributed to "Jenkins" are AWS automated deployments and can be ignored for this purpose.
- Announce in `#govuk-2ndline` if you anticipate your release causing any issues.

### 4. Deploy to staging

From the [Release application](https://release.publishing.service.gov.uk), click the deploy buttons. If you have production access, this will bring you to the Jenkins job to deploy your change.

Once deployed to staging, you will need to:

- Perform manual testing (including any testing mandated as part of the deploy note for the app)
- [Monitor your app during deployment](/manual/deployment-dashboards.html)
- Check the results of the [smoke tests](https://github.com/alphagov/smokey)
- Keep an eye on any Icinga alerts related to your application
- Check Sentry for any new errors

### 5. Deploy to production

Again:

- Perform manual testing (including any testing mandated as part of the deploy note for the app)
- [Monitor your app during deployment](/manual/deployment-dashboards.html)
- Check the results of the [smoke tests](https://github.com/alphagov/smokey)
- Keep an eye on any Icinga alerts related to your application
- Check Sentry for any new errors

Stay around for a while just in case something goes wrong.

## Related reading

- [Releasing applications to GOV.UK](https://gdstechnology.blog.gov.uk/2014/09/10/releasing-applications-to-gov-uk/) (older post, using the badger)
- [Read RFC 70](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-070-path-towards-continuous-deployment-cd.md) for context on changes to the deploy process in May 2017
