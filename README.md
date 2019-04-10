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

## Sandbox environments

This describes the various sandbox environments and their purpose.

Name | Description | Jumpbox
---- | ----------- | -------
`bionic`   | For testing playbooks against Ubuntu Bionic. | datagov-jump1tf.bionic.datagov.us
`ci`   | WIP continuous integration environment automatically runs datagov-deploy playbooks from `develop`. | datagov-jump1tf.ci.datagov.us
`test` | Deprecated. This environment will be deleted once other environments are in place. | datagov-jump1t.datagov.us


## Usage

*NOTE: `app` depends on `db` which depends on `vpc`. You will most likely need
to provide the name of the vpc through an input variable since it might already
exist.*

    $ cd {env}\{module}
    $ terragrunt apply

e.g.

    $ cd dev\vpc
    $ terragrunt apply

For components with provisioning, like jumpbox, you should add your SSH keypair
to your ssh-agent so that terraform can connect to the host to run the
provisioning.

    $ ssh-add ~/.ssh/<aws-key-name>.pem


### Connecting to the jumpbox

Forward your ssh agent so that you have access to the SSH key to connect to
other instances. Consider adding this to your `~/.ssh/config`.

```
Host *.datagov.us
    User ubuntu
    ForwardAgent yes
    IdentityFile ~/.ssh/<aws-key-name>
```

Connect to the jumpbox.

    $ ssh -A -l ubuntu $jumbox_dns

The jumpbox dns is an output variable in the jumpbox module.

    $ cd $env/jumpbox
    $ terragrunt output

When the jumpbox is first created, you'll need to bootstrap it to run ansible.
You can copy/paste these scripts into your terminal.

First, install pyenv.

```bash
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
source ~/.bash_profile
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
pipenv install
```

Symlink the inventory to avoid having to specify it with ansible. _Note: You'll have to
replace the placeholder `${environment}` with the name of your inventory._

```bash
sudo mkdir /etc/ansible
sudo ln -s /home/ubuntu/datagov-deploy/ansible/inventories/${environment} /etc/ansible/hosts
```


### First-time apply for environment

Terragrunt plan-all can't handle `terraform_remote_state` that hasn't been
initialized yet. Therefore, to run `terragrunt apply-all` and just assume it's
going to do the right thing without seeing the plan.


If you see this error, that's the issue:

```
Error: Error running plan: 1 error(s) occurred:

* module.database.aws_security_group.postgres-sg: 1 error(s) occurred:

* module.database.aws_security_group.postgres-sg: Resource 'data.terraform_remote_state.vpc' does not have attribute 'vpc_id' for variable 'data.terraform_remote_state.vpc.vpc_id'
```


## Development

Include the `--terragrunt-source` option or `TERRAGRUNT_SOURCE` environment
variable to specify a local modules directory.

    $ cd test
    $ terragrunt plan-all --terragrunt-source ../../../datagov-infrastructure-modules
    $ terragrunt apply-all --terragrunt-source ../../../datagov-infrastructure-modules

Or for a specific module:

    $ cd test/vpc
    $ terragrunt apply --terragrunt-source ../../../datagov-infrastructure-modules//vpc
