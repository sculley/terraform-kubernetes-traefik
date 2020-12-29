# terraform-kubernetes-traefik
Terraform module which deploys Traefik to a Kubernetes cluster, [Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease.

# Description

This Terraform module makes it easy to deploy the [Traefik](https://github.com/traefik/traefik-helm-chart) HelmChart into a Kubernetes cluster which can you call as a chile module in your Terraform configuration.

As Traefik has many configuration values by default we deploy the HelmChart as is with only two main input variables (Namespace, Replica Count).

By default the HelmChart Traefik [values.yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml) is used but if you want to configure Traefik in your root module/configuration you can place your custom values.yaml file inside your root dir and add set the input variable (default_values) to any value. This will cause the terrform-kubernetes-traefik module to load your `values.yaml` file and configure the Traefik deployment/services/pods etc to the values you provided.

# Requirements

- Terraform 0.13+
- Kubernetes Cluster

## How to use

The module makes use of the [Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) and the [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) which looks for Kubernetes configuration in the following location ```"~/.kube/config"```, The Helm provider needs to be configured with the path to your kube config in a provider block in your Terraform configuration.

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config-elodin"
  }
}
```

### Create a Terraform Configuration
---

Create a new directory

```shell
$ mkdir example-deployment
```

Change into the directory

```shell
$ cd example-deployment
```

Create a file for the configuration code

```shell
$ touch main.tf
```

Paste the following configuration into ```main.tf``` and save it.

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config-elodin"
  }
}

module "traefik" {
  source = "github.com/sculley/terraform-kubernetes-traefik"

  replica_count = 2
}
```

Run terraform init

```shell
$ terraform init
```

Run terraform plan

```
$ terraform plan
```

Apply the Terraform configuration

```shell
$ terraform apply
```

### Custom Configuration Values
---

If you want to use your own configuration in `values.yaml` you will need to provide the default_values input variable to the module, the terraform-kubernetes-traefik module will detect its been told not to use the default values and will look for a file called `values.yaml` in your root dir, you can see the code it uses below

```yaml
values = [var.default_values == "" ? var.default_values : file("${path.root}/values.yaml")]
```

Make sure the `values.yaml` is located in your root dir.

```
$ tree
.
├── main.tf
└── values.yaml.tpl
```

You will then need to provide the default_values input to the module block in your main.tf file


```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config-elodin"
  }
}

module "traefik" {
  source = "github.com/sculley/terraform-kubernetes-traefik"

  replica_count = 2

  default_values = "false"
}
```

or add it as a variable

```hcl
variable "default_values" {
  description = "Specifies whether to use the traefik default values.yaml, or if set to anything else then to use your own custom values"
  type = string
  default = ""
}
```

And override the default in a .tfvars file and supply this to terraform plan/apply

```
default_values = "false"
```

```shell
$ terraform plan --var-file=production.tfvars -out plan && terraform apply -var-file=production.tfvars plan
```