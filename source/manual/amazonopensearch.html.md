---
owner_slack: "#govuk-publishing-platform"
title: Access Amazon OpenSearch Dashboard
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

[AWS OpenSearch] is an open source, distributed search and analytics suite derived from Elasticsearch.

## Prerequisites

1. Access to a [GOV.UK EKS cluster] with admin role permissions has been configured and established.

1. The [krelay] kubectl plugin has been installed.

    ```sh
    $ brew install knight42/tap/krelay
    ```

## Connect to the OpenSearch Dashboard

1. List OpenSearch domain names:

    ```sh
    $ aws opensearch list-domain-names | jq -r '.DomainNames[]|.DomainName'
    blue-elasticsearch6-domain
    chat-engine
    ```

1. Get OpenSearch host name for `chat-engine`:

    ```sh
    $ aws opensearch describe-domain --domain-name chat-engine | jq -r '.DomainStatus.Endpoints.vpc'
    vpc-chat-engine-m2k6ipw3klpaomdhrhhh6vo3de.eu-west-1.es.amazonaws.com
    ```

1. Forward the OpenSearch HTTPS port to your local machine:

    ```sh
    $ k relay host/vpc-chat-engine-m2k6ipw3klpaomdhrhhh6vo3de.eu-west-1.es.amazonaws.com 4443:443
    ```

1. Open <https://localhost:4443/_dashboards> in your browser. The TLS certificate will not match `localhost`, so navigate past the certificate warnings. In Chrome, you can set <chrome://flags/#allow-insecure-localhost> if you prefer.

1. Log into the OpenSearch Dashboard web interface. The username and password for each environment can be found in [AWS Secrets Manager]. To find the `opensearch` secret name, use the command:

    ```sh
    $ aws secretsmanager list-secrets | jq -r '.SecretList[]|select(.Name|contains("opensearch"))|.Name'
    govuk/govuk-sli-collector/logit-opensearch-api
    govuk/govuk-chat/opensearch
    ```

1. To get the credentials for `govuk/govuk-chat/opensearch` from Secrets Manager, displaying Username on screen and adding Password to the Clipboard:

    ```sh
    $ secret=$(aws secretsmanager get-secret-value --secret-id govuk/govuk-chat/opensearch | jq -r '.SecretString| tostring'); echo "Username: $(echo $secret | jq -r '.username')"; echo $secret | jq -r '.password' | pbcopy
    Username: chat-masteruser
    ```

[AWS OpenSearch]: https://aws.amazon.com/opensearch-service/
[AWS Secrets Manager]: https://aws.amazon.com/secrets-manager/
[GOV.UK EKS cluster]: https://docs.publishing.service.gov.uk/kubernetes/get-started/access-eks-cluster/
[krelay]: https://github.com/knight42/krelay#installation
