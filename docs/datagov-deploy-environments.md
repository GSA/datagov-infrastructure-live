# datagov-deploy environments

These are environments _similar_ to the staging and production environments in
BSP. These environments usually have the same or a subset of the Ansible
inventory in [datagov-deploy](https://github.com/GSA/datagov-deploy).

- [bionic](../bionic/README.md)
- [ci](../ci/README.md)


## Usage

Make sure you've already followed the common setup instructions in the top-level
[README](../README.md).


### Requirements

- [Terraform](https://www.terraform.io/intro/getting-started/install.html) v0.11
  (v0.12 for some environments, [see below](#environments))
- [Terragrunt](https://github.com/gruntwork-io/terragrunt/releases?after=v0.19.0) <=v0.18.x

Terragrunt v0.11 is available through Homebrew, although Terragrunt v0.18 is
not.

    $ brew install terraform@0.11


### Root ssh key

The initial provisioning requires SSH access to the jumpbox. Since the jumpbox playbooks have
not been run, you must use the environment's root SSH key. Please see a team
member for access.

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

    $ terragrunt refresh-all
    $ terragrunt output-all

The output-all command dumps a lot of output, but buried in there will be the
output variables, including secrets. You can `cd` into individual application
directories to run `terragrunt output` on an individual app.


### Terragrunt

Terragrunt wraps Terraform. Each subdirectory represents an


    $ terragrunt plan-all
    $ terragrunt apply-all

Usually its easier to work with an individual application. `cd` into the app
subdirectory and run commands there.

    $ cd $application_dir
    $ terragrunt plan
    $ terragrunt apply


## Ansible usage

Once the environment is provisioned with Terragrunt/Terraform, you can connect
to the jumpbox to apply Ansible playbooks just as we do in the BSP environments.


### Configure SSH for jumpbox

Forward your ssh agent so that you have access to the SSH key to connect to
other instances. Consider adding this to your `~/.ssh/config`.

```
Host jump.ci.datagov.us jump.bionic.datagov.us
    User <yourusername>
    ForwardAgent yes
    IdentityFile ~/.ssh/<your-datagov-deploy-key>
```

Connect to the jumpbox.

    $ ssh $jumpbox_dns

The jumpbox dns is an output variable in the jumpbox module.

    $ cd $env/jumpbox
    $ terragrunt output


### Bootstraping the jumpbox

When the jumpbox is first created, you'll need to bootstrap it to run ansible.
You can copy/paste these scripts into your terminal. All commands should be run
from the jumpbox.

First, install pyenv.

```bash
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
pipenv sync
pipenv run make update-vendor-force
```

Set the inventory shell variable.

```
inventory=<inventory>
```

Symlink the inventory to avoid having to specify it with ansible. _Note: You'll have to
replace the placeholder `<inventory>` with the name of your inventory._

```bash
sudo mkdir /etc/ansible
sudo ln -s /home/ubuntu/datagov-deploy/ansible/inventories/${inventory} /etc/ansible/hosts
```


## Development

This section describes the development workflow for the Terraform/Terragrunt
templates.

Include the `--terragrunt-source` option or `TERRAGRUNT_SOURCE` environment
variable to specify a local modules directory.

    $ cd $env
    $ terragrunt plan-all --terragrunt-source ../../../datagov-infrastructure-modules
    $ terragrunt apply-all --terragrunt-source ../../../datagov-infrastructure-modules

Or for a specific module:

    $ cd $env/vpc
    $ terragrunt apply --terragrunt-source ../../../datagov-infrastructure-modules//vpc
