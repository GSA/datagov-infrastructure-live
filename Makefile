SUBDIRS := \
  catalog \
  crm \
  dashboard \
  inventory \
  jenkins \
  jumpbox \
  modules/catalog \
  modules/crm \
  modules/dashboard \
  modules/db \
  modules/inventory \
  modules/jenkins \
  modules/mysql \
  modules/postgresdb \
  modules/solr \
  modules/stateful \
  modules/stateless \
  modules/vpc \
  modules/web \
  modules/wordpress \
  solr \
  vpc \
  wordpress

fmt:
	$(foreach subdir, $(SUBDIRS), terraform fmt $(subdir);)

test: $(SUBDIRS)
$(SUBDIRS):
	@echo Testing $@ ...
	terraform init -backend=false $@
	terraform validate -check-variables=false $@

.PHONY: test $(SUBDIRS)
