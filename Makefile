
TERRAGRUNT_ENV ?= test-ci

ifdef TERRAGRUNT_SOURCE
TERRAGRUNT_OPTS = --terragrunt-source $(TERRAGRUNT_SOURCE)
endif

validate:
	cd $(TERRAGRUNT_ENV) \
	&& terragrunt validate-all

plan:
	cd $(TERRAGRUNT_ENV) \
	&& cd ./vpc \
	&& terragrunt plan -out=vpc.tfplan \
	&& cd ../db \
	&& terragrunt plan -out=db.tfplan \
	&& cd ../app \
	&& terragrunt plan -out=app.tfplan

apply:
	cd $(TERRAGRUNT_ENV) \
	&& cd ./vpc \
	&& terragrunt apply vpc.tfplan \
	&& cd ../db \
	&& terragrunt apply db.tfplan \
	&& cd ../app \
	&& terragrunt apply app.tfplan

.PHONY: apply plan validate
