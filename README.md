# GitOps Repository for Multi-Domain Applications

This repository contains all **Helm charts**, **values overlays by environment**, and te required configurations for **ArgoCD Applications and AppProjects** to safely deploy all the apps that conform the several organizational and logical domains.

The objective is to centralize the deployment management in a declarative, consistent and scalable way by using GitOps. Also to get easier the CI/CD proccess.

---

## 📂 Repository structure

```text
my-gitops/
├── charts/
│   ├── domain-a/
│   │   ├── app1/
│   │   │   ├── Chart.yaml
│   │   │   ├── templates/             # resources templates and helm functions
│   │   │   │   ├── NOTES.txt
│   │   │   │   ├── _helpers.tpl
│   │   │   │   ├── deployment.yaml
│   │   │   │   ├── service.yaml
│   │   │   │   ├── secret.yaml        # secrets using SOPS and base64
│   │   │   │   ├── configmap.yaml     # config could be retrieved from files (.Files.Get configfilex )
│   │   │   │   ├── configfilex
│   │   │   │   └── ... 
│   │   │   ├── overlays/              # files with values overrides by environment
│   │   │   │   ├── dev-values.yaml
│   │   │   │   ├── prod-values.yaml
│   │   │   │   └── ...
│   │   │   └── values.yaml            # default common chart values
│   │   └── app2/
│   │       ├── Chart.yaml
│   │       ├── templates/
│   │       │   └── ... 
│   │       ├── overlays/
│   │       │   └── ... 
│   │       └── values.yaml
│   └── domain-b/
│       └── ...
├── argocd/
│   ├── projects/                       # AppProjects by domain for each environment scope
│   │   ├── domain-a/
│   │   │   ├── domain-a-dev-project.yaml
│   │   │   └── domain-a-prod-project.yaml
│   │   └── domain-b/
│   │       └── ...
│   └── applications/                   # Applications by environment and domain
│       ├── dev/
│       │   ├── domain-a/
│       │   │   ├── namespace.yaml      # Same namespace by domain-environment for all apps of such domain
│       │   │   ├── app1.yaml
│       │   │   ├── app2.yaml
│       │   │   └── ...
│       │   └── domain-b/
│       │       └── ...
│       └── prod/
│           ├── domain-a/
│           │   └── ...
│           └── domain-b/
│               └── ...
└── README.md
```

## 📌 Notes on Overlays, Secrets, and Routes

**Environment Overlays (overlays/)**
- Each chart contains an overlays folder (dev-values.yaml, prod-values.yaml, etc.)
- Allows overriding environment-specific values without modifying the base values.yaml
- Example: replicas, resources, URLs, TLS, logging configuration

**Secrets**
- Secrets are managed via secret.yaml templates in each chart
- Recommended to use SOPS + base64 for encryption and secure versioning
- Ensures secrets are not stored in plaintext in Git

**Routes**
- Charts can create OpenShift Route objects for externally exposed services
- Recommended to use automatic hostnames for dev and explicit hostnames for prod
- TLS enabled according to overlay values (tls.enabled: true/false)
- Helm templates should conditionally create Routes and envFrom only if configMaps exist and TLS is enabled


## ⚡Flow explanation:

1) Helm charts define the base app templates
2) Overlays provide environment-specific configuration
3) ArgoCD Applications point to charts + overlays for deployment
4) AppProjects define domain/environment scope, permissions, and namespace policies
5) ArgoCD reconciles the desired state automatically