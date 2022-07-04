---
owner_slack: "#govuk-developers"
title: 'Content Security Policy on GOV.UK'
section: Security
layout: manual_layout
parent: "/manual.html"
---

Content Security Policy (CSP) is a browser standard to prevent cross-site scripting (XSS), clickjacking and other code
injection attacks resulting from execution of malicious content in the context of another website. A policy, determining
which stylesheets, scripts and other assets are allowed to run, is sent with every request and is parsed and enacted by
the browser.

CSP can be run in two modes - *report only*, where violations of the policy are reported to a given endpoint but
allowed to execute, and *enforcement*, where violations are blocked.

## How the policy is set

The specific policy that is sent with a request to the browser as an HTTP header is defined in the
[`govuk_app_config` gem](https://github.com/alphagov/govuk_app_config/blob/master/lib/govuk_app_config/govuk_content_security_policy.rb)
which is included in all frontend apps. This central definition means the entire site has a single policy,
and changes can be rolled out more easily.

Each frontend app has an [initialiser](https://github.com/alphagov/government-frontend/blob/master/config/initializers/csp.rb)
which invokes the CSP setting code in the gem.

## How violations are reported

In all production-like environments (production, staging, integration), CSP is running in report only mode while more
information is gathered about which parts of the site currently rely on behaviour that would be blocked by an enforced
CSP.

In other environments such as development and test, CSP is running in enforcement mode to allow errors to be captured
at an early stage.
