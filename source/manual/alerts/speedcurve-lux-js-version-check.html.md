---
owner_slack: "#govuk-2ndline-tech"
title: SpeedCurve LUX JavaScript version check
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# SpeedCurve LUX JavaScript version check

GOV.UK makes uses of a frontend performance tool, [SpeedCurve Live User Experience (LUX)][speedcurve], this is provided by a [JavaScript file provided by govuk_publishing_components][js-file]. Typically the SpeedCurve LUX JavaScript is hosted by SpeedCurve we, however, [we host a copy ourselves][self-hosting] for security. Therefore we have to try keep our self-hosted copy up-to-date with the one SpeedCurve host.

This alert fires when the version of lux.js that SpeedCurve is hosting has a different version number to what we expect. This indicates we are hosting an out of date version of lux.js, which lead to problems with the data we are recording.

## To resolve this alert

1. Establish the current version number of lux.js from <https://app.speedcurve.com/updates/>
1. Find the [lux-reporter.js][js-file] in govuk_publishing_components
1. Download the source code of lux.js from <https://cdn.speedcurve.com/js/lux.js?id=47044334>
1. Run the source code through a tool to deminifiy it, such as <https://beautifier.io/>
1. Replace the corresponding section of lux-reporter.js with the deminified code
1. Raise a pull request with the changes to govuk_publishing_components and seek review from a frontend developer familiar with GOV.UK's SpeedCurve integration
1. Update the [Jenkins check][] to have the current version number that you identified in the first step, raise a PR for this change
1. Ensure that govuk_publishing_components is released with the new version of lux-reporter.js and that Static is deployed with it
1. Ensure that puppet is deployed with the updated Jenkins check to resolve the alert

[speedcurve]: https://www.speedcurve.com/features/performance-monitoring/
[js-file]: https://github.com/alphagov/govuk_publishing_components/blob/main/app/assets/javascripts/govuk_publishing_components/vendor/lux/lux-reporter.js
[self-hosting]: https://support.speedcurve.com/docs/self-hosted-real-user-monitoring
[Jenkins check]: https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_jenkins/templates/jobs/speedcurve_lux_js_version_check.yaml.erb
