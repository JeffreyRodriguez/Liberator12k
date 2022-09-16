include ../Makefile.in

SRC:=../src
PDFS:=$(addprefix $(EXPORT_DIR)/,$(addsuffix .pdf,$(basename $(wildcard *.adoc))))
TARGETS:=$(PDFS)

.PRECIOUS: $(BUILD_DIR)/Version.adoc
$(BUILD_DIR)/Version.adoc:
	mkdir -p $(BUILD_DIR) && \
	echo :revdate: $(GIT_DATE) > $@ && \
	echo :revnumber: $(GIT_VERSION) >> $@

$(EXPORT_DIR)/%.pdf: %.adoc $(BUILD_DIR)/Version.adoc $(SRC) ../$(VIEWS_DIR)
	mkdir -p $(dir $@) && \
	asciidoctor-pdf --warnings --failure-level=WARN $< --out-file $@

clean-dir:
	rm -rf $(TARGETS)

../$(VIEWS_DIR): FORCE
	$(MAKE) -C ../ -f Views.mk

$(SRC): FORCE
	$(MAKE) -C $@

all: $(SRC)/ $(TARGETS)
