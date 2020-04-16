# sandbox

This environment keeps parity with the BSP environments. The purpose is to act
as a continuous integration environment to test playbook live in a multi-host
environment.


## Usage

Make sure you've already followed the common setup instructions in the top-level
[README](../README.md).


### Requirements

- [Terraform](https://www.terraform.io/intro/getting-started/install.html) v0.12


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
Host jump.ci.datagov.us jump.bionic.datagov.us
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

Symlink the inventory to avoid having to specify it with ansible.

```bash
sudo mkdir /etc/ansible
sudo ln -s /home/ubuntu/datagov-deploy/ansible/inventories/sandbox /etc/ansible/hosts
```
