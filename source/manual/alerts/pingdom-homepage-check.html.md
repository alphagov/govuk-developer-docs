---
title: 'Pingdom homepage check'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# Pingdom homepage check

Pingdom monitors externally (from \~10 locations in Europe and America)
that it can connect to <https://www.gov.uk/>. If this fails it could
indicate that DNS for www.gov.uk is not working, our CDN has failed or
GOV.UK (particularly the Frontend application) and all the static
mirrors are inaccessible, which would probably qualify as a major
incident.

If you can confirm that GOV.UK is indeed globally inaccessible, then
this is probably cause to first alert other people who may be able to
help, then start troubleshooting to see if you can narrow down the
failure.

-   [Pingdom Twitter account](https://twitter.com/pingdom) - check if
    they have announced issues
-   [Fastly Service status](http://status.fastly.com/) - check if the
    CDN has global issues
-   [Carrenza status](https://servicedesk.carrenza.com/) - check if our
    main provider has issues
-   [Skyscape status](http://status.skyscapecloud.com/) - check if our
    Licensing hosting provider has issues

