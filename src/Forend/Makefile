include ../../Makefile.in

# Forend Classes
Classes := TopBreak Revolver Evolver
Classes_HTML=$(addsuffix .html, $(Classes))

TopBreak_Presets := CAFE12 CAFE12+ FP37
Revolver_Presets := ZZR6x12
Evolver_Presets := 12GA
Presets := $(addprefix TopBreak_,$(TopBreak_Presets)) $(addprefix Revolver_,$(Revolver_Presets)) $(addprefix Evolver_,$(Evolver_Presets))

Prints:= $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_prints,$(call preset_class_name,$(Preset)).scad)))
Hardware := $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_hardware,$(call preset_class_name,$(Preset)).scad)))
Fixtures := $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_fixtures,$(call preset_class_name,$(Preset)).scad)))
Projections := $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_projections,$(call preset_class_name,$(Preset)).scad)))

Prints_STL=$(addsuffix .stl, $(Prints))
Hardware_STL= $(addsuffix .stl, $(Hardware))
Fixtures_STL=$(addsuffix .stl, $(Fixtures))
Projections_DXF=$(addsuffix .dxf, $(Projections))

Assembly_STL=$(addprefix Assembly/, $(Prints_STL) $(Hardware_STL))
Assembly_PNG=$(addsuffix /Assembly.png,$(Presets))
Assembly_JPG=$(addsuffix /Assembly.jpg,$(Presets)) $(addsuffix /Assembly_htmldoc.jpg, $(Presets))
Assembly_htmldoc=$(addsuffix /Assembly_htmldoc.jpg, $(Presets))
Assembly: $(Assembly_STL) $(Assembly_JPG) $(Assembly_htmldoc)

Preset_STLS := $(Prints_STL)
Preset_PNG := $(addsuffix .png,$(basename $(Prints)))
Preset_Thumbs := $(addsuffix _thumb.jpg,$(basename $(Preset_STLS)))
Preset_Assembly_PNG := $(addsuffix /Assembly.png,$(Presets))
Preset_Assembly := $(addsuffix /Assembly.jpg,$(Presets))
Preset_MP4 := $(addsuffix .mp4, $(Preset_STLS))

Assembly/%_*: %.scad Assembly/
	$(eval CLASS_Preset=$(firstword $(subst /, , $(subst Assembly/,, $@))))
	$(eval CLASS=$(shell echo $(CLASS_Preset) | awk -F _ '{ print $$1 }'))
	$(eval Preset=$(shell echo $(CLASS_Preset) | awk -F _ '{ print $$2 }'))
	$(eval PART=$(basename $(notdir $@)))
	$(OSBIN) $(OSOPTS) -o $@ --render \
	  -D _RENDER=\"$(PART)\"  -D _RENDER_PRINT=false \
	  $(CLASS).scad

# Preview_htmldoc.jpg - Downsampled 800px
$(Assembly_htmldoc): %/Assembly_htmldoc.jpg : %/Assembly.png

.SECONDEXPANSION:

# Class/Preset dirs depend on their respective source
$(Classes) $(Presets): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))
	mkdir -p $@
	touch $@

TARGETS=README.html Assembly $(Assembly_STL) $(Assembly_PNG) \
					$(Preset_Assembly_PNG) $(Preset_Assembly) \
          $(Preset_STLS) $(Preset_Thumbs) \
					$(Fixtures_STL) $(Projections_DXF)


clean-dir:
	rm -rf $(TARGETS) Assembly $(Presets)

all: $(SUBDIRS) $(TARGETS)
