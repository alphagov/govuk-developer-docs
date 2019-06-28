---
owner_slack: "#govuk-2ndline"
title: Update Pingdom IP ranges
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-02
review_in: 6 months
---

> **Note**
>
> This process only applies to Carrenza environments.

The "[Check_Pingdom_IP_Ranges][check-pingdom-ip-ranges-jenkins]" Jenkins
job runs every Monday and checks whether the IP addresses we have stored
for Pingdom match the ones they are actually using.

If this task fails, it is an indicator that our IPs are not consistent with
the ones they are using and we need to update our rules.

Edit the [carrenza_mirror_vars.yaml][carrenza] file in the
[govuk_mirror-deployment][mirror-repo]. There is a command in the comments of
that file that will generate a new list of IP addresses in YAML format.

To check the IP addresses from your own machine, clone the
[govuk_mirror-deployment][mirror-repo] and run `ruby tools/pingdom_ips.rb`.

Once done, run the "[Mirror_Network_Config][mirror-network-config-jenkins]"
Jenkins job, setting the environment to "Carrenza" and the component to
"Firewall". You can use the `--dry-run` extra argument to test what changes
the job will make before omitting the argument to actually make the changes.

[check-pingdom-ip-ranges-jenkins]: https://deploy.publishing.service.gov.uk/job/Check_Pingdom_IP_Ranges/
[mirror-repo]: https://github.com/alphagov/govuk_mirror-deployment
[carrenza]: https://github.com/alphagov/govuk_mirror-deployment/blob/master/vcloud-edge_gateway/vars/carrenza_mirror_vars.yaml
[mirror-network-config-jenkins]: https://deploy.publishing.service.gov.uk/job/Mirror_Network_Config/
