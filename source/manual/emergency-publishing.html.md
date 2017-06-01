---
owner_slack: "#2ndline"
title: Deploy emergency publishing banners
parent: "/manual.html"
layout: manual_layout
section: Publishing
important: true
last_reviewed_on: 2017-05-23
review_in: 6 months
---

There are three types of events that would lead GOV.UK to add an emergency banner to the top of each page on the web site; a notable death, a national emergency or a local emergency.

The GOV.UK on-call escalations contact will tell you when you need to publish an emergency banner. They will ensure that the event is legitimate and provide you with the text for the emergency banner. They will also tell you what type of event it is; you do not need to determine the type of event yourself.

If you need to publish the emergency banner out of hours, you will be instructed to do so either by the GOV.UK on-call escalations contact or the Head of GOV.UK.

[Contact numbers for those people](https://github.digital.cabinet-office.gov.uk/pages/gds/opsmanual/2nd-line/contact-numbers-in-case-of-incident.html) are in the opsmanual on GitHub enterprise.

## Adding emergency publishing banners

<a name="prerequisites"></a>
### Prerequisites

Before publishing an emergency banner, you will need to know the following. The text required will be supplied by the GOV.UK on-call escalations contact:

#### Mandatory fields

- The emergency banner type or campaign class (one of `notable-death`,
  `national-emergency` or `local-emergency`)
- Text for the heading.

#### Optional fields

- Text for the 'short description', which is a sentence displayed under the heading. This is optional.
- A URL for users to find more information (it might not be provided at first).

<a name="set-up-fabric"></a>
### Set up your Fabric scripts

If you've not used them before, you'll need to clone [fabric-scripts](https://github.com/alphagov/fabric-scripts) and follow the setup instructions in the fabric-scripts README.

1) Make sure your copy of fabric-scripts is up to date and on master.

2) Activate your virtual environment for the Fabric scripts if you have set one up. If you have followed the setup guide for the Fabric scripts, this will be:

```
$ . ~/venv/fabric-scripts/bin/activate
```

3) Pick your environment, which can be `integration`, `staging`, or `production`. For example, for integration:

```
export environment=integration
```

### Deploy the banner using Jenkins

The data for the emergency banner is stored in Redis. Jenkins is used to set the variables.

1) Navigate to the appropriate deploy Jenkins environment (integration, staging or production)

2) Select the `Deploy the emergency banner` task.

3) Click `Build with Parameters` in the left hand menu.

4) Fill in the appropriate variables using the form presented by Jenkins. You should be using the information you gathered in the [prerequisites](#prerequisites).

5) Click `build`.

![Jenkins Deploy Emergency Banner](images/emergency_publishing/deploy_emergency_banner_job.png)

<a name="clear-template-cache"></a>
### Clear caching in frontend, static and whitehall-frontend

1) Run the Fabric task to clear the application template cache for frontend and
static:

```
fab $environment campaigns.clear_cached_templates
```

2) Clear the cache for whitehall-frontend by restarting memcached:

```
fab $environment class:whitehall_frontend app.restart:memcached
```

You may also need to restart `government-frontend` for Whitehall and Travel Advice pages:

```shell
fab staging class:frontend app.restart:government-frontend
```

<a name="test-with-cache-bust"></a>
### Test with cache bust strings

1) Test the changes by visiting pages and adding a cache-bust string. Remember to change the URL based on the environment you are testing in (integration, staging, production).

You can automate this by using the [emergency publishing scraper](https://github.com/alphagov/emergency-publishing-scraper)

- [https://www.gov.uk/?ae00e491](https://www.gov.uk/?ae00e491)
- [https://www.gov.uk/financial-help-disabled?7f7992eb](https://www.gov.uk/financial-help-disabled?7f7992eb)
- [https://www.gov.uk/government/organisations/hm-revenue-customs?49854527](https://www.gov.uk/government/organisations/hm-revenue-customs?49854527)
- [https://www.gov.uk/search?q=69b197b8](https://www.gov.uk/search?q=69b197b8)

Check the banner displays as expected and double check the information for the
header, short description and link are as they should be. Test the link if it is
present. Make sure the banner colour is appropriate - black for a notable death, red for
a national emergency, green for a local emergency.

If the banner information is not correct, re-run the Jenkins job to correct it.

<a name="purge-origin-cache"></a>
### Purge the caches and test again

1) Purge our entire origin cache:

```
fab $environment cache.ban_all
```

2) If you are in production environment, once the origin cache is purged, purge the CDN cache. At the time of writing, this can only be done one item at a time, and doesn’t work in staging or integration.

You can do so by giving a list of comma separated url paths, the following is a list of the 10 most used pages:

```
fab $environment
cdn.fastly_purge:/,/search,/state-pension-age,/jobsearch,/vehicle-tax,/government/organisations/hm-revenue-customs,/government/organisations/companies-house,/get-information-about-a-company,/check-uk-visa,/check-vehicle-tax
```

See [these instructions for more details](https://github.digital.cabinet-office.gov.uk/pages/gds/opsmanual/2nd-line/cache-flush.html) on
purging the cache.

3) Check that the emergency banner is visible when accessing the same pages as above but without a cache-bust string.

<a name="unset-env-var"></a>
### Unset your environment variable

1) Remember to unset your Fabric environment variable:

```
unset environment
```
---

## Removing emergency publishing banners

### Set up your Fabric scripts

Follow the instructions above to [set up your Fabric scripts](#set-up-fabric)

### Remove the banner using Jenkins

1) Navigate to the appropriate deploy Jenkins environment (integration, staging or production)

2) Select the `Remove the emergency banner` task.

3) Click `Build now` in the left hand menu.

