---
title: Manage state in your app
weight: 41
layout: multipage_layout
---

# Manage state in your app

## Troubleshooting

### Argo application sync stuck waiting for "waiting for completion of hook"

An Argo application may appear to be stuck at the syncing stage, whilst waiting for the completion of a hook from a job that is not running. In this situation you may need to cancel the sync operation.

You can cancel the sync operation using the Argo UI.

1. Sign into [Argo](https://argoproj.github.io/).
1. Choose the app tile from the list of __Applications__.
1. Select __Sync Status__ to reveal a table of information about the sync.
1. Select __Terminate__ from the modal to cancel the sync operation.
1. Re-sync the application by selecting __Sync__.

This should re-initiate the sync event and recreate the job needed to complete the sync.
