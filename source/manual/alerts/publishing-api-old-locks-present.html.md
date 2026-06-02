---
owner_slack: "#govuk-content-apis"
title: Publishing API old locks present
parent: "/manual.html"
layout: manual_layout
section: Monitoring and alerting
---

## Description

This alert will fire when `sidekiq-unique-jobs` locks have persisted beyond the lock TTL ([currently one hour](https://github.com/alphagov/publishing-api/blob/7403170ad920bc0483669e12fb062c4def00ac21/config/initializers/sidekiq.rb#L5) at the time of writing).

## Impact

If a lock persists once the Sidekiq job has been completed (or failed), Publishing API is unable to schedule another job with the same parameters (e.g. document ID). This could have the effect of jobs not being enqueued correctly leading to documents failing to be sent to Content Store.

## Potential resolution steps

Open the [Sidekiq Web UI](/manual/sidekiq.html#sidekiq-web) for Publishing API to identify which locks have persisted.

If you are confident there is no scheduled job attached to the lock, delete the lock using the UI. If there is a job attached to the lock, identify why it has not been executed within the hour.

Keep a record of the issue and the resolution carried out, as we'd like to get a better picture of when locks fail to be released correctly by `sidekiq-unique-jobs`.
