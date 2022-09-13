include Makefile.in

ASSEMBLY_SRC=src/Assembly.scad

define make_view =
@$(eval CLASS=$(notdir $(basename $<)))
@$(eval VIEW_FILE=$(notdir $(basename $@)).view)
@$(eval CLASS_VIEW_DIR=$(dir $<)/$(CLASS))
@$(eval VIEW_ARGS=$(shell cat $(CLASS_VIEW_DIR)/$(VIEW_FILE)))
mkdir -p $(dir $@)
$(OSBIN) $(OSOPTS) \
  --projection=p --preview \
  --imgsize=$(OS_RES_LOW) -o - --export-format=png \
  $(VIEW_ARGS) \
  $< | convert -fuzz 4% -transparent '#fafafa' png:- $@
endef

define PresetViews_template =
TARGETS+=$(call list_presets_views, $(1))
$(call list_presets_views, $(1)): $(1) $(basename $(1).view)
	$$(make_view)
endef

Forend_SCADS=$(wildcard src/Forend/*.scad)
Receiver_SCADS=$(wildcard src/Receiver/*.scad)
Sources=$(Forend_SCADS) $(Receiver_SCADS) src/Assembly.scad

$(foreach SCAD,$(Sources),$(eval $(call PresetViews_template,$(SCAD))))

clean-dir: 
	rm -rf $(TARGETS)

all: $(TARGETS)
