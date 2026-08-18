---
owner_slack: "#govuk-developers"
title: Diagnose and fix Chromedriver and Chromium issues for failing frontend tests
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

If most or all of your frontend tests are crashing, then it could be for one of the following reasons:

1. The version of Chromedriver/Chromium being used by the Docker image is unstable.
2. The versions of Chromedriver and Chromium do not match.
3. The versions are not compatible with Selenium (or other testing tools).

To diagnose further, it's important to check which versions are being used.

## Check the chrome and driver versions

The following simple commands will display the versions for the browser and the driver:

```bash
chromium --version
chromedriver --version
```

The versions should match, if they don't, then this could be the cause. If another developer has a working version, you can also compare these version numbers with those for their environment.

### For more detailed information

Use either:

```bash
dpkg -l | grep chromium
```

Or:

```bash
apt-cache policy chromium chromium-driver
```

Once you know the version, check if there are any related bug reports for the version in use. E.g. [Debian bug list entry](https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg2110639.html)

## Adding logging to diagnose

If there doesn't appear to be any issues with the particular versions being used then you can add logging to help diagnose further.

Update the Capybara configuration (In Publisher this is in `support/govuk_test.rb`). The sections with comments will add the logging capability:

```ruby
GovukTest.configure

Capybara.register_driver :headless_chrome do |app|
  chrome_options = GovukTest.headless_chrome_selenium_options
  chrome_options.add_argument("--disable-web-security")
  chrome_options.add_argument("--no-sandbox")
  chrome_options.add_argument("--disable-dev-shm-usage")
  chrome_options.add_argument("--disable-gpu")

   # Adding logging options
  chrome_options.add_argument("--enable-logging")
  chrome_options.add_argument("--v=1")
  chrome_options.add_argument("--log-file=/tmp/chrome.log")

  service = Selenium::WebDriver::Service.chrome(
    args: [
      "--verbose",
      "--log-path=/tmp/chromedriver.log",
    ],  
  )
 # End of logging code

  Capybara::Selenium::Driver.new(  
    app,
    browser: :chrome,
    options: chrome_options,

    # Add this line here to include the service  
    service: service,
  )
end
```

Run the tests again to trigger the logging. Go to Docker desktop and choose the relevant container for the app (e.g. `publisher-lite`) then the 'Files' tab. From there, download the .log files relating to chrome from the `/tmp` folder.

Alternatively, navigate to the folder on a bash terminal in the container and save/open the files from there.

## Suggested Fixes

Downgrade the version of chromium and chrome-driver in the docker container to a stable one.  
This will cover Chromium, Chromium-Driver and its dependencies in one call. For example, if the version is 150.x, whereas the `/stable` branch is 147.x  then this procedure will downgrade your container versions to ones that match and are stable for local development.

You can do this by getting to the container console with `govuk-docker-run` and running

```bash
apt-get install -y --allow-downgrades chromium-driver/stable
```

Example output:

```bash
chromium chromium-common

The following packages will be DOWNGRADED:
  chromium chromium-common chromium-driver

0 upgraded, 0 newly installed, 3 downgraded, 0 to remove and 16 not upgraded.

Need to get 109 MB of archives.

After this operation, 14.4 MB disk space will be freed.

...
...
```
