---
owner_slack: "#2ndline"
title: Set up a new Rails app
section: Packaging
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/setting-up-new-rails-app.md"
last_reviewed_on: 2017-07-31
review_in: 6 months
---

Getting a new Rails app running in production has several steps. You should ensure that:

- Your app follows GOV.UK conventions, including the [Ruby styleguide](https://github.com/alphagov/styleguides/blob/master/ruby.md)
- Continuous integration is set up
- Your app can be deployed to integration, staging and production environments
- You can monitor how your app is performing

For most apps, this means you'll be using:

- [Jenkins](https://jenkins.io) for CI
- [Puppet](https://puppet.com/product) to provision the machines your app runs on
- [Capistrano](http://capistranorb.com/) to deploy it
- [Sentry](https://sentry.io/govuk) to track stack traces
- The [GOV.UK development VM](https://github.com/alphagov/govuk-puppet/tree/master/development-vm)

Exceptions are apps that don't need to share infrastructure with the rest of GOV.UK, such as internal tools or prototypes. In this case it might be easier to deploy to the [Government PaaS](https://docs.cloud.service.gov.uk/#technical-documentation-for-gov-uk-paas) or [Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby).

(This guide will assume you aren't doing that).

## Bootstrapping a new application

The quickest and easiest way to start a new Rails application on the
GOV.UK stack is to use the [govuk-rails-app-template
repository](https://github.com/alphagov/govuk-rails-app-template).

This will create a new Rails application, installing and configuring common features.

From here on we'll assume you’re configuring a new
Rails application named `myapp` that was created with the above
script.

## Naming conventions

There are a few conventions for naming apps in the Puppet configuration
and elsewhere:

-   Puppet classes, hieradata and CI job names should use snake\_case -
    eg. `content_store`
-   Hostnames, deployment scripts and CI parameters should use
    spinal-case - eg. `content-store`

## Defining the app in the development repository

You first need to add the app to the [development-vm
configuration in puppet](https://github.com/alphagov/govuk-puppet/tree/master/development-vm).

Add the app to the `Procfile` and assign it the next available port
number.

    myapp: govuk_setenv myapp ./run_in.sh ../myapp bundle exec rails s -p 3456

If the app is dependent on other apps, you'll also want to add it to the
`Pinfile` and define its dependencies.

    process :myapp => :anotherapp

To be able to access your app via a browser, you need to add it to the
hosts list in hieradata for development. See
[govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/master/docs/adding-a-new-app.md#including-the-app-on-machines)
for more information.

You should then be able to view it at <http://myapp.dev.gov.uk>.

## Defining the app in Puppet

There's a guide explaining [how to add a new app to the Puppet
repository](https://github.com/alphagov/govuk-puppet/blob/master/docs/adding-a-new-app.md).

Be sure to use the same port number which you assigned in the
`Procfile`.

## Setting up DNS entries

If the app requires the creation of new external (publicly accessible)
subdomains, speak to the infrastructure team. They can create these for
you and point them to the correct boxes.

## Adding deployment scripts

After the app has been configured and defined in Puppet, the deployment
scripts are the next step to getting the app running on the boxes.
Deployment scripts are bespoke to each application, but they live
together in the [govuk-app-govuk-secrets
repository](https://github.com/alphagov/govuk-app-deployment); All Rails
apps use [Capistrano](http://www.capistranorb.com/) for deployment, and
common deployment steps have been extracted into the `recipes`
directory.

It's recommended to copy the deploy scripts from an existing app as a
starting point. The deployment scripts for the `content-store` are
fairly generic and have little custom behaviour, which may be useful.

> **warning**
>
> If the names of the app and repository are not the same, make sure to
> configure the `repository` correctly. If you don't, the repository
> location will be inferred from the app name and the deploy will fail.
> It must be set after the `load` statements to override the defaults.
>
>     # myapp/config/deploy.rb
>     load 'defaults'
>     load 'ruby'
>
>     set :repository, 'git@github.com/alphagov/foo.git'
>
> If you don't load deploy/assets in your deploy script, none of your
> applications assets (css, images) etc will be copied to your app's
> public folder when it's deployed. If the asset isn't in public it
> can't be rendered.
>
>     load 'deploy/assets'

## Configuring the application for each environment

Use environment variables to set environment-specific configuration and
secrets for your app. Envvars are created by Puppet (`content-store` is
a [good
example](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/content_store.pp#L57-L73)
again) and there are [defined
types](https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk/manifests/app/envvar)
which make it simpler to configure apps to connect to their databases.

## Configuring the app for Jenkins

If you used the the [govuk-rails-app-template
repository](https://github.com/alphagov/govuk-rails-app-template) to
create your application, your app will already have `Jenkinsfile`. If
you you didn't, you will need to create a
\[Jenkinsfile\](testing/application-testing) in your application repo.

You also need to add a Jenkins integration to the repo on Github:

1.  In github, go to Settings -&gt; Integrations & Services
2.  Add Jenkins (GitHub plugin)
3.  Add the link to the CI GitHub webhook
4.  Make sure Active is ticked

Add the app to the list of
[deployable\_applications](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml)
and you'll automatically get a job on CI and a deployment task on
Jenkins.

You should add the name of the directory containing the deployment
scripts. Jenkins will attempt to `cd` into this directory at the start
of the deploy. It should be the same as the name of the repository on
GitHub.

## Configuring Signon accounts

If users need to sign in to your app, if your app needs to authenticate
API clients, or if your app needs authenticated access to another app's
API, you'll need to configure Signon.

(These examples assume you use
[GDS-SSO](https://github.com/alphagov/gds-sso) for authentication and
the [GDS API adapters](https://github.com/alphagov/gds-api-adapters) to
connect to APIs. If you don't, you'll have to figure out the equivalents
for your libraries.)

To configure your app so users (or API clients) can authenticate:

1.  Run the `applications:create` Rake task from Signon in Integration
    and Production, as described in [Signon's
    repo](https://github.com/alphagov/signonotron2/blob/master/doc/usage.md)
    No need to run this in Staging as Production credentials will be
    copied over.
2.  Save the OAuth ID and OAuth secret this command gives you into the
    GDS-SSO configuration in the `initializers_by_organisation`
    directory for your environment, as described above. Example:
    [Maslow's SSO
    config](https://github.digital.cabinet-office.gov.uk/gds/alphagov-deployment/blob/ceaca2a60cab75eaaab86291f4768faaa9e3d2ca/maslow/initializers_by_organisation/preview/gds-sso.rb).

To configure your app so it can talk to an existing API application:

1.  Create an API user for your client app using the [API
    Users](https://signon.integration.publishing.service.gov.uk/api_users)
    section in Signon (you'll need to be a signon superadmin to
    access this).
2.  Add an application token for this user to access the
    necessary application.
3.  Save the access token this generates into the [API
    adapters](https://github.com/alphagov/gds-api-adapters) client
    configuration in the `initializers_by_organisation` directory for
    your environment. Example: [Maslow's API
    config](https://github.digital.cabinet-office.gov.uk/gds/alphagov-deployment/blob/ceaca2a60cab75eaaab86291f4768faaa9e3d2ca/maslow/initializers_by_organisation/preview/api_client_credentials.rb).

You need separate IDs, secrets and tokens for preview and
staging/production, but staging and production should use the same keys,
as production data replicates to staging overnight. Ideally, you should
do this once in preview and once in production, then let the replication
run its course. If you don't have a night to spare, you can also do the
configuration in staging and update the Application object manually from
a Rails console.

## Configuring Sentry

If you used the the [govuk-rails-app-template
repository](https://github.com/alphagov/govuk-rails-app-template) to
create your application, your app will already have the `govuk_config` gem
installed.

To complete the setup, do the following.

### Create the app in Sentry

Run the appropriate rake task in [govuk-sentry-config][].

[govuk-sentry-config]: https://github.com/alphagov/govuk-sentry-config

### Update Puppet to include the environment variables for airbrake

    # modules/govuk/manifests/apps/myapp.pp
    class govuk::apps::collections(
      $sentry_dsn = undef,
      ..
    ) {
      govuk::app { 'collections':
        ...
        sentry_dsn => $sentry_dsn,
      }

### Add the secret key environment variable to the govuk-secrets repository

For each environment, set the `govuk::apps::myapp::sentry_dsn`
variable with the API key that was generated by Sentry.

## Deploy!

The final step is to deploy your app. You'll want to run the
`deploy:setup` task the first time round to create the required
directories on each box.
