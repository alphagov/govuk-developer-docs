---
title: Generating a password for database users
layout: multipage_layout
---

# Generating a password for the database user

A **32-character password** is recommended, containing letters and numbers **only**. Avoid special characters that may need to be URL-encoded when the password is included in a database connection URL, such as `@`, `?`, `!` and `^`.

You can use a password generator, or the `pwgen` command:

```bash
pwgen -s 32 1
```
