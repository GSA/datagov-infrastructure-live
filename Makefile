SUBDIRS := \
  modules/catalog \
  modules/dashboard \
  modules/db \
  modules/inventory \
  modules/jenkins \
  modules/jumpbox \
  modules/mysql \
  modules/postgresdb \
  modules/redis \
  modules/s3 \
  modules/solr \
  modules/stateful \
  modules/stateless \
  modules/vpc \
  modules/web \
  modules/wordpress

clean:
	rm -rf .terraform $(foreach subdir, $(SUBDIRS), $(subdir)/.terraform)

fmt:
	terraform fmt
	$(foreach subdir, $(SUBDIRS), terraform fmt $(subdir);)

glob-modules:
	@# Output a comma-separated list of subdirs for CI matrix build
	@echo $(SUBDIRS) | jq --raw-input --compact-output 'split(" ")'

test: $(SUBDIRS)
$(SUBDIRS):
	@echo Testing $@ ...
	terraform version
	terraform init -backend=false $@
	AWS_DEFAULT_REGION=us-east-1 terraform validate $@

.PHONY: glob-modules test $(SUBDIRS)
