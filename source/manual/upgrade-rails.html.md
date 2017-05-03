---
owner_slack: '#2ndline'
last_reviewed_on: 2017-04-28
review_in: 6 months
title: Upgrading Rails
section: Packaging
layout: manual_layout
parent: "/manual.html"
---

# Upgrade Rails

When upgrading our apps between Rails major and minor versions, follow the [official Rails guides][guide]

## Gotchas for upgrading to Rails 5.0

### Eager loading

Add `lib` to the autoload path if required, see [Travel Advice Publisher](https://github.com/alphagov/travel-advice-publisher/blob/453b81341dba646178b4421ddab705bdd36deb22/config/application.rb#L37)
for an example.

### Airbrake

Upgrading to Rails 5 requires upgrading the Airbrake gem. This breaks some compatibility with
our Errbit installation, namely that deployments are no longer recorded.

### Don't include ActionCable or Puma configs

We don't use these in production and are likely to cause conflicts.

[guide]: http://guides.rubyonrails.org/upgrading_ruby_on_rails.html
