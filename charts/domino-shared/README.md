# domino-shared

A Helm chart for HCL Domino server - shared elements

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 12.02.0](https://img.shields.io/badge/AppVersion-12.02.0-informational?style=flat-square)

## Prerequisites

- Kubernetes cluster 1.18+
- Helm 3.0.0+

## Installation

### Add Helm Repository

```
helm repo add domino-charts https://HCL-TECH-SOFTWARE.github.io/domino-charts/
helm repo update
```

### Configure the chart

- Create your config file with values. You can copy one of the demo files in the `examples` folder and update the values.
- Or you can download the default values file and update it:
```
helm show values domino-charts/domino-shared > shared-values.yaml
```

### Install the chart

Run the command:

```
helm upgrade <shared_name> domino-charts/domino-shared \
  --install \
  --namespace <namespace> \
  --create-namespace \
  --values examples/<shared-values>.yaml
```

`<shared-values>.yaml` is your config file with custom values.

**Example:**

```
helm upgrade domino-shared domino-charts/domino-shared \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/shared-values.yaml
```

## Uninstallation

To uninstall/delete the `<shared_name>` deployment:
```
helm uninstall <shared_name> -n <namespace>
```

**Example:**
```
helm uninstall domino-shared -n domino
```

## Configuration

The following table lists the configurable parameters of the Domino chart and the default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.createIssuer | bool | `true` | Should ClusterIssuer resource for Let's Encrypt be crearted? |
| certManager.leCertificate | string | `"staging"` | Type of Let's Encrypt certificate authority ("staging" or "prod") |
| certManager.leEmail | string | `"name@example.com"` | Email used when creating a profile for Let's Encrypt |
| image.imageCredentials.password | string | `"registry_password"` | Password for a private container registry |
| image.imageCredentials.registry | string | `"registry.example.com"` | Hostname of a private container registry |
| image.imageCredentials.username | string | `"registry_user"` | Username for a private container registry |
| ingress.class | string | `"nginx"` | Ingress class. Must be included in "kubectl get ingressclass". |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Petr Kunc | <petr.kunc@hcl.com> | <http://petrkunc.net> |
