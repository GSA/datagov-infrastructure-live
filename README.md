[![CircleCI](https://circleci.com/gh/GSA/datagov-infrastructure-live.svg?style=svg)](https://circleci.com/gh/GSA/datagov-infrastructure-live)

# datagov-infrastructure-live

This repo contains terraform configurations to deploy to different
[data.gov](https://www.data.gov/) environments. The reusable source for modules
used by these terraform configurations can be found in
[datagov-infrastructure-modules](https://github.com/GSA/datagov-infrastructure-modules).

_Note: production and staging environments are hosted in BSP and are
**not** provisioned with terraform._


## Usage

Each environment is really its own project and contains additional setup and
usage instructions in their respective README's. This section contains the usage
instructions common to _all_ environments.


### First-time setup

Create the s3 bucket (`datagov-terraform-state`) to hold the terraform state defined
in [iam/main.tf](./iam/main.tf).

Manually create the IAM CI deploy user (`datagov-ci`) for use with CI. An
appropriate terraform-managed policy will be attached to this user.

The first execution of `iam` should be done manually with admin permissions.

    $ terraform init
    $ terraform apply

Once provisioned, the appropriate permissions will be attached to the
`datagov-ci` user and execution of the other projects can be done via CI/CD.


### Environments

Each directory represents an "environment".

Name | Description | Jumpbox
---- | ----------- | -------
[`iam`](iam/README.md) | Global "environment" that applies IAM settings to to the sandbox account. | N/A
[`sandbox`](sandbox/README.md) | WIP continuous integration environment automatically runs datagov-deploy playbooks from `develop`. | jump.sandbox.datagov.us


## Development

### Requirements

- [Configure AWS Access Key](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- [jq](https://stedolan.github.io/jq/)
- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)
- [terraform](https://www.terraform.io/downloads.html) v0.12

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


### Working with datagov-infrastructure-modules

When making changes to the
[datagov-infrastructure-modules](https://github.com/GSA/datagov-infrastructure-modules),
you can either point the module source to a branch or use a local path. e.g.

```
module "solr" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/solr?ref=feature-terraform-12"
  # ...
}
```

Becomes:

```
module "solr" {
  source = "../../datagov-infrastructure-modules//modules/solr"
  # ...
}
```


## Continuous delivery

We use CircleCI for continuous integration and delivery.

You must configure CircleCI with secrets in order to apply the terraform files.

- AWS IAM credentials of the deploy user
- Application secrets to set (e.g. database passwords)
- Root ssh keys in order to provision through the jumpbox

First, set these [environment variables in
CircleCI](https://app.circleci.com/settings/project/github/GSA/datagov-infrastructure-live/environment-variables)
using the credentials from the deploy user (`datagov-ci`):

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Next, set any `TF_VAR_*` [environment variables in
CircleCI](https://app.circleci.com/settings/project/github/GSA/datagov-infrastructure-live/environment-variables)
from your `.env`. Reach out to a team member if you are missing any or pull them
from the terraform state (`terraform output`).

Finally, add the [root ssh
key](https://drive.google.com/drive/folders/10-hk-IqA0jQAW6727pKmW46EF-nHiNLr)
(datagov-sandbox) in
[CircleCI](https://app.circleci.com/settings/project/github/GSA/datagov-infrastructure-live/ssh)
under "additional keys".