![Jenkins Remove Emergency Banner](images/emergency_publishing/remove_emergency_banner_job.png)

### Clear application caches and restart Whitehall

Follow the instructions above to

- [Clear the application template cache and reload Whitehall](#clear-template-cache)
- [Test with cache bust strings](#test-with-cache-bust)
- [Purge the caches and test again](#purge-origin-cache)
- [Unset your environment variable](#unset-env-var)

---
## Troubleshooting

### Background

The information for the emergency banner is stored in Redis. [Static](https://github.com/alphagov/static) is responsible for displaying the data and we use Jenkins to run [rake tasks in static](https://github.com/alphagov/static/blob/master/lib/tasks/emergency_banner.rake) to set or delete  the appropriate hash in Redis.

### Manually testing the Redis key

You can manually check whether the data has been stored in Redis by the Jenkins job on one of the frontend machines.

From your development machine SSH into a frontend box appropriate to the environment you want to check

```
ssh frontend1.frontend.integration
```

Load a Rails console for static:

```
govuk_app_console static
```

Check the Redis key exists:

```
irb(main):001:0> Redis.new.hgetall("emergency_banner")
#> {}
```

In the above example the key has not been set. A sucessfully set key would return a result similar to the following:

```
irb(main):001:0> Redis.new.hgetall("emergency_banner")
=> {"campaign_class"=>"notable-death", "heading"=>"The heading", "short_description"=>"The short description", "link"=>"https://www.gov.uk"}
```

### Manually running the rake task to deploy the emergency banner

If you need to manually run the rake tasks to set the Redis keys for some reason, you can do so (remember to follow the instructions above to clear application template caches, restart Whitehall and purge origin caches afterwards):

1) SSH into a `frontend` machine appropriate to the environment you are
deploying the banner on. For example, for integration:

```
ssh frontend-1.frontend.integration
```

2) CD into the directory for `static`:

```
cd /var/apps/static
```

3) Run the rake task to create the emergency banner hash in Redis, substituting
the quoted data for the parameters:

```
sudo -u deploy govuk_setenv static bundle exec rake
emergency_banner:deploy[campaign_class,heading,short_description,link]
```

The `campaign_class` is directly injected into the HTML as a `class` and must be one of

* notable-death
* national-emergency
* local-emergency

For example, if you are deploying an emergency banner for which you have the
following information:

* Type: Death
* Heading: Alas poor Yorick
* Short description: I knew him Horatio
* URL: https://www.gov.uk

You would enter the following command:

```
sudo -u deploy govuk_setenv static bundle exec rake
emergency_banner:deploy["notable-death","Alas poor Yorick","I knew him
Horatio","https://www.gov.uk"]
```

Note there are no spaces after the commas between parameters to the rake task.

Quit your SSH session:

```
exit
```

### Manually running the rake task to remove an emergency banner

1) As above you first need to SSH into a frontend machine:

```
ssh frontend-1.frontend.integration
```

2) CD into the directory for `static`:

```
cd /var/apps/static
```

3) Run the rake task to remove the emergency banner hash from Redis:

```
sudo -u deploy govuk_setenv static bundle exec rake
emergency_banner:remove
```

4) Quit your SSH session

```
exit
```

---
## Types of emergency banners

### Death of a notable person

A large **black** banner is to be displayed on all GOV.UK pages, including the homepage.

The wording to use in the template will be the official title of the
deceased and the years of their life e.g. 'His Royal Highness Henry VIII
1491 to 1547'. The text should link to their official biography.

![GOV.UK Homepage](images/emergency_publishing/notable-death-homepage.png)

![](images/emergency_publishing/notable-death.png)

### National emergency (level 1 or category 2)

A large **red** banner is to be displayed on all GOV.UK pages, including the homepage.

![GOV.UK Homepage](images/emergency_publishing/national-emergency-homepage.png)

![](images/emergency_publishing/national-emergency.png)

### Localised large-scale emergency (level 2 or category 1)

A large **green** banner is to be displayed on all GOV.UK pages, including the homepage.

These incidents will not be processed outside of business hours.

![GOV.UK Homepage](images/emergency_publishing/local-emergency-homepage.png)

![](images/emergency_publishing/local-emergency.png)
