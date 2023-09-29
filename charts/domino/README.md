# domino

A Helm chart for HCL Domino server

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 12.02.0](https://img.shields.io/badge/AppVersion-12.02.0-informational?style=flat-square)

## Prerequisites

- Kubernetes cluster 1.18+
- Helm 3.0.0+
- [Persistent Volumes (PV)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) provisioner support in the underlying infrastructure.
- Domino container image, created with the [domino-container](https://github.com/HCL-TECH-SOFTWARE/domino-container) building script and uploaded to a private container registry.

Optional:
- [Ingress NGINX](https://kubernetes.github.io/ingress-nginx/)
- [cert-manager](https://cert-manager.io/) (to manage Let's Encrypt certificates for Ingress NGINX)

## Installation

### Add Helm Repository

```
helm repo add domino-charts https://opensource.hcltechsw.com/domino-charts/
helm repo update
```

### Deploy shared components

- Domino deployment requires some components (`domino-shared`) that are shared by all Domino pods in the Kubernetes cluster.
  These components have to be installed once, before you deploy your first Domino server.
- Follow the installation steps in the chart [README](../domino-shared/README.md).

### Configure the chart

- Create your config file with values. You can copy one of the demo files in the `examples` folder and update the values.
- Or you can download the default values file and update it:
```
helm show values domino-charts/domino > myvalues.yaml
```
- (Optional) Copy ID files to the dedicated folder.

### Install Domino server with the chart

Run the command:

```
helm upgrade <server_name> domino-charts/domino \
  --install \
  --namespace <namespace> \
  --create-namespace \
  --values examples/<server_name>.yaml \
  --set-file files.certID=cert.id \
  --set-file files.serverID=server.id \
  --set-file files.adminID=admin.id

```

`<server_name>.yaml` is your config file with custom values.

*Note:* Use `--set-files` parameters only if you want to use one or more existing IDs.

**Example:**

```
helm upgrade castor domino-charts/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/castor-lke.yaml \
  --set-file files.certID=examples/ids/cert.id \
  --set-file files.serverID=examples/ids/server-castor.id \
  --set-file files.adminID=examples/ids/admin.id
```

## Uninstallation

To uninstall/delete the `<server_name>` deployment:
```
helm uninstall <server_name> -n <namespace>
```

**Example:**
```
helm uninstall castor -n domino
```

## Configuration

The following table lists the configurable parameters of the Domino chart and the default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.createIssuer | bool | `true` | Should ClusterIssuer resource for Let's Encrypt be crearted? |
| certManager.leCertificate | string | `"staging"` | Type of Let's Encrypt certificate authority ("staging" or "prod") |
| certManager.leEmail | string | `"name@example.com"` | Email used when creating a profile for Let's Encrypt |
| domino.admin.firstName | string | `"Super"` | Administrator first name |
| domino.admin.idFileName | string | `"admin.id"` | Admin ID filename. Used when useExistingAdminID = true. |
| domino.admin.lastName | string | `"Admin"` | Administrator last name |
| domino.admin.password | string | `"SecretAdminPassw0rd"` | Admin ID password |
| domino.admin.useExistingAdminID | bool | `false` | Set "true" if you want to use the existing admin.id |
| domino.appConfiguration.daos.enabled | bool | `false` |  |
| domino.appConfiguration.daos.minObjSize | string | `"256000"` |  |
| domino.appConfiguration.webLoginForm | string | `"$$LoginUserFormMFA"` | Name of the form that should be used as a login form (Example: DWALoginForm, $$LoginUserFormMFA) |
| domino.appConfiguration.webLoginFormDB | string | `"domcfg.nsf"` | Filename of the NSF database where the webLoginForm is stored (Example: iwaredir.nsf, domcfg.nsf) |
| domino.existingServer.CN | string | `""` | Server common name of the existing server to use to replicate the directory (example: "AdminServer") |
| domino.existingServer.hostNameOrIP | string | `""` | Server DNS hostname or IP address of the existing server. |
| domino.idVault.idPassword | string | `"SecretVaultPassw0rd"` | ID Vault password |
| domino.network.hostName | string | `"domino.example.com"` | Server DNS hostname |
| domino.org.certifierPassword | string | `"SecretOrgPassw0rd"` | Cert ID password |
| domino.org.idFileName | string | `"cert.id"` | Cert ID filename. Used when useExistingCertifierID = true. |
| domino.org.orgName | string | `"DemoOrg"` | Organization name ("DemoOrg" in "Domino/DemoOrg @ DemoDomain") |
| domino.org.useExistingCertifierID | bool | `false` | Set "true" if you want to use existing cert.id |
| domino.security.createMicroCA | bool | `false` | Should a MicroCA be created, with the same name as Domino Organization? |
| domino.server.domainName | string | `"DemoDomain"` | Domain name ("DemoDomain" in "Domino/DemoOrg @ DemoDomain") |
| domino.server.idFileName | string | `"server.id"` | Server ID filename. Used when useExistingServerID = true. |
| domino.server.name | string | `"Domino"` | Server common name ("Domino" in "Domino/DemoOrg @ DemoDomain") |
| domino.server.serverTasks | string | `"replica,router,update,amgr,adminp,http,nomad"` | Domino tasks that you want to run at the server. The content will be set as ServerTasks= in the notes.ini. |
| domino.server.serverTitle | string | `"Demo Server"` | Server title (description) |
| domino.server.type | string | `"first"` | Server type ("first" or "additional" ) |
| domino.server.useExistingServerID | bool | `false` | Set "true" if you want to use the existing server.id |
| image.imageCredentials.registry | string | `"registry.example.com"` | Hostname of a private container registry |
| image.imagePullPolicy | string | `"IfNotPresent"` | When should be image pulled from the registry: "Always", "IfNotPresent", "Never" |
| image.name | string | `"hclcom/domino"` | Name of the Domino server container image |
| image.tag | string | `"latest"` | Tag of the Domino server container image (usually a version number or "latest") |
| ingress.class | string | `"nginx"` | Ingress class. Must match "kubectl get ingressclass". |
| ingress.enabled | bool | `true` | Should Domino HTTP traffic be exposed through Ingress Controller? |
| ingress.letsEncryptEnabled | bool | `false` | Should Ingress Rule use Let's Encrypt as a Certificate Issuer? |
| ingress.nomad.enabled | bool | `false` | Should Nomad Web traffic be exposed through Ingress Controller? (It requires a dedicated hostname.) |
| ingress.nomad.hostname | string | `"domino-nomad.example.com"` | Hostname for Nomad web access (Usually different than a hostname for a classic Domino HTTP access.) |
| ingress.tls | bool | `false` | Enable TLS in Ingress Rule? (If "true" Ingress will provide handle TLS communication with the clients.) |
| initContainer.chownData.enabled | bool | `false` | Create an init container to change file-system permissions for some local stoarge providers |
| install.CustomNotesdataZip | string | `""` | Path (filesystem or URL) to a zip file that will be downloaded and extracted into the dominodata directory |
| install.idsDir | string | `"/tmp"` | Path in a pod where IDs are copied from a mounted directory |
| install.idsMountedDir | string | `"/local/ids"` | Path in a pod where IDs are mounted during the pod creation |
| install.mountIds | bool | `false` | Set "true" to keep existing IDs mounted to the pod.  Set "false" when you do not want to mount existing IDs to the pod anymore.  Tip: use "true" during the first setup, then change to "false". |
| logs.dominoStdOut | string | `"yes"` | Send Domino console log to the pod's standard output (so it could be read using kubectl logs). The value must be "yes" or "no"; NOT true/false. |
| persistence.enabled | bool | `false` | Should dominodata volume be persistent? Warning: if you specify "false" your Domino data will be DELETED each time you restart the pod! |
| persistence.size | string | `"4Gi"` | Size of the data volume (/local/notesdata) |
| persistence.storageClass | string | `""` | Specify the StorageClass used to provision the volume. Must be one of the classes in "kubectl get storageclass".  If not specified, a default StorageClass is used (if exists). |
| pod.affinity | object | `{}` | Pod affinity. |
| pod.annotations | object | `{}` | Annotations to add to the pod definition. Example: "app: domino" |
| pod.nodeSelector | object | `{}` | If set, Domino is deployed only to the node that matches the label. Example: "domino: alpha" |
| pod.resources.limits.cpu | string | `"4000m"` | Maximum amount of pod CPU |
| pod.resources.limits.memory | string | `"6Gi"` | Maximum amount of pod memory |
| pod.resources.requests.cpu | string | `"2000m"` | Minimum amount of pod CPU |
| pod.resources.requests.memory | string | `"2Gi"` | Minimum amount of pod memory |
| pod.tolerations | object | `{}` | Pod tollerations. |
| rbac.create | bool | `true` | Should a role for RBAC be created? |
| service.enabled | bool | `false` | Should some ports be exposed outside of the cluster (by exposing the port, not through the Ingress controller)? |
| service.externalIP | string | `"10.20.30.40"` | Used only when service.type = ClusterIP. Enter the IP where the service should be exposed. |
| service.http.expose | bool | `false` | Should HTTP be exposed directly? |
| service.http.port | int | `3080` | Exposed HTTP port number (probably NOT 80, because it is usually occupied by Ingress Controller service) |
| service.https.expose | bool | `false` | Should HTTPS be exposed directly? |
| service.https.port | int | `3443` | Exposed HTTP port number (probably NOT 443, because it is usually occupied by Ingress Controller service) |
| service.nomad.expose | bool | `false` | Should Nomad be exposed directly? |
| service.nomad.port | int | `9443` | Exposed Nomad port number (could be 1352) |
| service.nrpc.expose | bool | `false` | Should NRPC be exposed directly? |
| service.nrpc.port | int | `1352` | Exposed NRPC port number (could be 1352) |
| service.type | string | `"LoadBalancer"` | Service type ("LoadBalancer" or "ClusterIP") |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Should a service account be created? |
| serviceAccount.name | string | `""` | The name of the service account. A name is generated using the chart name ('domino', by default) if not set and 'create' is true. |
| sidecarContainer.dominolog.enabled | bool | `true` | Create a sidecar container that prints Domino colnsole.log to standard output. Useful when you set logs.dominoStdOut = "yes" |
| sidecarContainer.dominolog.image | string | `"registry.access.redhat.com/ubi8/ubi-minimal"` | Image for a logging sidecar container |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Petr Kunc | <petr.kunc@hcl.com> | <http://petrkunc.net> |

## Credits

Inspired and based on a great work by [Daniel Nashed](https://github.com/Daniel-Nashed) and [Thomas Hampel](https://github.com/thampel).
