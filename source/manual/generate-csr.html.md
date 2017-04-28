---
owner_slack: "#2ndline"
title: Generate a Certificate Signing Request (CSR) for GOV.UK
section: Environments
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/generate-csr.md"
last_reviewed_at: 2017-02-24
review_in: 6 months
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/generate-csr.md)


# Generate a Certificate Signing Request (CSR) for GOV.UK

When buying an SSL certificate for a GOV.UK domain, a certificate
signing request is required.

## Generating the CSR

Execute the following on a POSIX-compliant machine, for example your
Mac:

    DOMAIN_NAME=example.service.gov.uk sh -c 'openssl req -nodes -newkey rsa:2048 -keyout ${DOMAIN_NAME//[^a-zA-Z0-9]/_}.key -out ${DOMAIN_NAME//[^a-zA-Z0-9]/_}.csr -subj "/C=GB/ST=England/L=London/O=UK government/OU=Government Digital Service/CN=${DOMAIN_NAME}/"'

Be sure to replace the value 'example.service.gov.uk' set in the
'DOMAIN\_NAME' environment variable to the domain name the SSL
certificate is intended for.

The contents of the .key file must be kept secret. You most likely will
want to store its contents encrypted in the
[deployment](https://github.gds/gds/deployment) repository.

The contents of the CSR should be shared with the SSL certificate
provider. This allows them to generate the SSL certificate.
