SUBDIRS := \
  catalog \
  crm \
  inventory \
  jumpbox \
  solr \
  vpc \
  modules/db \
  modules/mysql \
  modules/postgresdb \
  modules/stateful \
  modules/stateless \
  modules/web

test: $(SUBDIRS)
$(SUBDIRS):
	terraform init -backend=false $@
	terraform validate -check-variables=false $@

.PHONY: test $(SUBDIRS)
