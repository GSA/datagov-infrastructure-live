SUBDIRS := $(wildcard */.)

test: $(SUBDIRS)
$(SUBDIRS):
	terraform init -backend=false $@
	terraform validate -check-variables=false $@

.PHONY: test $(SUBDIRS)
