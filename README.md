# Terraform modules

Terraform modules commonly used by our projects

## Modules

- [`ecs`](./ecs)

  Creates an ECS cluster, contains submodules for creating additional resources within the cluster.

- [`meta`](./meta)

  Creates infrastructure for terraform itself and infrastructure CI/CD

- [ssl/acm](./ssl/acm)

  Creates an SSL certificate using AWS ACM

## External modules

- [terraform-single-page-app](https://github.com/codequest-eu/terraform-single-page-app)

  Common infrastructure for Single Page Applications
