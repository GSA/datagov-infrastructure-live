SUBDIRS := $(wildcard */.)

test: $(SUBDIRS)
$(SUBDIRS):
	terraform init -backend=false $@
	terraform validate -var-file=test.tfvars $@

.PHONY: test $(SUBDIRS)
