---
layout: default
title: Providers
nav_order: 3
description: "Kubernetes providers"
has_children: false
---

# Kubernetes providers - Notes

Quick comments to the different Kubernetes providers or Kubernetes distributions.

## K3s
- Great for the first experiments with self-hosted Kubernetes. Low HW requirements, easy installation.
- Contains **LoadBalancer** _ServiceLB_ (former Klipper). 
- Contains **Ingress Controller** _Traefik_. It does not play well with Domino Verse (with a simple forwarding rule), so I replaced it with _Ingress NGINX_. (How to [disable Traefik](https://docs.k3s.io/networking#traefik-ingress-controller) on K3s.)
- The default **StorageCless** is _local-path_. It does not support volume expansion. You can deploy other storage provider that supports volume expansion, like **Longhorn**.


## RKE2
- Good distro for hosting Kubernetes on-premises. Easy installation.
- RKE2 deploys _Ingress NGINX_ as an **Ingress Controller**.
- No storage class is defined out of the box; you need to install your CSI. Good choice could be _Longhorn_ because, created by the same company that maintains RKE2.
- Load balancers are not provided. You can deploy one of the solutions designed for on-prem, like _MetalLB_.


## AWS EKS
- Kubernetes managed service, by Amazon.
- For a quick cluster creation, use [eksctl](https://eksctl.io/) tool.
- EKS does not deploy CSI driver by default. YOu have to install it manually. \
  More info: [Amazon EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
- The default **StorageCless** is _gp2_.
  The storageClass is not enabled for expansion by default. \
  You can enable it with this command:
  ```
  kubectl patch sc gp2 -p '{"allowVolumeExpansion": true}'
  ```
- You can deploy [EKS native Ingress Controller](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html), or you can install _Ingress NGINX_ controler.
- AWS native **load balancers** expose services as a hostname. Point your custom domain names (alpha.space.demo) to these hostnames using CNAME records in your DNS zone.


## Azure AKS
- Kubernetes managed service, by Microsoft.
- Several  **StorageClesses** created in the cluster, of of the box. \
  You can use _managed-csi_ (default) or _managed-csi-premium_, for example. \
  All classes are enabled for Volume Expansion.
- There is a simple Ingress controller, that could be enabled by adding addon "http_application_routing". The add-on is being retired, so you should not use it.
  You can use a new native [Web Application Routing](https://learn.microsoft.com/en-us/azure/aks/web-app-routing) as an ingress controller. \
  Or you can deploy a classic [Ingress NGINX](https://learn.microsoft.com/en-us/azure/aks/ingress-basic) controller. \
  **IMPORTANT:** You need to add the proper annotation to the Ingress Controller (using /healthz for a health check, as described in the link above), otherwise Azure load balancer would think that
  backend server is not ready and will not route traffic to Domino HTTP.
- Azure native **load balancers** expose services as an IP address. Point your custom domain names (alpha.space.demo) to these IPs using A records in your DNS zone.


## Google GKE
- Kubernetes managed service, by Microsoft.
- Several  **StorageClesses** created in the cluster, of of the box. \
  You can use _standard-rwo (default), _standard_ or _premium-rwo_.
- GKE offers its Ingress Controler ([info](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress)), but I deployed Ingress NGINX which works fine.


## Linode LKE
- A good alternative to big Kubernetes providers.
- No **Ingress Controller** is installed by default; Linode suggests using _Ingress NGINX_.
- CSI is deployed by Linode, storage classes: `linode-block-storage-retain`, `linode-block-storage`.
- **Load balancers** are provided by Linode.