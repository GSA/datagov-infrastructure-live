SUBDIRS := \
  catalog \
  crm \
  dashboard \
  inventory \
  jumpbox \
  modules/db \
  modules/mysql \
  modules/postgresdb \
  modules/stateful \
  modules/stateless \
  modules/web \
  solr \
  vpc \
  wordpress

test: $(SUBDIRS)
$(SUBDIRS):
	terraform init -backend=false $@
	terraform validate -check-variables=false $@

.PHONY: test $(SUBDIRS)
