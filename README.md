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

cd into the environment you wish to work with.

    $ cd test

Run terraform plan in all the modules using terragrunt.

    $ terragrunt plan-all

If the plan looks good, apply it.

    $ terragrunt apply-all

Alternatively, you can work with a single module.

    $ cd test\vpc
    $ terragrunt apply


### Connecting to the jumpbox

Forward your ssh agent so that you have access to the ssh key to connect to
other instances.

    $ ssh -A -l ubuntu $jumbox_dns

The jumpbox dns is an output variable.

    $ cd $env/jumpbox
    $ terragrunt output

When the jumpbox is first created, you'll need to bootstrap it to run ansible.

```bash
git clone git@github.com:GSA/datagov-deploy.git
virtualenv venv
source venv/bin/activate
pip install -U setuptools
pip install -r datagov-dedupe/requirements.txt
cat <<EOF > ~/.ssh/config
StrictHostKeyChecking=no
EOF
```

### First-time apply for environment

Terragrunt plan-all/apply-all can't handle `terraform_remote_state` that hasn't
been initialized yet. Therefore, you need to apply each module, one at a time
in the correct dependency order.

If you see this error, that's the issue:

```
Error: Error running plan: 1 error(s) occurred:

* module.database.aws_security_group.postgres-sg: 1 error(s) occurred:

* module.database.aws_security_group.postgres-sg: Resource 'data.terraform_remote_state.vpc' does not have attribute 'vpc_id' for variable 'data.terraform_remote_state.vpc.vpc_id'
```

To resolve, cd into the module and run terragrunt.

    $ cd test/vpc
    $ terragrunt apply
    $ cd ..


## Development

Include the `--terragrunt-source` option or `TERRAGRUNT_SOURCE` environment
variable to specify a local modules directory.

    $ cd test
    $ terragrunt plan-all --terragrunt-source ../../../datagov-infrastructure-modules
    $ terragrunt apply-all --terragrunt-source ../../../datagov-infrastructure-modules
