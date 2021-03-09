# ckan-cloud

Provisions resources necessary for ckan-cloud.

## Usage

```
module "dev" {
  source = "github.com/gsa/datagov-infrastructure-modules.git//modules/ckan-cloud"

  env = "dev"
}
```


## Resources

- VPC
- IAM user for automated access
