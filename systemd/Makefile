INPUT_FILES=\
	$(wildcard *.in)

FILES=$(basename $(INPUT_FILES))

KIO_FUSE_NAMED_SCRIPT_NAME=kio-fuse-named

all: $(FILES)

%: %.in
	m4 \
		-D __BINDIR__=$(BINDIR) \
		-D __DESTDIR__=$(DESTDIR) \
		-D __KIO_FUSE_NAMED_SCRIPT_NAME__=$(KIO_FUSE_NAMED_SCRIPT_NAME) \
		$< > $@

clean:
	$(RM) $(FILES)
