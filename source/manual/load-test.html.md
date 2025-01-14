---
owner_slack: "#govuk-developers"
title: Run a load test with k6
section: Testing
layout: manual_layout
parent: "/manual.html"
---

## Writing a load test script

k6 load test scripts are written in JavaScript.

The following is an example which tests a specific endpoint with 3,000 virtual users making requests over 30 seconds. The status code of each response is reported.

```javascript
import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 3000,
  duration: '30s',
}

export default function() {
  const res = http.get('https://www-origin.staging.publishing.service.gov.uk/world');

  check(res, {
    'is status 200': (r) => r.status === 200,
    'is status 2xx, not 200': (r) => r.status >= 201 && r.status <= 299,
    'is status 3xx': (r) => r.status >= 300 && r.status <= 399,
    'is status 4xx': (r) => r.status >= 400 && r.status <= 499,
    'is status 5xx': (r) => r.status >= 500 && r.status <= 599,
  });
}
```

A more [complex script](https://gist.github.com/brucebolt/54e6050dacb950155fc7fbb0b9ba8219) (with multiple scenarios, running sequentially) has previously been used and can be adjusted to suit future needs.

Further details can be found in the [k6 documentation](https://grafana.com/docs/k6/latest/).

## Running a load test

In many cases, the load test can be run locally. However with larger levels of load, you may find that you are testing the capability of your internet connection, rather than the target server. In this case, it is possible to run a load test from within our kubernetes infrastructure.

### Running the test locally

1. Install k6:

   ```sh
   brew install k6
   ```

1. Run your script:

   ```sh
   k6 run test.js
   ```

   > There are [many forms of output](https://grafana.com/docs/k6/latest/results-output/end-of-test/) that be selected (e.g. CSV).
   >
   > If further processing of the data is required, you may wish to output as a JSON summary file, using the `--summary-export` option.

### Running the test on Kubernetes

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
    git clone git@github.com:grafana/k6-operator.git && cd k6-operator && git checkout v0.0.18
    make deploy
    ```

    > If you get an error similar to `invalid go version '1.22.0': must match format 1.23` then you need to upgrade `go` to the correct version.
    > This can be done by using Homebrew, e.g. `brew install go@1.23`

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
