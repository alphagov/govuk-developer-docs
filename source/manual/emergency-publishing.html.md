---
owner_slack: "#govuk-2ndline"
title: Deploy emergency publishing banners
parent: "/manual.html"
layout: manual_layout
section: Publishing
important: true
last_reviewed_on: 2018-03-05
review_in: 3 months
---

There are three types of events that would lead GOV.UK to add an emergency banner to the top of each page on the web site; a notable death, a national emergency or a local emergency.

The GOV.UK on-call escalations contact will tell you when you need to publish an emergency banner. They will ensure that the event is legitimate and provide you with the text for the emergency banner. They will also tell you what type of event it is; you do not need to determine the type of event yourself.

If you need to publish the emergency banner out of hours, you will be instructed to do so either by the GOV.UK on-call escalations contact or the Head of GOV.UK.

[Contact numbers for those people](https://github.com/alphagov/govuk-legacy-opsmanual/blob/master/2nd-line/contact-numbers-in-case-of-incident.md) are in the legacy Opsmanual in a private repo.

## Adding emergency publishing banners

<a name="prerequisites"></a>
### 1. Content you will need

The GOV.UK on-call escalations contact will supply you with:

- The emergency banner type or campaign class (one of `notable-death`,
  `national-emergency` or `local-emergency`)
- Text for the heading.
- (Optional) Text for the 'short description', which is a sentence displayed under the heading. This is optional.
- (Optional) A URL for users to find more information (it might not be provided at first).
- (Optional) Link text that will be displayed for the more information URL (this will
  default to "More information" if you do not supply it).

<a name="set-up-fabric"></a>
### 2. Set up your Fabric scripts

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
> **NOTE:** You must remember to [unset your Fabric environment variable](#unset-your-environment-variable-and-deactivate-your-virtual-environment) once you have finished running your tasks.

4) If you'd like to double check the environment you have set:
```
echo $environment
```

### 3. Deploy the banner using Jenkins

The data for the emergency banner is stored in Redis. Jenkins is used to set the variables.

1) Go to the Jenkins task:

  - [Deploy the emergency banner on Integration](https://deploy.integration.publishing.service.gov.uk/job/deploy-emergency-banner/)
  - [Deploy the emergency banner on Staging](https://deploy.staging.publishing.service.gov.uk/job/deploy-emergency-banner/)

2) Fill in the appropriate variables using the form presented by Jenkins

3) Click `Build`.

![Jenkins Deploy Emergency Banner](images/emergency_publishing/deploy_emergency_banner_job.png)

<a name="clear-template-cache"></a>
### 4. Clear caching in frontend, static and whitehall-frontend

1) Run the Fabric task to clear the application template cache for frontend and
static:

```
fab $environment campaigns.clear_cached_templates
```

2) Clear the cache for whitehall-frontend and frontend by restarting memcached:

```
fab $environment class:whitehall_frontend app.restart:memcached
fab $environment class:frontend app.restart:memcached
```

> **NOTE:** The main page updates immediately, however whitehall and travel advice can take a couple of minutes before the banner appears.

<a name="test-with-cache-bust"></a>
### 5. Test with cache bust strings

Test the changes by visiting pages and adding a cache-bust string. Remember to change the URL based on the environment you are testing in (integration, staging, production).

