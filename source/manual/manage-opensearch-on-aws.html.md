---
owner_slack: "#govuk-2ndline-tech"
title: Manage OpenSearch on AWS
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

[AWS OpenSearch] is an open source, distributed search and analytics suite derived from Elasticsearch.

### Access OpenSearch Dashboard

We typically can't access an OpenSearch dashboard with the URL provided in the AWS console because the endpoint is in a private subnet in a [virtual private cloud (VPC)](https://en.wikipedia.org/wiki/Virtual_private_cloud). Therefore to access it we need to configure our system to tunnel into the subnet in the VPC.

### Prerequisites

1. Access to a [GOV.UK EKS cluster] with admin role permissions has been configured and established.

1. The [krelay] kubectl plugin and [jq] command have been installed.

    ```sh
    brew install knight42/tap/krelay jq
    ```

## Connect to the OpenSearch Dashboard

1. List OpenSearch domain names:

    ```sh
    aws opensearch list-domain-names | jq -r '.DomainNames[]|.DomainName'
    ```

1. Get OpenSearch host name for the OpenSearch Domain you want to access (e.g. for `chat-engine`):

    ```sh
    OPENSEARCH_URL=$(aws opensearch describe-domain --domain-name chat-engine | jq -r '.DomainStatus.Endpoints.vpc')
    ```

1. Forward the OpenSearch HTTPS port to your local machine:

    ```sh
    kubectl relay host/$OPENSEARCH_URL 4443:443
    ```

1. The OpenSearch Dashboard web interface username and password for each environment can be found in [AWS Secrets Manager]. To find the `opensearch` secret name, use the command:

    ```sh
    aws secretsmanager list-secrets | jq -r '.SecretList[]|select(.Name|contains("opensearch"))|.Name'
    ```

1. Get the credentials from Secrets Manager and display them on screen (e.g. for `govuk/govuk-chat/opensearch`):

    ```sh
    aws secretsmanager get-secret-value --secret-id govuk/govuk-chat/opensearch | jq -r '.SecretString| tostring' | jq
    ```

1. Open <https://localhost:4443/_dashboards> in your browser. The TLS certificate will not match `localhost`, so navigate past the certificate warnings. In Chrome, you can set <chrome://flags/#allow-insecure-localhost> if you prefer.

1. Enter the username and password credentials obtained from Secrets Manager to log into the dashboard.

[AWS OpenSearch]: https://aws.amazon.com/opensearch-service/
[AWS Secrets Manager]: https://aws.amazon.com/secrets-manager/
[GOV.UK EKS cluster]: https://docs.publishing.service.gov.uk/kubernetes/get-started/access-eks-cluster/
[krelay]: https://github.com/knight42/krelay#installation
[jq]: https://jqlang.github.io/jq/
