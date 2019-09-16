---
owner_slack: "#re-govuk"
title: Auto Scaling Groups
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-16
review_in: 6 months
---

In AWS, [we use auto scaling groups][asg] to ensure we have the right number of
machines available to handle incoming traffic.

Unfortunately there are a number of limitations with the system currently which
means we can't use it to automatically scale up the number of machines.
However, we can manually scale up the number of machines in advance if we
anticipate an increase in traffic. This was used effectively after we deployed
the ["Get ready for Brexit" tool][brexit-tool] to ensure we would cope with
the load.

[asg]: https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html
[brexit-tool]: https://www.gov.uk/get-ready-brexit-check

## Manually scaling up/down

> **Note:** If you anticipate this change being permanent, you [should make
> sure to raise a PR against govuk-aws-data][pr] once it's all working to
> ensure the number doesn't get put back to the old value if Terraform gets
> deployed.

1. Scaling up/down machines in AWS will trigger [Icinga alerts](icinga) so let
   developers in `#govuk-2ndline` know you are about to do this.

1. [Access the AWS Console][aws-console] and [go to the EC2 service][ec2-home].

1. Select "Auto Scaling Groups" from the bottom of the menu on the left hand
   side and find the right machine class in the list (you can filter on the
   name).

   ![Filtering auto-scaling groups](images/auto-scaling-groups-filter.png)

1. In the "Details" tab at the bottom, you will see "Desired Capacity", "Min"
   and "Max" which shows the existing configuration. Scroll right and then
   click on the "Edit" button.

1. In the box that appears, change the numbers as required. To ensure you get
   the right number of machines you want, it's best to change all three numbers
   to the same value.

   ![Editing auto-scaling groups](images/auto-scaling-groups-edit.png)

1. Click "Save". This should trigger the creation of new machines and
   automatically run the appropriate [`Deploy_Node_Apps`][deploy-node-apps]
   jobs.

1. To check the machines are recognised, you can [use
   `govuk_node_list -c <class>` on the jumpbox][jumpbox] and check the IP
   addresses printed match those in the [EC2 machine listing][ec2-machines]
   (you can filter the listing by machine class and sort by the date created).

1. If any of the machines aren't recognised by `govuk_node_list` you can
   [destroy the machine][reprovision] and wait for a new one to spawn.

> **Note:** If you anticipate this change being permanent, you [should make
> sure to raise a PR against govuk-aws-data][pr] once it's all working to
> ensure the number doesn't get put back to the old value if Terraform gets
> deployed.

[icinga]: /manual/icinga.html
[aws-console]: /manual/aws-console-access.html
[ec2-home]: https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1
[ec2-machines]: https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=tag:Name
[jumpbox]: /manual/howto-ssh-to-machines-in-aws.html#jumpbox
[deploy-node-apps]: https://deploy.blue.production.govuk.digital/job/Deploy_Node_Apps/
[reprovision]: /manual/reprovision.html#aws
[pr]: https://github.com/alphagov/govuk-aws-data/pull/562
