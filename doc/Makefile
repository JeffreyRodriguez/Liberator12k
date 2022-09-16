include ../Makefile.in

SRC:=../src
PDFS:=$(addprefix $(EXPORT_DIR)/,$(addsuffix .pdf,$(basename $(wildcard *.adoc))))
TARGETS:=$(PDFS) $(BUILD_DIR)/Version.adoc

$(BUILD_DIR)/Version.adoc:
	mkdir -p .build && \
	echo :revdate: $(GIT_DATE) > $@ && \
	echo :revnumber: $(GIT_VERSION) >> $@

$(EXPORT_DIR)/%.pdf: %.adoc .build/Version.adoc $(SRC) ../$(VIEWS_DIR)/
	mkdir -p $(dir $@) && \
	asciidoctor-pdf --warnings --failure-level=WARN $<

clean-dir:
	rm -rf $(TARGETS)

../$(VIEWS_DIR)/: FORCE
	$(MAKE) -C ../ -f Views.mk

$(SRC)/: FORCE
	$(MAKE) -C $@

all: $(SRC)/ $(TARGETS)
