---
owner_slack: "#govuk-data-labs"
title: Manage your machine's resources with AWS Sagemaker
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---

You may find that you reach your local machine’s resource limit when running intensive tasks and/or when using large datasets, or that computations are taking a long time. You should use [AWS Sagemaker](https://eu-west-1.console.aws.amazon.com/sagemaker/home?region=eu-west-1#/landing) to manage these resource issues.

The following documentation applies to on-demand notebook instances.

AWS Sagemaker lets you create instances with different numbers of virtual CPUs and memory at a cost. See the [documentation on AWS Sagemaker pricing](https://aws.amazon.com/sagemaker/pricing/) for more information.

## Access AWS Sagemaker

Before you start, you must have [set up your AWS account](https://docs.publishing.service.gov.uk/manual/get-started.html#7-get-aws-access).

1. [Sign in to AWS](https://console.aws.amazon.com/console/home).
1. Select your name in the top right of the screen and select __Switch roles__.
1. Under __Account__, you can select select __govuk-infrastructure-integration__ or __210287912431__.
1. Under __Role__, select __govuk-datascienceusers__.
1. You can enter any text into __Display name__ or leave this field empty.
1. You can select any colour in __Colour__. Best practice is to select green for integration, amber for staging and red for production.
1. Select __Switch Role__.
1. Enter “Sagemaker” into the search field and select __Amazon Sagemaker__.
1. In the left hand navigation, select __Notebook__ and then __Notebook instances__.

You have now accessed AWS Sagemaker. You can:

- create a new instance
- open or close an existing instance
- edit an existing instance

## Create a new instance

1. Select __Create notebook instance__ on the __Notebook instances__ page.
1. In the __Notebook instance setting__ section:
     - enter a valid __Notebook instance name__
     - choose an appropriate instance type depending on the amount of resources you require
1. Select the __Additional configuration__ menu to see more options.
1. The __Volume size in GB__ field defines the amount of storage available on your Sagemaker instance. Set this to a reasonable amount for storing data on your instance locally to the notebook. If you change this amount in future, you may lose any existing code and data on your instance.
1. In the __Permissions and encryption__ section, set the __IAM role__ to __govuk-integration-data-science-role__.
1. Select __Create notebook instance__.

You are now ready to use your newly created instance.

For more information on creating a new instance, see the [AWS documentation on creating an Amazon SageMaker Notebook Instance](https://docs.aws.amazon.com/sagemaker/latest/dg/gs-setup-working-env.html).

## Open an existing instance

1. Go to the __Notebook instances__ page. You will see a table of existing AWS Sagemaker instances.
1. In the __Actions__ column of the instance you want to open, select __Start__. AWS will then find the resources for your instance.
1. When the __Status__ of your instance shows __InService__, select the __Open Jupyter__ or __Open JupyterLab__ as needed to open the Jupyter or JupyterLab instance.

You have opened your instance.

## Close an existing instance

When you have finished with an instance, you should close that instance to minimise costs.

1. Go to the __Notebook instances__ page. You will see a table of existing AWS Sagemaker instances.
1. Select the radio button next to the name of the instance you want to close. To the right of the __Notebook instances__ title, the __Actions__ drop-down menu should become accessible.
1. In this drop-down menu, select __Stop__, and wait for the instance status to change to __Stopped__.

You have closed your instance.

## Edit an existing AWS Sagemaker instance

1. Double-click on the __Name__ of your instance you’d like to edit. You now should see the settings for this instance.
1. Select __Edit__ for the __Notebook instance settings__ and change any of the available options.
1. Once you’ve edited your instance, select __Update notebook instance__.

You have edited your instance.
