include ../Makefile.in

SRC:=../src
PDFS:=$(addprefix $(EXPORT_DIR)/,$(addsuffix .pdf,$(basename $(wildcard *.adoc))))
TARGETS:=$(PDFS) $(BUILD_DIR)/changelog.txt $(BUILD_DIR)/Version.adoc

$(BUILD_DIR)/changelog.txt:
	git log --oneline > $@

$(BUILD_DIR)/Version.adoc:
	mkdir -p .build && \
	echo :revdate: $(GIT_DATE) > $@ && \
	echo :revnumber: $(GIT_VERSION) >> $@

$(EXPORT_DIR)/%.pdf: %.adoc .build/Version.adoc $(SRC)/
	mkdir -p $(dir $@) && \
	asciidoctor-pdf --warnings --failure-level=WARN $<

clean-dir:
	rm -rf $(TARGETS)

$(SRC)/: FORCE
	$(MAKE) -C $@

all: $(SRC)/ $(TARGETS)
