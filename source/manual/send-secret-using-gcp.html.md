---
owner_slack: "#govuk-developers"
title: Send a secret safely using GCP
section: Security 
layout: manual_layout
parent: "/manual.html"
---

On occasion, you will need to send something secret (an API token, for example) to another engineer.
Whilst it might be tempting to send it in plaintext via email or Slack, it is safer to encrypt it via GPG.

1. Get the GPG ID of the recipient, e.g. from `~/govuk/govuk-secrets/pass/2ndline/.gpg-id`.
   The recipient can find their GPG ID by running `gpg --list-signatures | grep -B 2 NAME_OF_RECIPIENT`.

2. Import the recipient's public key. It's likely already imported if you've worked with govuk-secrets, but if not:
   GPG Keychain -> Lookup Key -> Search -> Import.
   Alternatively, fetch the public key using the ID (`gpg --armor --export '<GPG ID>' > tmp.asc`)
   and then import it into your keychain: `gpg --import tmp.asc`. (You can remove the temporary file afterwards).

3. Now you can encrypt your message (ASCII only) for the recipient, e.g.:

```
$ gpg -e -a -r 770349DF2DFFFA812CBDF0DE8E68D9ADD8BB46B1 # use the GPG ID of the recipient
# The command will look like it's hanging, but it's just waiting for input.
# Write/paste your secret, then CTRL+D to submit it.
```

You'll see output something like:

```
-----BEGIN PGP MESSAGE-----
hQIMAxoIiDtX/9hDARAAiwfoPDoymfS3fSjSizffV7IeIbkZDbE7Jq+hKlcy4Hc/
4T0J7sHLNwe1sg+QlqEbjU+px163qo9eAxE0zUKV16+kTxG7ef3fBU1kpMGPjpSl
0lUI5xB8xPa5YTcrFyFu4WFk1HpHzOdcDRK+xAolkN6yep9N9TLGkdk3CQV3fGtL
ksyW/YJvHpzUIM8/Er/r123W0slTQQOsG3QUeDnmR20PzoSh8aDvlKx8OgwR82/S
HNCuWXPDBD8Nj/+NpxnRciJjW/eTtCXpBycbdG3gjC4zxJPupoBx7tJDmdhTZdRM
FxPAtyiJPK9ylyNQCfXF3YcylyV/GXWyjzCC+ClccSh3AZHV/P+04pBiOShzD4bS
TgG7oLFR+1KZEUsRYgEMb4VyJYxO+ZM6LrdUWiQgi/wF2JjxbKpa4Wvb9qxg/Swq
v9pLL/7B7D4OMPyrW/NnrUUKfKQKckdH0u6cO9bSCg==
=3AgW
-----END PGP MESSAGE-----
```

4. Send the output to the recipient. They should run `gpg -d` & paste the entire message above (followed by CTRL+D), to get the decrypted value.
