# datagov-infrastructure-live

This repo contains terraform configurations to deploy the
[data.gov](https://www.data.gov/) sandbox environment.

_Note: production and staging environments are hosted in BSP and are
**not** provisioned with terraform._

This environment attempts to keep parity with the BSP environments. The purpose
is to act as a continuous integration environment to test [Ansible
playbooks](https://github.com/GSA/datagov-deploy) live in a multi-host
environment.


## Usage

### Prerequisites

- Terraform 1.0.6+


### First-time setup

Create the s3 bucket (`datagov-terraform-state`) to hold the terraform state defined
in [main.tf](./main.tf).



## Development

### Requirements

- [Configure AWS Access Key](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- [jq](https://stedolan.github.io/jq/)
- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)
- [terraform](https://www.terraform.io/downloads.html) v1.0.6+

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


### Root ssh key

The initial provisioning requires SSH access to the jumpbox. Since the jumpbox
playbooks have not been run, you must use the environment's [root SSH
key](https://drive.google.com/drive/folders/10-hk-IqA0jQAW6727pKmW46EF-nHiNLr).
Please see a team member for access.

Add the SSH key to your SSH agent.

    ssh-add ~/.ssh/datagov-sandbox

You must setup ssh-agent forwarding. Add this snippet to your SSH config.

```
# ~/.ssh/config

Host *.datagov.us
    ForwardAgent yes
```


### Secrets

Copy the `env.sample` to `.env`. Then you can populate these secrets from the
Terraform state file. These secrets will also exist in the Ansible vault.

    $ terraform refresh
    $ terraform output


## Ansible usage

Once the environment is provisioned with Terraform, you can connect to the
jumpbox to apply Ansible playbooks just as we do in the BSP environments.


### Configure SSH for jumpbox

Forward your ssh agent so that you have access to the SSH key to connect to
other instances. Consider adding this to your `~/.ssh/config`.

```
Host jump.sandbox.datagov.us
    User <yourusername>
    ForwardAgent yes
    IdentityFile ~/.ssh/<your-datagov-deploy-key>
```

Connect to the jumpbox.

    $ ssh $jumpbox_dns

The jumpbox dns is an output variable in the jumpbox module.

    $ terraform output


### Bootstraping the jumpbox

When the jumpbox is first created, you'll need to bootstrap it to run ansible.
You can copy/paste these scripts into your terminal. All commands should be run
from the jumpbox.

First, install pyenv.

```bash
sudo apt-get update; sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev python3-pip
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
source ~/.bashrc
```

Setup SSH.

```bash
cat <<EOF > ~/.ssh/config
StrictHostKeyChecking=no

Host *.datagov.us
    User ubuntu
    IdentityFile ~/.ssh/authorized_keys
EOF
```

Then setup datagov-deploy.

```bash
git clone https://github.com/GSA/datagov-deploy.git
cd datagov-deploy
pip3 install --user pipenv
pyenv install
pipenv sync
pipenv run make vendor
```

Symlink the inventory to avoid having to specify it with ansible.

```bash
sudo mkdir /etc/ansible
sudo ln -s /home/ubuntu/datagov-deploy/ansible/inventories/sandbox /etc/ansible/hosts
```


## Continuous delivery

We use GitHub Actions for continuous integration and delivery. As with all of
our code repositories, changes to the `main` branch is automatically deployed.

As part of CI, the terraform plan will be posted to the PR as a comment. The
plan represents the actions terraform will take once approved. It is both the
author and reviewer's responsibility to review the plan in addition to the code
changes.


### Secrets

You must configure GH with secrets in order to apply the terraform files.

- AWS IAM credentials of the deploy user (see [GSA/datagov-iam](https://github.com/GSA/datagov-iam/blob/main/ci.tf))
- Application secrets to set (e.g. database passwords)
- Root ssh keys in order to provision through the jumpbox

First, set these [environment variables in
GH](https://github.com/GSA/datagov-infrastructure-live/settings/secrets/actions)
using the credentials from the deploy user (see [GSA/datagov-iam](https://github.com/GSA/datagov-iam/blob/main/ci.tf)):

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Next, set any `TF_VAR_*` [environment variables in
GH](https://github.com/GSA/datagov-infrastructure-live/settings/secrets/actions)
from your `.env`. Reach out to a team member if you are missing any or pull them
from the terraform state (`terraform output`).

Finally, add the [root ssh
key](https://drive.google.com/drive/folders/10-hk-IqA0jQAW6727pKmW46EF-nHiNLr)
(datagov-sandbox) as the `SSH_DATAGOV_SANDBOX` GH secret.


## Modules

Modules in `modules/` are true Terraform modules and encapsulate configuration
for a Data.gov component.


## Working with ansible

Instances must be manually added to the static sandbox hosts file. This gives us
full control to assign hosts to Ansible groups within
[GSA/datagov-deploy](https://github.com/GSA/datagov-deploy) without having to
make changes within datagov-infrastructure-live. For example:

```ini
[solr]
datagov-solr1tf.internal.sandbox.datagov.us

[harvester]
catalog-harvester1tf.internal.sandbox.datagov.us
```


## Tests

Tests include light terraform syntax validation. Don't forget to run the tests.

    $ make test

You might also want to standardize the syntax in your files.

    $ terraform fmt
