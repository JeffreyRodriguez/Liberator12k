include Makefile.in

ZIP_EXTRAS:=$(BUILD_DIR)/changelog.txt $(BUILD_DIR)/source/

MINUTEMAN_ASSEMBLY_DIR=src/Receiver/$(ASSEMBLY_DIR)/
MINUTEMAN_EXPORT_DIR=src/Receiver/$(EXPORT_DIR)/
FOREND_ASSEMBLY_DIR=src/Forend/$(ASSEMBLY_DIR)/
FOREND_EXPORT_DIR=src/Forend/$(EXPORT_DIR)/

MINUTEMAN_FILTER_OUT_WORDS=Receiver_ Bullpup_

MINUTEMAN_ASSEMBLY=$(subst $(MINUTEMAN_ASSEMBLY_DIR),,\
                     $(call filter_out_string,Receiver_,\
                       $(call filter_out_string,Bullpup_,\
                         $(shell find '$(MINUTEMAN_ASSEMBLY_DIR)' -regex '.*?[stl|dxf]$$'))))
MINUTEMAN_EXPORT=$(subst $(MINUTEMAN_EXPORT_DIR),,\
                   $(call filter_out_string,Receiver_,\
                     $(call filter_out_string,Bullpup_,\
                       $(shell find '$(MINUTEMAN_EXPORT_DIR)' -regex '.*?[stl|dxf]$$'))))

FOREND_ASSEMBLY=$(subst $(FOREND_ASSEMBLY_DIR),,\
                  $(shell find '$(FOREND_ASSEMBLY_DIR)' -regex '.*[stl|dxf]$$'))
FOREND_EXPORT=$(subst $(FOREND_EXPORT_DIR),,\
                $(shell find '$(FOREND_EXPORT_DIR)' -regex '.*[stl|dxf]$$'))

foo:
	echo $(MINUTEMAN_ASSEMBLY)

define Zip_template =
ZIP_TARGETS+=dist/Liberator12k-$1.zip
$1_UNITS=$(shell grep ':units:' doc/$1.adoc | awk '{ print $$2 }')

$1_MINUTEMAN_ASSEMBLY_FILES=$$(call filter_string,$$($1_UNITS)/,$(MINUTEMAN_ASSEMBLY))
$1_MINUTEMAN_EXPORT_FILES=$$(call filter_string,$$($1_UNITS)/,$(MINUTEMAN_EXPORT))
$1_ASSEMBLY_FILES=$(call filter_string,$1/,$(FOREND_ASSEMBLY))
$1_EXPORT_FILES=$(call filter_string,$1/,$(FOREND_EXPORT))

.PHONY: $1
$1:
	@echo Model: $1
	@echo Units: $$($1_UNITS)
	@echo Forend Assembly Files:
	@echo $$($1_ASSEMBLY_FILES) | tr ' ' '\n'
	@echo Forend Export Files:
	@echo $$($1_EXPORT_FILES) | tr ' ' '\n'
	@echo Minuteman Assembly Files:
	@echo $$($1_MINUTEMAN_ASSEMBLY_FILES) | tr ' ' '\n'
	@echo Minuteman Export Files:
	@echo $$($1_MINUTEMAN_EXPORT_FILES) | tr ' ' '\n'

dist/Liberator12k-$1.zip: $(ZIP_EXTRAS) $(VIEWS_DIR) $(SUBDIRS) dist/
	@echo Target: $$@
	cd doc/$(EXPORT_DIR) && \
	  zip -9qr ../../$$@ $1.pdf && \
	  cd - >/dev/null && \
	cd $(BUILD_DIR) && \
	  zip -9qr ../$$@ $(subst $(BUILD_DIR)/,,$(ZIP_EXTRAS)) && \
	  cd - >/dev/null && \
	cd src/Receiver/$(ASSEMBLY_DIR) && \
	  zip -9qr ../../../$$@ $$($1_MINUTEMAN_ASSEMBLY_FILES) && \
	  cd - >/dev/null && \
	cd src/Receiver/$(EXPORT_DIR) && \
	  zip -9qr ../../../$$@ $$($1_MINUTEMAN_EXPORT_FILES) && \
	  cd - >/dev/null && \
	cd src/Forend/$(ASSEMBLY_DIR) && \
	  zip -9qr ../../../$$@ $$($1_ASSEMBLY_FILES) && \
	  cd - >/dev/null && \
	cd src/Forend/$(EXPORT_DIR) && \
	  zip -9qr ../../../$$@ $$($1_EXPORT_FILES) && \
	  cd - >/dev/null 
endef

MODELS=$(notdir $(basename $(wildcard doc/*.adoc)))
$(foreach MODEL,$(MODELS),$(eval $(call Zip_template,$(MODEL))))

DIST:=dist/Liberator12k.zip dist/source.zip dist/Liberator12k-assembly.zip
TARGETS:=$(VIEWS_DIR) $(ZIP_TARGETS) $(DIST)

$(BUILD_DIR)/source/: .git
	rm -rf $@ && \
	git clone --depth=1 "file://$(CURDIR)" $@ && \
	cd $@ && \
	git remote set-url origin https://github.com/JeffreyRodriguez/Liberator12k.git

dist/Liberator12k-full.zip: $(SUBDIRS) $(ZIP_EXTRAS)
	@echo Target: $@
	@cd doc/$(EXPORT_DIR) && \
	  zip -9qr ../../$@ *.pdf && \
	  cd - >/dev/null && \
	@cd $(BUILD_DIR) && \
	  zip -9qr ../$@ $(subst $(BUILD_DIR)/,,$(ZIP_EXTRAS)) && \
	  cd - >/dev/null && \
	@cd $(MINUTEMAN_ASSEMBLY_DIR) && \
	  zip -9qr ../../../$@ $(subst $(MINUTEMAN_ASSEMBLY_DIR),,$(MINUTEMAN_ASSEMBLY)) && \
	  cd - >/dev/null && \
	@cd $(MINUTEMAN_EXPORT_DIR) && \
	  zip -9qr ../../../$@ $(subst $(MINUTEMAN_EXPORT_DIR),,$(MINUTEMAN_EXPORT)) && \
	  cd - >/dev/null && \
	@cd $(FOREND_ASSEMBLY_DIR) && \
	  zip -9qr ../../../$@ $(subst $(FOREND_ASSEMBLY_DIR),,$(FOREND_ASSEMBLY)) && \
	  cd - >/dev/null && \
	@cd $(FOREND_EXPORT_DIR) && \
	  zip -9qr ../../../$@ $(subst $(FOREND_EXPORT_DIR),,$(FOREND_EXPORT)) && \
	  cd - >/dev/null 

.PHONY: MODELS
MODELS:
	@echo $(MODELS)

.PHONY: MINUTEMAN
MINUTEMAN:
	@echo $(MINUTEMAN_ASSEMBLY)

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
