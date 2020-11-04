---
owner_slack: "#govuk-2ndline"
title: AWS LB Healthy Hosts
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert relates to the number of healthy hosts behind AWS LoadBalancing services. We use AWS ELB (Classic) and ALB services to route traffic from internet facing or internal clients to the application instances.

> The type is discovered automatically in the check. If the script can't find the load balancer, the check status will be UNKNOWN.

## Classic (ELB-Classic) LBs

A classic load balancer (ELB) periodically sends health checks to test the EC2 instances attached to the Load balancer. This alert relates to the number of healthy ("InService") hosts behind AWS LoadBalancing services. The load balancer routes requests only to the healthy instances.

### Debugging the alert

1. The check we do is similar to what we see from the [AWS web console][aws-console]: **EC2 -> Load Balancers -> Select the load balancer in your region: Instances, Status**.

1. The icon next to the status can provide more information, if the status is unhealthy.

1. If the instances are part of an Autoscaling Group, the Autoscaling Group "Activity History" section can also provide information when instances are registered or deregistered from load balancers: **EC2 -> Auto Scaling Groups -> Select the ASG in your region: Activity History**.

## Application (ELBv2-ALB)

An Application load balancer (ELBv2/ALB) routes requests to registered target groups based on specific rules. This alert relates to the number of "healthy" targets across all Target Groups for the ALB

When we configure a load balancer, we create target groups, then register targets with the target groups, and finally define the rules to route traffic for a listener to each target group. Each listener has at least a default action to route traffic to a default target group. The target groups are configured with health checks to monitor the status of the targets, and only send traffic to healthy ones.

### Debugging the alert

1. In the [AWS web console][aws-console]: **EC2 -> Load Balancers -> Select the load balancer in your region: Listeners -> View/Edit Rules**. (The Listeners section only shows the default action, condition based rules don't appear here.)

1. Under the Rules view, you can see all the route conditions and target groups linked to each rule.
1. From this view you can click on the Target group and check the Targets section for their statuses.

> You can also go directly to the EC2 -> Target Groups service and search all the target groups registered with the load balancer, and check the targets from there.

Sometimes we decommission applications but the configuration hasn't been updated in the Terraform/AWS side. If this is the case, some target groups will appear as unhealthy because the app is no longer active. If this happens, it's preferable to update the Terraform configuration to remove DNS entries and rules/target groups linked to the service, but we can also ignore that target group from the checks with the `healthyhosts_ignore` option.

[aws-console]: /manual/access-aws-console.html
