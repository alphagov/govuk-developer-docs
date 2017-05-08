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

By default Rails 5 disables autoloading in production and uses eager load, this
[blog post][rails-5-autoloading] explains further.

The effect this can have is that classes that need the `autoload_paths` altered -
for instance at the root of `lib` - will no longer work in production, but will
still load in development (this has already caused a production issue).

The solution is append to `eager_load_paths` rather than `autoload_paths` which
will ensure the classes are loaded in both production and development. See
[Publishing API Example][publishing-api-autoload-change].

### Airbrake

Upgrading to Rails 5 requires upgrading the Airbrake gem to avoid deprecation 
warnings about middleware. However, Airbrake 5 breaks some compatibility with
our Errbit installation, namely that deployments are no longer recorded.

Instead of upgrading to a released version of the Airbrake 5 gem you can use
[a branch in our fork of Airbrake](https://github.com/alphagov/airbrake/tree/silence-dep-warnings-for-rails-5).
This is 4.3.8 of the gem with a small change to silence the warnings:

    gem 'airbrake', github: 'alphagov/airbrake', branch: 'silence-dep-warnings-for-rails-5'

### Don't include ActionCable or Puma configs

We don't use these in production and are likely to cause conflicts.

[guide]: http://guides.rubyonrails.org/upgrading_ruby_on_rails.html
[rails-5-autoloading]: http://blog.bigbinary.com/2016/08/29/rails-5-disables-autoloading-after-booting-the-app-in-production.html
[publishing-api-autoload-change]: https://github.com/alphagov/publishing-api/pull/553/files
