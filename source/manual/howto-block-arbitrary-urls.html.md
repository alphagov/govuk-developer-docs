---
owner_slack: "#re-govuk"
title: Block access to arbitrary URLs in the GOV.UK estate
section: Security 
layout: manual_layout
parent: "/manual.html"
---
During a recent security incident it became necessary to block a GOV.UK
section in order to prevent access to sensitive data.

A quick way to achieve this is to manually add a `location` block to the NGINX
configuration on the cache machines or instances serving the affected pages.

In order to block `<LEAK_URL>` on `<INSTANCE_CLASS>` in `<GOVUK_ENVIRONMENT>`:

1. Find out which `<INSTANCE_CLASS>` serves `<LEAK_URL>`.

   - For GOV.UK content, this can be done via the content-api: `https://www.gov.uk/api/content/<LEAK_URL>` or by using the
   [GOV.UK browser extension](https://github.com/alphagov/govuk-browser-extension).
   - For external/independent applications, e.g. CKAN, you may need to consult the respective routing table to find out from which machine the content is served.
   - Another option to determine which machine class runs an app is to consult the [GOV.UK architecture overview](https://drive.google.com/a/digital.cabinet-office.gov.uk/file/d/1-O5XIIeDK-Mos_thA_hQODBQ6sYnToWs/view?usp=sharing).

1. Disable Puppet on the respective `<INSTANCE_CLASS>`, e.g. via Fabric:

   ```
   fab <GOVUK_ENVIRONMENT> class:<INSTANCE_CLASS> do:'govuk_puppet --disable "RE:GOV.UK Temporary override nginx.conf in order to block <LEAK_URL>"'
   ```

1. Edit `/etc/nginx/nginx.conf` on the `<INSTANCE_CLASS>` to add a location block
   to the server block, forcing to return `403 FORBIDDEN`, e.g.

   ```
   server {
   (...)
     location /<LEAK_URL>/ {
       return 403;
     }
   }
   ```

   Location blocks are not limited to absolute paths, but can also include regular expressions if prefixed by the `~` operator.
   See the additonal external documentation [here][Digital ocean] and [here][Linode] for examples.
   > Note:
   >
   > When using location blocks in general and regular expressions in particular
   > take extra care to not accidentally block unaffected pages as a side effect.
1. Test the NGINX configuration, e.g. via Fabric

   ```
   fab <GOVUK_ENVIRONMENT> class:<INSTANCE_CLASS>  do:'sudo service nginx configtest'
   ```

   If the configuration test is successful, e.g. returns `out: nginx: configuration file /etc/nginx/nginx.conf test is successful`

1. Reload the NGINX configuration, e.g. via Fabric

   ```
   fab <GOVUK_ENVIRONMENT> class:<INSTANCE_CLASS> do:'sudo service nginx restart'
   ```

1. To make sure the change of configuration was successful, try to browse `https://www.gov.uk/<LEAK_URL>`

1. To make the change permanent there are different options, ranging from additional vhost configuration inline in the respective
   Puppet class of the app ([example PR](https://github.com/alphagov/govuk-puppet/pull/9447))
   or introduce a separate NGINX configuration template for the app if more complex
   changes are required ([example PR](https://github.com/alphagov/govuk-puppet/pull/9485)).
   Alternatively, changes to the app may remove the offending content.
1. Finally, re-enable Puppet on the `<INSTANCE_CLASS>`, e.g. via Fabric:

   ```
   fab <GOVUK_ENVIRONMENT> class:<INSTANCE_CLASS>  do:'govuk_puppet --enable'
   ```

- [Digital ocean]: https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms
- [Linode]: https://www.linode.com/docs/web-servers/nginx/how-to-configure-nginx/#location-blocks
