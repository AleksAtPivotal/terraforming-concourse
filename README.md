# Terraforming Concourse

**Not intended to be run in prod**

Bootstrapping Concourse via Terraform.

Intended for quick & dirty way to run Concourse relatively fast.

## Components used

- Terraform is used to spin up the Cloud Provider. In order to minimize the requirements default network settings are used with public facing IP addresses.

- CoreOS Linux is used to run Concourse Containers. CoreOS is configured to go thru its typicall auto-updates with "no-reboot" option. It's assumed that the machine instance will be frequently re-deployed or shut down to save cost.

- Docker-Compose version of Concourse is used to bootstrap Concourse.

## Getting Started

Clone this repostiory

```sh
git clone https://github.com/alekssaul/terraforming-concourse
```

Navigate to the specific cloud provider folder i.e.

```sh
cd terraforming-concourse/gcp
```

Setup your environmental variables: i.e.

```sh
export TF_VAR_gcp_credentials_file=/Users/alekssaul/Downloads/fe-asaul-57f068d627e5.json
export TF_VAR_gcp_project=fe-asaul
export TF_VAR_ssh_key_public=$(cat ~/.ssh/id_rsa.pub)
```

Deploy the environment

```sh
terraform init ; terraform apply
```

Destroy the environment when done

```sh
terraform destroy
```
