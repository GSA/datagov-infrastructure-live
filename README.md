[![CircleCI](https://circleci.com/gh/GSA/datagov-infrastructure-live.svg?style=svg)](https://circleci.com/gh/GSA/datagov-infrastructure-live)

# datagov-infrastructure-live

This repo contains terraform configurations to deploy to different
[data.gov](https://www.data.gov/) environments. The source for modules used by
these terraform configurations can be found in
[datagov-infrastructure-modules](https://github.com/GSA/datagov-infrastructure-modules).

_Note: production and staging environments are hosted in BSP and are
**not** provisioned with terraform._


## Requirements

- Configure AWS Access Key ID & AWS Secret Access Key (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- Install terraform: https://www.terraform.io/intro/getting-started/install.html
- Install terragrunt: https://github.com/gruntwork-io/terragrunt#install-terragrunt


## Usage

*NOTE: `app` depends on `db` which depends on `vpc`. You will most likely need
to provide the name of the vpc through an input variable since it might already
exist.*

    $ cd {env}\{module}
    $ terragrunt apply

e.g.

    $ cd dev\vpc
    $ terragrunt apply


## Development

Include the `--terragrunt-source` option or `TERRAGRUNT_SOURCE` environment
variable to specify a local modules directory.

    $ cd test/vpc
    $ terragrunt apply --terragrunt-source ../../../datagov-infrastructure-modules//vpc
