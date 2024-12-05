---
owner_slack: "#govuk-developers"
title: Update the search autocomplete denylist
section: GOV.UK Search
layout: manual_layout
parent: "/manual.html"
---

The autocomplete functionality for GOV.UK Site Search makes use of a denylist to avoid suggesting terms that are not suitable for GOV.UK.

To update this list requires following a manual process:

1. In a text editor create a new empty file, save this file as `denylist.jsonl`
1. Access [the spreadsheet][] and apply the desired changes to the appropriate spreadsheet
1. Copy and paste the contents from the "denylist" column from each spreadsheet into your created `denylist.jsonl` file

Then for each GOV.UK environment of integration, staging and production:

1. Log into [Google Cloud][] and access the `Search API V2 <environment>` project
1. Access "Cloud Storage" > "Buckets" and find the `search-api-v2-<environment>_vais_artifacts` bucket
1. Upload the `denylist.jsonl` file to the bucket, replacing the existing file
1. Leave Google Cloud and open your terminal
1. [Log into][kube-auth] the appropriate environment for Kubernetes
1. Run the `rake autocomplete:update_denylist` [rake task][] for `search-api-v2` to import the file

[the spreadsheet]: https://docs.google.com/spreadsheets/d/1aA2JapqNt0nu-MiFraP7p9flSDvNQCm0QvSZi2Unw48/edit?gid=0#gid=0
[Google Cloud]: /manual/google-cloud-platform-gcp.html#gcp-access
[kube-auth]: /kubernetes/cheatsheet.html#prerequisites
[rake task]: /manual/running-rake-tasks.html#run-a-rake-task-on-eks
