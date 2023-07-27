---
owner_slack: "#govuk-2ndline-tech"
title: Check status of latest GCP mirror sync job
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

This alert means that the latest mirror sync job from AWS S3 to GCP GCS Google Cloud Storage (GCS) failed. The mirror sync job exists to ensure that we have an up-to-date copy of the mirrored contents of GOV.UK from the AWS S3 bucket `govuk-production-mirror` within the same-named bucket in GCS, should we ever need to [fall back to the static mirror][fallback to mirror] hosted on GCP. The job lives within GCP Data Transfer and runs everyday at 18:00 UTC.

Occasionally we see errors during the mirror sync process, such as files not being found. Previously there was no remedial action we could take on these errors as the Data Transfer API was broken, however now that it has been fixed it is straightforward to retry the failed job.

## Manually retrying the mirror sync job

### Prerequisites:

- You need to have production access.
- You need to have been added to the appropriate Google group.

### Via the GCP Console:

1. Go to the [Data Transfer][] section in the GCP Console, ensuring you're viewing the GOV.UK Production project.
2. Click on the transfer job named _daily sync of the primary govuk-production-mirror S3 bucket_.
3. Click on the _Start a run_ button at the top of the page to queue a new transfer operation.
4. A new transfer operation will appear below in the _Run history_ table, which you can tail by clicking its start time.

### Via the GCP Data Transfer API:

1. SSH into the Monitoring box: `gds govuk connect -e production ssh aws/monitoring`.
2. Run the following to initiate a new transfer operation:

```sh
export GOOGLE_APPLICATION_CREDENTIALS=/etc/govuk/gcloud_auth.json
gcp_project_id=govuk-production
gcp_transfer_service_token=$(gcloud auth application-default print-access-token)
transfer_jobs=$(curl --silent --header "Content-Type: application/json" \
  --header "Authorization: Bearer $gcp_transfer_service_token" \
  --request GET "https://storagetransfer.googleapis.com/v1/transferJobs?filter=%7B%22projectId%22%3A%22$gcp_project_id%22%7D")
transfer_job_name=$(echo $transfer_jobs | jq -c -r ".transferJobs[] | select(.description | contains(\"${gcp_project_id}\")) | .name")
transfer_operation=$(curl --header "Content-Type: application/json" \
  --header "Authorization: Bearer $gcp_transfer_service_token" \
  --request POST \
  --data '{"projectId": "govuk-production"}' \
  "https://storagetransfer.googleapis.com/v1/$transfer_job_name:run")
```

3. `transfer_operation` should contain a JSON response confirming that a new transfer operation has been queued:

```json
{
  ...
  "metadata": {
    "@type": "type.googleapis.com/google.storagetransfer.v1.TransferOperation",
    "projectId": "govuk-production",
    "transferSpec": {
      "awsS3DataSource": {
        "bucketName": "govuk-production-mirror"
      },
      "gcsDataSink": {
        "bucketName": "govuk-production-mirror"
      },
      "transferOptions": {
        "deleteObjectsUniqueInSink": true
      }
    },
    "startTime": "2021-07-13T14:23:04.902943622Z",
    "status": "QUEUED",
    "counters": {},
    ...
  },
  ...
}
```

4. Finally, you can check the status of the new transfer operation by calling:

```sh
latest_operation_name=$(echo $transfer_operation | jq -r .name)
latest_operation_details=$(curl --silent --header "Content-Type: application/json" \
  --header "Authorization: Bearer $gcp_transfer_service_token" \
  --request GET "https://storagetransfer.googleapis.com/v1/$latest_operation_name")
echo $latest_operation_details | jq -r '.metadata.status'
```

## Further actions:

If you continue to experience errors with the job after manually forcing a retry, it's possible that the GOV.UK crawler worker hasn't finished crawling or that crawled pages haven't been fully uploaded to S3. This used to be a regular problem until the mirror sync job schedule was moved from 12:00 UTC to 18:00 UTC. It is also inevitable over time as we accrue new pages that the crawler process will take longer to complete, which could also result in the previously mentioned situation.

When retrying the mirror sync job continues to result in errors, it is advisable to wait until the mirror sync job is next scheduled to run before taking further action.

[Data Transfer]: https://console.cloud.google.com/transfer/cloud/jobs
[fallback to mirror]: /manual/fall-back-to-mirror.html