You can automate this by using the [emergency publishing scraper](https://github.com/alphagov/emergency-publishing-scraper)

- [https://www.gov.uk/?ae00e491](https://www.gov.uk/?ae00e491) ([Staging](https://www-origin.staging.publishing.service.gov.uk/?ae00e491))
- [https://www.gov.uk/financial-help-disabled?7f7992eb](https://www.gov.uk/financial-help-disabled?7f7992eb) ([Staging](https://www-origin.staging.publishing.service.gov.uk/financial-help-disabled?7f7992eb))
- [https://www.gov.uk/government/organisations/hm-revenue-customs?49854527](https://www.gov.uk/government/organisations/hm-revenue-customs?49854527) ([Staging](https://www-origin.staging.publishing.service.gov.uk/government/organisations/hm-revenue-customs?49854527))
- [https://www.gov.uk/search?q=69b197b8](https://www.gov.uk/search?q=69b197b8) ([Staging](https://www-origin.staging.publishing.service.gov.uk/search?q=69b197b8))

- Check the banner displays as expected
- Double check the information for the header, short description and link are as they should be
- Test the link if it is present
- Make sure the banner colour is appropriate - black for a notable death, red for
a national emergency, green for a local emergency.

If the banner doesn't show [look at the troubleshooting chapter](#the-banner-is-not-showing--not-clearing)

<a name="purge-origin-cache"></a>
### 6. Purge the caches and test again

1) Purge our entire origin cache:

```
fab $environment class:cache cache.ban_all
```

2) If you are in production environment, once the origin cache is purged, purge the CDN cache. At the time of writing, this can only be done one item at a time, and doesn’t work in staging or integration.

You can do so by giving a list of comma separated url paths, the following is a list of the 10 most used pages:

```
fab $environment class:cache cdn.fastly_purge:/,/search,/state-pension-age,/jobsearch,/vehicle-tax,/government/organisations/hm-revenue-customs,/government/organisations/companies-house,/get-information-about-a-company,/check-uk-visa,/check-vehicle-tax
```

See [these instructions for more details](/manual/cache-flush.html) on purging the cache.

3) Check that the emergency banner is visible when accessing the same pages as before but without a cache-bust string.

- [https://www.gov.uk/](https://www.gov.uk/) ([Staging](https://www-origin.staging.publishing.service.gov.uk/))
- [https://www.gov.uk/financial-help-disabled](https://www.gov.uk/financial-help-disabled) ([Staging](https://www-origin.staging.publishing.service.gov.uk/financial-help-disabled))
- [https://www.gov.uk/government/organisations/hm-revenue-customs](https://www.gov.uk/government/organisations/hm-revenue-customs) ([Staging](https://www-origin.staging.publishing.service.gov.uk/government/organisations/hm-revenue-customs))
- [https://www.gov.uk/search](https://www.gov.uk/search) ([Staging](https://www-origin.staging.publishing.service.gov.uk/search))

<a name="unset-env-var"></a>
### 7. Unset your environment variable and deactivate your virtual environment

1) Remember to unset your Fabric environment variable:

```
unset environment
```

2) Deactivate your virtual environment:

```
deactivate
```
---

## Removing emergency publishing banners

### 1. Set up your Fabric scripts

Follow the instructions above to [set up your Fabric scripts](#set-up-fabric)

### 2. Remove the banner using Jenkins

1) Navigate to the appropriate deploy Jenkins environment (integration, staging or production):

  - [Remove the emergency banner from Integration](https://deploy.integration.publishing.service.gov.uk/job/remove-emergency-banner/)
  - [Remove the emergency banner from Staging](https://deploy.staging.publishing.service.gov.uk/job/remove-emergency-banner/)

2) Click `Build now` in the left hand menu.

![Jenkins Remove Emergency Banner](images/emergency_publishing/remove_emergency_banner_job.png)

### 3. Clear application caches and restart Whitehall

Follow the instructions above to

- [Clear the application template cache and reload Whitehall](#clear-template-cache)
- [Test with cache bust strings](#test-with-cache-bust)
- [Purge the caches and test again](#purge-origin-cache)
- [Unset your environment variable](#unset-env-var)

> HELP, the banner won't go away. Try out some handy [hints and
> tips](#the-banner-is-not-showing--not-clearing)

---
## Troubleshooting

### Background

The information for the emergency banner is stored in Redis. [Static](https://github.com/alphagov/static) is responsible for displaying the data and we use Jenkins to run [rake tasks in static](https://github.com/alphagov/static/blob/master/lib/tasks/emergency_banner.rake) to set or delete  the appropriate hash in Redis.

### The banner is not showing / not clearing

Usually this is because the caching has not cleared properly. This can be at
various points in our stack as well as locally in your browser. Things to try:

- Make sure you are actually looking at a page on the environment you released
  the banner. All the links in this document go to the production version of
  GOV.UK. Remember to use the equivalent page for the environment (often staging)
  on which you are testing/releasing the banner.
- Test the page with `curl` to circumvent any browser based in memory caching.
  Chrome seems to aggressively cache on occasion. You can also test in an
  incognito browser instance.
- It is possible that the caching layers for the GOV.UK stack have evolved and
  we need to tweak the fabric scripts to clear new caches that have been set up.

### Manually testing the Redis key

You can manually check whether the data has been stored in Redis by the Jenkins job on one of the frontend machines.

1) From your development machine SSH into a frontend box appropriate to the environment you want to check.

For staging or production:
```
ssh frontend-1.frontend.staging
```

for integration:

```
ssh $(ssh integration "govuk_node_list --single-node -c frontend").integration
```

2) Load a Rails console for static:

```
govuk_app_console static
```

3) Check the Redis key exists:

```
irb(main):001:0> Redis.new.hgetall("emergency_banner")
#> {}
```

In the above example the key has not been set. A sucessfully set key would return a result similar to the following:

```
irb(main):001:0> Redis.new.hgetall("emergency_banner")
=> {"campaign_class"=>"notable-death", "heading"=>"The heading", "short_description"=>"The short description", "link"=>"https://www.gov.uk", "link_text"=>"More information about the emergency"}
```

### Manually running the rake task to deploy the emergency banner

If you need to manually run the rake tasks to set the Redis keys for some reason, you can do so (remember to follow the instructions above to clear application template caches, restart Whitehall and purge origin caches afterwards):

1) SSH into a `frontend` machine appropriate to the environment you are
deploying the banner on. For example, for integration:

```
ssh $(ssh integration "govuk_node_list --single-node -c frontend").integration
```

for staging or production:

```
ssh frontend-1.frontend.staging
```

2) CD into the directory for `static`:

```
cd /var/apps/static
```

3) Run the rake task to create the emergency banner hash in Redis, substituting
the quoted data for the parameters:

```
sudo -u deploy govuk_setenv static bundle exec rake
emergency_banner:deploy[campaign_class,heading,short_description,link,link_text]
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
* Link text: Click for more information

You would enter the following command:

```
sudo -u deploy govuk_setenv static bundle exec rake
emergency_banner:deploy["notable-death","Alas poor Yorick","I knew him
Horatio","https://www.gov.uk","Click for more information"]
```

Note there are no spaces after the commas between parameters to the rake task.

Quit your SSH session:

```
exit
```

### Manually running the rake task to remove an emergency banner

1) As above you first need to SSH into a frontend machine:

for staging or production:

```
ssh frontend-1.frontend.staging
```

for integration:

```
ssh $(ssh integration "govuk_node_list --single-node -c frontend").integration
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

#### GOV.UK Homepage
![GOV.UK Homepage](images/emergency_publishing/notable-death-homepage.png)

#### Other pages
![](images/emergency_publishing/notable-death.png)

### National emergency (level 1 or category 2)

A large **red** banner is to be displayed on all GOV.UK pages, including the homepage.

#### GOV.UK Homepage
![GOV.UK Homepage](images/emergency_publishing/national-emergency-homepage.png)

#### Other pages
![](images/emergency_publishing/national-emergency.png)

### Localised large-scale emergency (level 2 or category 1)

A large **green** banner is to be displayed on all GOV.UK pages, including the homepage.

These incidents will not be processed outside of business hours.

#### GOV.UK Homepage
![GOV.UK Homepage](images/emergency_publishing/local-emergency_homepage.png)

#### Other pages
![](images/emergency_publishing/local-emergency.png)
