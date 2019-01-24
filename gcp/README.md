# Concourse on GCP

Terraform specs to create a CoreOS Linux GCP instance on AWS with concourse running in Docker via Docker-Compose

```sh
terraform init
```

```sh
export TF_VAR_gcp_project=FE-asaul
export TF_VAR_gcp_credentials_file=/Users/alekssaul/Downloads/FE-asaul-f8b0b6832f02.json
```

```sh
terraform plan
```