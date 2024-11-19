---
owner_slack: "#govuk-app-support"
title: Remote config runbook
parent: "/mobile/backend"
---

# Remote config runbook

## General guidance

> High-level background information about the App, its architecture and general incident management information can be found on the [wiki](https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/4137025538/Incident+management).

Remote config is administered through the [alphagov/govuk-mobile-backend-config](https://github.com/alphagov/govuk-mobile-backend-config) repository. Outside of the GOV.UK App team, **in order to make changes you must be a member of [@gov-uk-production-admin](https://github.com/orgs/alphagov/teams/gov-uk-production-admin)**.

There is some guidance in the README as to how the repository works, but briefly:

* New versions of config are written into the `./versions` directory. You should not update config version documents, but create a new one each time you want to make an update.
* Config version documents follow [semantic versioning](https://semver.org/). In general if you are making an emergency change, this should be a `PATCH` update on top of the existing version.
* Config version documents are [TOML](https://toml.io/en/) files that declare default configuration values which can then be overwritten on a per-environment basis. Here is an example of a config version document:

```toml
[metadata]
configVersion = "0.0.1"

[environments]
production = { }
staging = { }
integration = { }

[environments.default.android]
platform = "Android"
available = true
minimumVersion = "0.0.1"
recommendedVersion = "0.0.1"
releaseFlags = {
    onboarding = true
    search = true
}

[environments.default.ios]
platform = "iOS"
available = true
minimumVersion = "0.0.1"
recommendedVersion = "0.0.1"
releaseFlags = {
    onboarding = true
    search = true
}
```

Here, you can see that the default configuration is used in all environments - production, staging and integration.

Below are instructions for some common tasks that may be needed to fix urgent situations.

## Pre-requisites

> In an emergency, if you are struggling to install the pre-requisites, you could skip the local validation and generation steps and allow the CI pipeline to do this. This is not recommended, however.

Node.js (and `npm`) must be installed. General intructions are [here](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs) although a popular approach is to use [nvm](https://github.com/nvm-sh/nvm).

Furthermore, in order to use the validation and generation commands locally, TypeScript must be installed. This can normally be done with `npm install typescript`.

## Switching the app off entirely

This is the most straightforward and least-granular way to deal with an urgent issue in production. The following steps are needed:

1. Create a new config version document in the `./versions/appinfo` directory. Increment the `PATCH` value of the previous version
2. Override the `production` values for the relevant platform (iOS or Android) to set `available` to `false`.

    Here is an example of switching off iOS in production, assuming that we are going to increment the version to `0.0.2`:

    ```toml
    [metadata]
    configVersion = "0.0.2"

    [environments]
    staging = { }
    integration = { }

    [environments.default.android]
    platform = "Android"
    available = true
    minimumVersion = "0.0.1"
    recommendedVersion = "0.0.1"
    releaseFlags = {
        onboarding = true
        search = true
    }

    [environments.default.ios]
    platform = "iOS"
    available = true
    minimumVersion = "0.0.1"
    recommendedVersion = "0.0.1"
    releaseFlags = {
        onboarding = true
        search = true
    }

    [environments.production.ios]
    available = false
    ```

3. Validate the format and structure of the new document by running `npm start validate versions/appinfo/0.0.2.toml`
4. Verify that the change looks correct by running `npm start generate versions/appinfo/0.0.2.toml`. Review the output for the production environment and check that it looks correct:

    ```json
    {
        // other environment config...
        // ...
        "production": {
            "ios": {
                "platform": "iOS",
                "config": {
                "available": false,
                "minimumVersion": "0.0.1",
                "recommendedVersion": "0.0.1",
                "releaseFlags": {
                    "onboarding": true,
                    "search": true
                },
                "version": "0.0.2",
                "lastUpdated": "2024-09-27T10:31:35.426Z"
                }
            },
            "android": {
                "platform": "Android",
                "config": {
                "available": true,
                "minimumVersion": "0.0.1",
                "recommendedVersion": "0.0.1",
                "releaseFlags": {
                    "onboarding": true,
                    "search": true
                },
                "version": "0.0.2",
                "lastUpdated": "2024-09-27T10:31:35.426Z"
                }
            }
        }
    }
    ```

5. Once happy, make a pull request to the repository and request a review.
6. Once the PR is merged and you are happy to proceed to production, [manually run the CI job](https://github.com/alphagov/govuk-mobile-backend-config/actions/workflows/deploy-production.yaml) to deploy the change to production (select 'Run workflow' and click the green button).
7. Verify that the endpoint has been updated by accessing [https://app.publishing.service.gov.uk/config/appinfo/ios](https://app.publishing.service.gov.uk/config/appinfo/ios) (N.B. this can take 5 minutes to propagate through the cache; if an urgent change is needed you can purge the cache manually following the instructions [here](/manual/purge-cache.html#purge-a-page-from-the-fastly-cdn))

## Disabling an individual feature

The steps for remotely disabling a specific feature are very similar to the steps above, except that you use the `releaseFlags` setting to achieve this. Here is an example of a config version document which turns off the 'search' feature for Android in production. Here we will assume that we are incrementing the `PATCH` version to `0.0.3`:

```toml
[metadata]
configVersion = "0.0.3"

[environments]
staging = { }
integration = { }

[environments.default.android]
platform = "Android"
available = true
minimumVersion = "0.0.1"
recommendedVersion = "0.0.1"
releaseFlags = {
    onboarding = true
    search = true
}

[environments.default.ios]
platform = "iOS"
available = true
minimumVersion = "0.0.1"
recommendedVersion = "0.0.1"
releaseFlags = {
    onboarding = true
    search = true
}

[environments.production.android]
releaseFlags = {
    search = false
}
```

The outputted JSON object for the Android production environment should look like this:

```json
{
    "android": {
        "platform": "Android",
        "config": {
            "available": true,
            "minimumVersion": "0.0.1",
            "recommendedVersion": "0.0.1",
            "releaseFlags": {
                "onboarding": true,
                "search": false
            },
            "version": "0.0.2",
            "lastUpdated": "2024-09-27T10:40:49.316Z"
        }
    }
}
```

## Forcing users to update

To force users whose app version is lower than a certain value to update, use the `minimumVersion` setting. So to force Android users whose version is less than `2.4.6` to update, set the value in production as follows:

```toml
[environments.production.android]
minimumVersion = "2.4.6"
```
