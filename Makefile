SUBDIRS=systemd

DESTDIR=/usr/local
BINDIR=$(DESTDIR)/bin

export DESTDIR
export BINDIR

.PHONY: all
all: $(addprefix build-,$(SUBDIRS))

.PHONY: $(addprefix build-,$(SUBDIRS))
$(addprefix build-,$(SUBDIRS)):
	$(MAKE) -C $(@:build-%=%)

.PHONY: clean
clean: $(addprefix clean-,$(SUBDIRS))

.PHONY: $(addprefix clean-,$(SUBDIRS))
$(addprefix clean-,$(SUBDIRS)):
	$(MAKE) -C $(@:clean-%=%) clean
