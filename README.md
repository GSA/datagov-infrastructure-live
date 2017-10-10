## Use this to provision the catalog stack ##
#### To provision the whole stack (vpc, app, db):


` # cd {env} `

` # terragrunt apply-all `

##### i.e.:
` # cd dev `

` # terragrunt apply-all `

#### To provision individual modules (vpc or app or db): #####
#### NOTE: app depends on db and db depends on vpc #####
`# cd {env}\{module} `

`# terragrunt apply`

##### i.e.:
`# cd dev\vpc`

`# terragrunt apply`
