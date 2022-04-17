SUBDIRS=systemd

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: clean
clean: $(addprefix clean-,$(SUBDIRS))

.PHONY: $(addprefix clean-,$(SUBDIRS))
$(addprefix clean-,$(SUBDIRS)):
	$(MAKE) -C $(@:clean-%=%) clean
