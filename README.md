[![CircleCI](https://circleci.com/gh/GSA/datagov-infrastructure-live.svg?style=svg)](https://circleci.com/gh/GSA/datagov-infrastructure-live)

# datagov-infrastructure-live

This repo contains terraform configurations to deploy to different
[data.gov](https://www.data.gov/) environments. The source for modules used by
these terraform configurations can be found in
[datagov-infrastructure-modules](https://github.com/GSA/datagov-infrastructure-modules).

_Note: production and staging environments are hosted in BSP and are
**not** provisioned with terraform._


## Usage

Each environment is really its own project and contains additional setup and
usage instructions in their respective README's. This section contains the usage
instructions common to _all_ environments.


### Requirements

- [Configure AWS Access Key](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- [jq](https://stedolan.github.io/jq/)
- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)

_Note: Terraform and/or Terragrunt versions are different between environments.
We are phasing out Terragrunt and moving all environments to Terraform v0.12._

These tools are available through your package manager, or through pip.


### Setup AWS credentials

All developers are in the `developers` IAM group which enforces access through
multi-factor authentication (MFA). You must first get temporary credentials to
use with Terraform.

First, copy `env.sample` to `.env`, customize it with your AWS access key.
`AWS_MFA_DEVICE_ARN` should be set with your MFA arn. This can be found on the
"My Security Credentials" page in the AWS console. Then source these environment
variables.

    $ source .env

You'll be prompted for your MFA code. Enter it without any spaces when prompted.

These credentials are good for 12 hours.


## Environments

Each directory represents an "environment".

Name | Description | Terraform | Terragrunt | Jumpbox
---- | ----------- | --------- | ---------- | -------
`bionic`   | Environment to support the Ubuntu Bionic migration. | v0.11 | Y | jump.bionic.datagov.us
`ci`       | WIP continuous integration environment automatically runs datagov-deploy playbooks from `develop`. | v0.11 | Y | jump.ci.datagov.us
`ckan-cloud-dev` | Development environment for the CKAN Cloud project. | v0.12 | N | N/A
`iam` | Global "environment" that applies IAM settings to to the sandbox account. | v0.12 | N | N/A
