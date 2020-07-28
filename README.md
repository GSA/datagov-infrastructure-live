[![CircleCI](https://circleci.com/gh/GSA/datagov-infrastructure-modules.svg?style=svg)](https://circleci.com/gh/GSA/datagov-infrastructure-modules)

# datagov-infrastructure-modules

Data.gov infrastructure terraform modules. This repo contains the source modules
used in
[datagov-infrastructure-live](https://github.com/GSA/datagov-infrastructure-live).
See datagov-infrastructure-live for development instructions.


## Modules

Modules in `modules/` are true Terraform modules. Top-level modules like
`catalog/` are terragrunt modules. The Terraform modules are building blocks and
consumed by the top-level terragrunt modules. The terragrunt modules encapsulate
a full configuration for a Data.gov component.


## Working with ansible

We use AWS dynamic inventory for ansible in our test environments. The dynamic
inventory works by using the `group` tag on any instances to organize the hosts
into groups. You may create multiple groups by using a comma-separated list.
e.g. `group=harvester,solr`.

In your `hosts` file, this would look like:

```ini
[solr:children]
tag_group_solr

[harvester:children]
tag_group_harvester
```

_Note: even though you may specify the ansible_group as a comma-separated list,
the best practice is to use a single, unique tag that can then be mapped to
multiple Ansible groups in the inventory file._


## Tests

Tests include light terraform syntax validation. Don't forget to run the tests.

    $ make test

You might also want to standardize the syntax in your files.

    $ terraform fmt

