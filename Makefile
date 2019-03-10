SUBDIRS := \
  app \
  catalog \
  inventory \
  jumpbox \
  solr \
  vpc \
  modules/db \
  modules/postgresdb \
  modules/stateful \
  modules/web

test: $(SUBDIRS)
$(SUBDIRS):
	terraform init -backend=false $@
	terraform validate -check-variables=false $@

.PHONY: test $(SUBDIRS)
