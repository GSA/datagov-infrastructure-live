SUBDIRS := \
  modules/catalog \
  modules/dashboard \
  modules/db \
  modules/inventory \
  modules/jenkins \
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
	$(foreach subdir, $(SUBDIRS), terraform fmt $(subdir);)

test: $(SUBDIRS)
$(SUBDIRS):
	@echo Testing $@ ...
	terraform init -backend=false $@
	AWS_DEFAULT_REGION=us-east-1 terraform validate $@

.PHONY: test $(SUBDIRS)
