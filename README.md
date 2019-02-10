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


## Secrets

Get a copy of `secrets.tfvars` from a fellow developer. If you're creating a new
environment, copy the template file and fill it out. The `secrets.tfvars` file
should exist in the root directory of the environment.

    $ cp secrets.tfvars.sample new-environment/secrets.tfvars


## Secrets

The following secrets are defined in our CI/CD system (CircleCI). Each is
defined as an environment variable `TF_VAR_variable_name`.

**db_password** the password to set for the database user.


## Development

Include the `--terragrunt-source` option or `TERRAGRUNT_SOURCE` environment
variable to specify a local modules directory.

    $ cd test/vpc
    $ terragrunt apply --terragrunt-source ../../../datagov-infrastructure-modules//vpc

To run all the modules for a single environment, use `make`.

    $ make plan
    # check the output
    $ make apply


## Playbook testing

The instances created use the SSH key configured with the `key_name` variable.
SSH with agent forwarding so that your key will accessible from the jump box.
This also makes it easier to push to GitHub when configured with ssh access.

Terragrunt output will show you the jumpbox DNS.

    $ terragrunt output
    ...
    jumpbox_dns = ec2-100-24-52-149.compute-1.amazonaws.com

Then ssh into the jumpbox with the ubuntu user.

    $ ssh -A -l ubuntu ec2-100-24-52-149.compute-1.amazonaws.com

Clone the datagov-deploy repo and setup your environment.

    $ git clone git@github.com:GSA/datagov-deploy.git
    $ virtualenv venv
    $ source venv/bin/activate
    $ pip install -U setuptools
    $ pip install -r datagov-deploy/requirements.txt
    $ echo fakepassword > ~/ansible-secret.txt
    $ cd datagov-deploy/ansible

The jumpbox is configured with an IAM role (`jumpbox_dynamic_inventory_role`)
that allows it to fetch ec2 information without setting AWS access keys.


## Continuous delivery

The `master` branch is automatically deployed by CI. We use a `datagov-ci` IAM
user in AWS configured with access to terraform state bucket and minimal policy
tailored to our terraform modules. You may need to update this policy if new AWS
resources are added to the modules.
