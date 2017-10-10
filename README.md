## Use this to provision the catalog stack ##
### Requirements: ###
- Configure AWS Access Key ID & AWS Secret Access Key (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- Install terraform: https://www.terraform.io/intro/getting-started/install.html
- Install terragrunt: https://github.com/gruntwork-io/terragrunt#install-terragrunt


### To provision the whole stack (vpc, app, db):


` # cd {env} `

` # terragrunt apply-all `

##### i.e.:
` # cd dev `

` # terragrunt apply-all `

### To provision individual modules (vpc or app or db): #####
### NOTE: app depends on db and db depends on vpc #####
`# cd {env}\{module} `

`# terragrunt apply`

##### i.e.:
`# cd dev\vpc`

`# terragrunt apply`
