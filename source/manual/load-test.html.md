---
owner_slack: "#govuk-developers"
title: Run a load test with k6
section: Testing
layout: manual_layout
parent: "/manual.html"
---

These instructions are based on [this blog post](https://grafana.com/blog/2022/06/23/running-distributed-load-tests-on-kubernetes/).

1. Determine the name of the Kubernetes context to use:

    ```sh
    kubectl config get-contexts
    ```

    The output will list the environments and their names (e.g. `integration`, `staging` or `production`, or however they are named in your `~/.kube/config` file).

1. Log into AWS and set the context to the environment you wish to test (this is the context name from the previous step):

    ```sh
    ENVIRONMENT=staging
    ROLE=admin

    eval $(gds aws govuk-${ENVIRONMENT}-${ROLE} -e --art 8h)
    kubectl config use-context $ENVIRONMENT
    ```

    > You will need to assume the `admin` role in order to deploy k6 to the cluster.

1. Clone the `k6-operator` repo and make this:

    ```sh
    git clone git@github.com:grafana/k6-operator.git && cd k6-operator
    make deploy
    ```

    > If you get an error similar to `invalid go version '1.22.0': must match format 1.23` then you need to upgrade `go` to the correct version.
    > This can be done by using Homebrew, e.g. `brew install go@1.23`

1. Write your test script, for example to test 3000 virtual users against the Collections app's `/world` page over 30 seconds (bypassing router):

    ```javascript
    import http from 'k6/http';
    import { check } from 'k6';

    export const options = {
      vus: 3000,
      duration: '30s',
    }

    export default function() {
      const res = http.get('http://collections.apps.svc.cluster.local/world');

      check(res, {
        'is status 200': (r) => r.status === 200,
        'is status 2xx, not 200': (r) => r.status >= 201 && r.status <= 299,
        'is status 3xx': (r) => r.status >= 300 && r.status <= 399,
        'is status 4xx': (r) => r.status >= 400 && r.status <= 499,
        'is status 5xx': (r) => r.status >= 500 && r.status <= 599,
      });
    }
    ```

1. Run your code locally to make sure it works:

    ```sh
    k6 run test.js
    ```

    > You may see errors related to connections as you may not be able to establish the correct number of connections from your machine.

1. Deploy the test script:

    ```sh
    kubectl create configmap my-test-name --from-file /path/to/our/test.js
    ```

    > Replace `my-test-name` with a name for this load test. The name will be used later on, e.g. in the name of the pods that run the test.

1. Create a YAML file to contain your custom resource:

    ```yaml
    apiVersion: k6.io/v1alpha1
    kind: K6
    metadata:
      name: k6-load-test
    spec:
      parallelism: 4
      script:
        configMap:
          name: my-test-name
          file: test.js
    ```

    > This resource will spawn 4 test runners. You may need to increase this value to run a large scale test.

1. Deploy your custom resource:

    ```sh
    kubectl apply -f /path/to/our/k6/custom-resource.yml
    ```

    > At this point, your test will have started. You can track progress using `kubectl get pods`.

1. Once all the pods are marked as `completed`, you can retrieve the output of each runner by requesting the logs.

    First get the names of each pod:

    ```sh
    kubectl get pods
    ```

    For each runner pod, retrieve the logs:

    ```sh
    kubectl logs my-test-name-1-abcde
    ```

1. After running the tests, tidy up by deleting your custom resource:

    ```sh
    kubectl delete -f /path/to/our/k6/custom-resource.yml
    kubectl delete configmap my-test-name
    ```
