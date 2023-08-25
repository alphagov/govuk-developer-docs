---
title: Deploy a new version of the example test app, check the deployment, monitor the app on Grafana and view application logs
weight: 20
layout: multipage_layout
---

# Deploy a new version of the example test app, check the deployment, monitor the app on Grafana and view application logs

This tutorial will teach you how to deploy changes to an app and how to view application metrics and logs.

In this tutorial, you will make a change to the example test app to print your message in the application output and view the message in the application logs. Later, you will make HTTP requests to the example test app and simulate responses with different status codes and view those response metics in Grafana.

1. Update the example test app with your message

    1. Clone the [example test app](https://github.com/alphagov/govuk-replatform-test-app).
    1. Create a new branch to add your changes.
    1. Add a new text file with a prefix of your name, e.g. jblogs-test.txt, in the [test app](https://github.com/alphagov/govuk-replatform-test-app/tree/main/messages) `messages` directory with your own message.

1. Deploy the app changes to the integration environment

    Create a pull request (PR) and then merge your changes in to kick off the deployment process.

1. See that the app changes have started the deployment

    You can check the ["Deploy" GitHub Actions workflow](https://github.com/alphagov/govuk-replatform-test-app/actions) to see that the deployment has begun. This workflow builds a new container image with your application changes, and then triggers an [Argo Workflow](https://argo-workflows.eks.integration.govuk.digital/workflows/apps?limit=500) (login via Github SSO, if you can't see any workflows set the namespace to `apps`) to update the image tag stored in [govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config/image-tags/integration/govuk-replatform-test-app) repository.

    This will cause the [app in the cluster](https://argo.eks.integration.govuk.digital/applications/cluster-services/govuk-replatform-test-app?view=tree&orphaned=false&resource=&node=argoproj.io%2FApplication%2Fcluster-services%2Fgovuk-replatform-test-app%2F0) to be out of sync with the image tag in the govuk-helm-charts repo so Argo will attempt to redeploy the app to keep it in sync. The `imageTag=release-...` SHA against `ANNOTATIONS` should match the commit SHA on the main branch of the test app repository. Argo CD is currently set to poll the repository for changes every 2 minutes.

1. Check your message on the example test app website

    After about 10 minutes you should be see your message on the example test app website visit the [example test app](https://govuk-replatform-test-app.eks.integration.govuk.digital/?status=200).

1. View app metrics on the Grafana dashboard

    Change the status parameter in the test app url to a 5xx status in order to see the error appearing in the [Grafana dashboard](https://grafana.eks.integration.govuk.digital/d/000000111/app-request-rates-errors-durations?orgId=1&refresh=10s&var-namespace=apps&var-app=govuk-replatform-test-app&var-quantile=All&var-error_status=All) (login via your govuk Google SSO)

1. View the messages in your text file in the logs

    One of the outputs of the page will be an identifier which you can use to see the output of your deployment in the logs -

    `Version: 1660815896. Hello, the time is 2022-09-08 15:00:00 +0000, you requested a 200 status response`

    Using the identifier - `1660815896` in this request -

    `https://kibana.logit.io/s/42f4d2d5-e9ce-451f-8ffc-cdb25bd624f8/app/discover#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-4d,to:now))&_a=(columns:!(_source),filters:!(),index:'8ac115c0-aac1-11e8-88ea-0383c11b333a',interval:auto,query:(language:kuery,query:"1660815896"),sort:!())`

    Will bring up a page for logs relevant to your app deployment.

1. Tidy up your messages

    Once you are happy that you have seen your requests in Grafana and logs for your deployment in Kibana please revert your PR to remove your messages.

1. Please send us your feedback

    Tell us how you found working through the 2 tutorials. Please complete this [feedback form](https://docs.google.com/forms/d/e/1FAIpQLSfUl2rM3S0IEudeIEl6f_ZoMoB7kD_CDtMLa92UIx9tSznREw/viewform)

## Maintenance

If you want to make changes to the test app please raise a PR and someone from Platform Engineering team will pick it up.
