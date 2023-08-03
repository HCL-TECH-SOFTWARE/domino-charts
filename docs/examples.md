# Domino deployments – Examples

Use the following examples as an inspiration for creating your own values files for deploying the Domino server according to your needs.

You will probably need to combine multiple examples to create the final file - for example: using the persistent volume + enabling Ingress for HTTP + opening the port for NRPC + reusing existing IDs


**Importatnt** \
The examples share the same deployment name, sometimes the hostname or ports.
Before you try an example, uninstall the previous example with this command:
```
helm uninstall alpha --namespace domino
```


## Default – For testing the basics

**Start here.**

Just the Helm chart default values. \
Creates a new Domino server in a new Domino domain. \
Web access (via Ingress) is enabled.

**Usecase:** Primary for testing the environment. The server has no persistent volume attached, so the Domino data directory is lost when a pod is recreated. You can continue with more complex configurations once you deploy a Domino server with the default values.

**Filename:** `none`

**Command:**

```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --set image.imageCredentials.registry=registry.company.com \
  --atomic
```

Check that you deployed the Domino pod correctly:
```
kubectl logs -n domino alpha-domino-0
```

Since we did not specify a correct hostname nor expose any ports, you cannot connect to Domino yet. \
Try the following examples that allow you to parametrize your Domino to enable access from a web browser or a Notes client.


## Organization, server, and domain names

Creates a new Domino server in a new Domino domain, with custom organazation name, server name and administrator name.


**Usecase:** You will use these parameters in almost all server deployments.

**Filename:** `name-org-server-admin.yaml`

**Command:**

```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/name-org-server-admin.yaml \
  --atomic
```


## Persistent volume

Creates a Persistent Volume Claim and assigns it to the Domino pod. You need to specify a StorageClass, provided by your Kubernetes provider.

**Add these settings to all servers where you want to keep the Domino data directory.**

**Usecase:** You need to add Persistent Volume to all your Domino servers in production.

**Filename:** `persistent-volume.yaml`

**Command:**

```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/persistent-volume.yaml \
  --atomic
```

## Web access – Ingress with Let's Encrypt 

Creates an Ingress rule that forwards HTTP requests from the Internet to your Domino pod through an Ingress Controller.
Note: The Ingress Controller must already be deployed in the Kubernetes cluster.
If you do not have one, try [Ingress NGINX](../scripts/deploy-nginx.sh).
You have to specify the Ingress class in the values YAML file.

**Important** \
If you want to use cert-manager to obtain a Let's Encrypt TLS certificate for your Domino server,
you must enable and configure Ingress and cert-manager in ['domino-shared'](../charts/domino-shared/README.md) Helm chart.

**Add these settings to all servers where you want to expose Domino web through Ingress Controller.**

**Usecase:** You want to allow web access to your Domino server.

**Filename:** `ingress-domino.yaml`

**Command:**

```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/ingress-domino.yaml \
  --atomic
```

## Nomad Web access

The same as the previous example (Web access – Ingress with Let's Encrypt ), but this time we also expose Nomad web \
through the Ingress Controller.
The special setting is needed because the Nomad server on Domino does not use the Domino HTTP stack - it uses its stack and \
use the default port 9443.

**Add these settings to all servers where you want to expose the Nomad server through Ingress Controller.**

**Usecase:** You want to allow access to Nomad web running on your Domino server.

**Filename:** `ingress-nomad.yaml`

**Command:**

```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/ingress-nomad.yaml \
  --atomic
```


## NRPC access
Domino uses NRPC protocol (port 1352) to communicate between the Notes client and the Domino server and between two Domino servers.
The protocol cannot be passed through an Ingress Controller and has to be exposed directly.
You can use the Service type ClusterIP in the test environment, but in production, it will be probably LoadBalancer.
Your Kubernetes cloud provider handles these services and creates public IP addresses for them.

**Add these settings to all servers where you want to expose NRPC protocol.**

**Usecase:** You want to allow access to your Domino via a native NRPC protocol.

**Filename:** `lb-nrpc.yaml`

**Command:**

```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/lb-nrpc.yaml \
  --atomic
```


## Reinstalling server with existing IDs (cert, server, admin)
Creates a Domino server with existing identities. \
Uses existing cert.id, server.id and admin.id. \

**Usecase:** Good for dev / testing / education servers where you want to reuse existing server identity. \
Also, an example of config values that you can reuse in more complex server configurations.

**Filename:** `existing-ids.yaml`

**Command:**
```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/existing-ids.yaml \
  --set-file files.certID=examples/ids/Space/cert.id \
  --set-file files.serverID=examples/ids/Space/server-alpha.id \
  --set-file files.adminID=examples/ids/Space/admin.id \
  --atomic
```


## New server with existing IDs (cert, admin)    TODO
Creates new Domino server, in a new Domino domain. \
Uses existing cert.id and admin.id.

**Usecase:** Good for dev / testing / education servers, where you want to reuse existing admin ID.

**Filename:** `existing-admin.yaml`

**Command:**
```
helm upgrade alpha domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/existing-admin.yaml \
  --set-file files.certID=examples/ids/cert.id \
  --set-file files.adminID=examples/ids/admin.id \
  --atomic
```
