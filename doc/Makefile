include ../Makefile.in

PDFS:=$(addsuffix .pdf,$(basename $(wildcard *.adoc)))
TARGETS:=$(PDFS) .build/changelog.txt .build/Version.adoc

.build/changelog.txt:
	git log --oneline > $@

.build/Version.adoc:
	mkdir -p .build && \
	echo :revdate: $(GIT_DATE) > $@ && \
	echo :revnumber: $(GIT_VERSION) >> $@

%.pdf: %.adoc .build/Version.adoc
	asciidoctor-pdf --warnings --failure-level=WARN $<

clean-dir:
	rm -rf $(TARGETS)

all: $(TARGETS)
