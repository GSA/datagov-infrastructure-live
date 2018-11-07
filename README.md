[![CircleCI](https://circleci.com/gh/GSA/datagov-infrastructure-modules.svg?style=svg)](https://circleci.com/gh/GSA/datagov-infrastructure-modules)

# datagov-infrastructure-modules

Data.gov infrastructure terraform modules. This repo contains the source modules
used in
[datagov-infrastructure-live](https://github.com/GSA/datagov-infrastructure-live).
See datagov-infrastructure-live for development instructions.


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


## Tests

Tests include light terraform syntax validation. Don't forget to run the tests.

    $ make test

You might also want to standardize the syntax in your files.

   $ terraform fmt
