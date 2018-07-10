---
owner_slack: "#govuk-2ndline"
title: Fix issues with installing Ruby gems using Bundler
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-10
review_in: 6 months
---

If you have an older version of RubyGems installed in your development VM, you may see errors such as the following when attempting to run `bundle`:

```
Gem::FilePermissionError: You don't have write permissions for the
/tmp/user/1000/bundler20180710-1078-kd7bl1rake-12.3.1/bin directory.
An error occurred while installing rake (12.3.1), and Bundler cannot continue.
Make sure that `gem install rake -v '12.3.1' --source 'http://rubygems.org/'` succeeds before
bundling.
```

To fix these errors, upgrade RubyGems for each Ruby version installed in the VM by running `sudo gem update --system`.

Run this command in the root folder of each app which displays errors when running `bundle` since they may be using different versions of Ruby with their own old copy of RubyGems.
