include Makefile.in

ZIP_EXTRAS:=$(BUILD_DIR)/changelog.txt $(BUILD_DIR)/Source/

MINUTEMAN_ASSEMBLY_DIR=src/Receiver/$(ASSEMBLY_DIR)/
MINUTEMAN_EXPORT_DIR=src/Receiver/$(EXPORT_DIR)/
FOREND_ASSEMBLY_DIR=src/Forend/$(ASSEMBLY_DIR)/
FOREND_EXPORT_DIR=src/Forend/$(EXPORT_DIR)/

define Zip_template =
ZIP_TARGETS+=dist/Liberator12k-$1.zip
$1_UNITS=$(shell grep ':units:' doc/$1.adoc | awk '{ print $$2 }')

$1_FOREND_ASSEMBLY_DIR=$(wildcard src/Forend/$(ASSEMBLY_DIR)/*_$1/)
$1_FOREND_EXPORT_DIR=$(wildcard src/Forend/$(EXPORT_DIR)/*_$1/)

.PHONY: $1
$1:
	@echo Model: $1
	@echo Units: $$($1_UNITS)
	@echo Forend Assembly Dir: $$($1_FOREND_ASSEMBLY_DIR)
	@echo Forend Export Dir:$$($1_FOREND_EXPORT_DIR)
	@echo Minuteman Assembly Dir: $(MINUTEMAN_ASSEMBLY_DIR)
	@echo Minuteman Export Dir: $(MINUTEMAN_EXPORT_DIR)

dist/Liberator12k-$1.zip: $(ZIP_EXTRAS) $(VIEWS_DIR) $(SUBDIRS) dist/
	@echo Target: $$@
	@mkdir -p dist/Liberator12k-$1/Receiver \
	          dist/Liberator12k-$1/Forend \
	          dist/Liberator12k-$1/Assembly/Receiver \
	          dist/Liberator12k-$1/Assembly/Forend && \
	for DIR in `ls $(MINUTEMAN_ASSEMBLY_DIR) | grep _$$($1_UNITS)`; do
	  ln --force --symbolic --relative $(MINUTEMAN_ASSEMBLY_DIR)$$$$DIR dist/Liberator12k-$1/Assembly/Receiver/
	done && \
	for DIR in `ls $(MINUTEMAN_EXPORT_DIR) | grep _$$($1_UNITS)`; do
	  ln --force --symbolic --relative $(MINUTEMAN_EXPORT_DIR)$$$$DIR dist/Liberator12k-$1/Receiver/
	done && \
	for DIR in `ls $$($1_FOREND_ASSEMBLY_DIR)`; do
	  ln --force --symbolic --relative $$($1_FOREND_ASSEMBLY_DIR)$$$$DIR dist/Liberator12k-$1/Assembly/Forend/
	done && \
	for DIR in `ls $$($1_FOREND_EXPORT_DIR)`; do
	  ln --force --symbolic --relative $$($1_FOREND_ASSEMBLY_DIR)$$$$DIR dist/Liberator12k-$1/Forend/
	done && \
	cp -r $(ZIP_EXTRAS) dist/Liberator12k-$1/ && \
	cp doc/$(EXPORT_DIR)/$1.pdf dist/Liberator12k-$1 && \
	cd dist/Liberator12k-$1 && \
	zip -9qr ../$$(notdir $$@) .
endef

MODELS=$(notdir $(basename $(wildcard doc/*.adoc)))
$(foreach MODEL,$(MODELS),$(eval $(call Zip_template,$(MODEL))))

DIST:=dist/Liberator12k.zip dist/Liberator12k-assembly.zip
TARGETS:=$(VIEWS_DIR) $(ZIP_TARGETS) $(DIST)

$(BUILD_DIR)/Source/: .git
	rm -rf $@ && \
	mkdir -p $@ && \
	git archive HEAD | tar -x -C $@

dist/Liberator12k-full.zip: $(SUBDIRS) $(ZIP_EXTRAS)
	@echo Target: $@
	@mkdir -p dist/Liberator12k-full/Receiver \
	          dist/Liberator12k-full/Forend \
	          dist/Liberator12k-full/Assembly/Receiver \
	          dist/Liberator12k-full/Assembly/Forend \
	          dist/Liberator12k-full/Manuals && \
	for DIR in `ls $(MINUTEMAN_ASSEMBLY_DIR)`; do
	  ln --force --symbolic --relative $(MINUTEMAN_ASSEMBLY_DIR)$$DIR dist/Liberator12k-full/Assembly/Receiver/
	done && \
	for DIR in `ls $(MINUTEMAN_EXPORT_DIR)`; do
	  ln --force --symbolic --relative $(MINUTEMAN_ASSEMBLY_DIR)$$DIR dist/Liberator12k-full/Receiver/
	done && \
	for DIR in `ls $(FOREND_ASSEMBLY_DIR)`; do
	  ln --force --symbolic --relative $(FOREND_ASSEMBLY_DIR)$$DIR dist/Liberator12k-full/Assembly/Forend/
	done && \
	for DIR in `ls $(FOREND_EXPORT_DIR)`; do
	  ln --force --symbolic --relative $(FOREND_EXPORT_DIR)$$DIR dist/Liberator12k-full/Forend/
	done && \
	cp -r $(ZIP_EXTRAS) dist/Liberator12k-full/&& \
	cp -r doc/$(EXPORT_DIR)/*.pdf dist/Liberator12k-full/Manuals && \
	cd dist/Liberator12k-full && zip -9qr ../$(notdir $@) .

.PHONY: MODELS
MODELS:
	@echo $(MODELS)

$(DIST): dist/
dist/:
	mkdir -p $@

$(VIEWS_DIR): Views.mk
	mkdir -p $@
	$(MAKE) -f Views.mk all

.PRECIOUS: $(BUILD_DIR)/changelog.txt
$(BUILD_DIR)/changelog.txt:
	git log --pretty=format:"%ad - %an (%h) %s" --date=short > $@

clean-dir:
	rm -rf $(ASSEMBLY_DIR) $(BUILD_DIR) $(EXPORT_DIR) $(VIEWS_DIR)
	rm -rf $(TARGETS) dist/

all: $(SUBDIRS) $(TARGETS)
