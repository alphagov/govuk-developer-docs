---
owner_slack: "#govuk-platform-engineering"
title: Signon API user token expires soon
parent: "/manual.html"
layout: manual_layout
section: Alertmanager alerts
---

One or more tokens for API Users are about to expire. You should rotate
expiring tokens to ensure the associated application keeps working.

## Rotate a Signon API token

> 🪨 This procedure is [toil](https://sre.google/workbook/eliminating-toil/) and should be eliminated or automated away. For now, it's unfortunately still a manual process.

Note that the overnight token sync cronjob will over-write any changes made in the Staging environment to match those in the Production environment so this procedure need only be followed for the Production and Integration environments. Any alerts relating to the Staging environment can be safely ignored.

The Integration environment should also be updated overnight but this is not happening currently. It is a known issue that when fixed will mean this procedure will need only to be followed for the Production environment.

### Special cases

If the token is for `Trade Tariff Admin` or `Trade Tariff Backend`, see [Trade Tariff Admin on the Wiki](https://gov-uk.atlassian.net/wiki/spaces/PLOPS/pages/3155099649/Trade+Tariff+Admin)

### 1. Issue a new token

1. Go to the [APIs page](https://signon.publishing.service.gov.uk/api_users) in Signon.

1. From the **API users** table, choose the API User whose **Email** matches the `api_user` field in the alert.

    > Check the **Last synced at** time to see if the API User is still using the
    > application. If you are sure the token is disused, you can choose
    > **Revoke** to delete it and then you're done.

1. Choose **Manage tokens**.

1. Choose **Add application token**.

1. From the **Application** dropdown, select the application that matches the `application` field in the alert.

1. Choose **Create access token**.

The nightly `signon-sync-token-secrets-to-k8s` cronjob will update the token in the Kubernetes secret that the application uses.

### 2. Check that the client application works with the new token

1. Trigger the token sync cronjob to run now (or wait until the next day).

    ```sh
    k create job --from cronjob/signon-sync-token-secrets-to-k8s signon-token-sync-$USER
    ```

   The job should finish within a few seconds. You can view the job's output to check that it succeeded:

    ```sh
    k logs -f job/signon-token-sync-$USER
    ```

    Alternatively, this job can be triggered through the ArgoCD user interface. Navigate to the [console for Signon](https://argo.eks.production.govuk.digital/applications/cluster-services/signon?view=tree&orphaned=false&resource=), click the "signon-sync-token-secrets-to-k8s" cron job, then press the three dots in the top right, then "Create Job". The logs can be viewed by clicking the newly created job.

1. Open a Rails console on the client app. For example, if the `api_user` is `short-url-manager@alphagov.co.uk`, open a console on `short-url-manager`.

    ```sh
    k exec -it deploy/short-url-manager -- rails c
    ```

1. Fetch the environment variable that contains the token. The variable name refers to the server (destination) application, which is the same as the `application` field in the alert. For example, for short-url-manager (client) talking to publishing-api (server):

    ```ruby
    ENV["PUBLISHING_API_BEARER_TOKEN"]
    ```

    Check that the result matches the new token in Signon and not the old one.

1. You can also check that the token works by making an API call yourself from the client app's Rails console. For example, to check that Short URL Manager can talk to Publishing API, you could:

    1. Choose a method from the publishing-api client library in [gds-api-adaptors](https://github.com/alphagov/gds-api-adapters/tree/main/lib/gds_api).
    1. Call the method from short-url-manager's Rails console:

        ```ruby
        client = GdsApi::PublishingApi.new(
          Plek.new.find("publishing-api"),
          bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"]
        )
        client.lookup_content_id(base_path: "/")
        ```

        The call should return some result and not raise an exception.

### 3. Revoke the old token

Once you have confirmed that the application is working with the new token, go back to Signon and revoke the old token.

1. On the **Manage tokens** page, choose the **Revoke** link for the old token.
