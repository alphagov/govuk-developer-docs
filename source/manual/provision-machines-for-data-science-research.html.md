---
owner_slack: "#govuk-data-labs"
title: Provision machines for data science research
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

Data science research frequently requires high-powered machines for
limited periods of time.

Machines for this purpose are created in the `govuk-tools` AWS account
using the [`app-data-science`][app-data-science] Terraform project.

> **Note**
>
> The machines provisioned using this method are usually high powered
> and costly. Therefore, please ensure they are destroyed once the
> research has been completed.

## Autoscaling

Machines created using this project are created in autoscaling groups
that ensure at least 1 instance of each machine is running at all times.

Once research is finished, machines should be destroyed by removing them
from the project and re-deploying it. Alternatively, if the machine will be
required again in a short period of time, the autoscaling group can be
manually set to zero instances in the meantime.

## SSH access

All machines have public IP addresses and can be accessed via SSH.
The [userdata][] for each machine is set up to add SSH keys for the people
who will be accessing them.

This userdata should be updated when people need to be added or removed.
Existing machines will then need to be re-deployed (most quickly by
destroying the existing instances and allowing the autoscaling group
to re-create them).

SSH access to data science machines is not controlled by Puppet or
AWS access.

[app-data-science]: https://github.com/alphagov/govuk-aws/tree/master/terraform/projects/app-data-science
[userdata]: https://github.com/alphagov/govuk-aws/blob/master/terraform/userdata/90-data-science-base
