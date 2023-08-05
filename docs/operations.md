---
layout: default
title: Operations
nav_order: 3
description: "Operations - admin tasks"
has_children: false
---

# Operations - admin tasks

Tips for admin operations and maintenance tasks for Domino on Kubernetes.

## Download files from the pod
**Use case:** Download ID files from newly created Domino server.

```shell
kubectl cp domino/alpha-domino-0:/local/notesdata/cert.id cert.id
kubectl cp domino/alpha-domino-0:/local/notesdata/server.id server-alpha.id
kubectl cp domino/alpha-domino-0:/tmp/admin.id admin.id
```

Note: Admin ID is created in /tmp directory.


## Access OS inside the pod
**Use Case:** Connect to the server, stop Domino and perform compact or fixup on a local database.

```shell
# Connect to the pod
kubectl exec -it alpha-domino-0 -n domino -- bash

# Stop the Domino server
domino status
domino stop
domino status

# Perform the task
cd /local/notesdata
/opt/hcl/domino/bin/fixup names.nsf
/opt/hcl/domino/bin/compact names.nsf

# Start the Domino server
domino start
domino status

# Exit from the pod console
exit
```

## Expand Persistent Volume Claim
**Use Case:** Increase the size of Domino Data folder

```shell
kubectl patch pvc dominodata-alpha-domino-0 -n domino -p '{"spec": {"resources": {"requests": {"storage": "10Gi"}}}}'
```