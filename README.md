## Use this to provision the catalog stack ##
### Requirements: ###
- Configure AWS Access Key ID & AWS Secret Access Key (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- Install terraform: https://www.terraform.io/intro/getting-started/install.html
- Install terragrunt: https://github.com/gruntwork-io/terragrunt#install-terragrunt


### To provision individual modules (vpc or app or db): ###
#### ***NOTE: app depends on db and db depends on vpc, also you will most likely need to provide the name of the vpc through an input variable since it might already exist *** ####
`# cd {env}\{module} `

`# terragrunt apply`

##### i.e.:
`# cd dev\vpc`

`# terragrunt apply`
