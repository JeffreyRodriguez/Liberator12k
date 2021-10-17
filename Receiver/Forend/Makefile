include ../../Makefile.in

# Forend Classes
Classes := TopBreak Revolver
Classes_HTML=$(addsuffix .html, $(Classes))

TopBreak_Presets := CAFE12 CAFE12+ FP37
Revolver_Presets := ZZR6x12
Presets := $(addprefix TopBreak_,$(TopBreak_Presets)) $(addprefix Revolver_,$(Revolver_Presets))

Prints:= $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_prints,$(call preset_class_name,$(Preset)).scad)))
Hardware := $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_hardware,$(call preset_class_name,$(Preset)).scad)))
Fixtures := $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_fixtures,$(call preset_class_name,$(Preset)).scad)))
Projections := $(foreach Preset,$(Presets),$(addprefix $(Preset)/, $(call list_projections,$(call preset_class_name,$(Preset)).scad)))

Prints_STL=$(addsuffix .stl, $(Prints))
Hardware_STL= $(addsuffix .stl, $(Hardware))
Fixtures_STL=$(addsuffix .stl, $(Fixtures))
Projections_DXF=$(addsuffix .dxf, $(Projections))
Projections_SVG=$(addsuffix .svg, $(Projections))

Prints_STL_thumbs=$(addsuffix _thumb.jpg, $(Prints))
Assembly_STL=$(addprefix Assembly/, $(Prints_STL) $(Hardware_STL))
Assembly: $(Assembly_STL)

Preset_STLS := $(Prints_STL)
Preset_Thumbs := $(addsuffix _thumb.jpg,$(basename $(Preset_STLS)))
Preset_Assembly := $(addsuffix /Assembly.jpg,$(Presets))
Preset_MP4 := $(addsuffix .mp4, $(Preset_STLS))

foo:
	@echo Prints_STL: $(Prints_STL)
	@echo Assembly_STL: $(Assembly_STL)
	@echo Preset_Thumbs: $(Preset_Thumbs)

Assembly/%_*: %.scad Assembly/
	$(eval CLASS_Preset=$(firstword $(subst /, , $(subst Assembly/,, $@))))
	$(eval CLASS=$(shell echo $(CLASS_Preset) | awk -F _ '{ print $$1 }'))
	$(eval Preset=$(shell echo $(CLASS_Preset) | awk -F _ '{ print $$2 }'))
	$(eval PART=$(basename $(notdir $@)))
	$(OSBIN) $(OSOPTS) -o $@ --render \
	  -D _RENDER=\"$(PART)\"  -D _RENDER_PRINT=false \
	  $(CLASS).scad

# Preview_htmldoc.jpg - Downsampled 800px
$(addsuffix /Preview_htmldoc.jpg,$(Presets)): %_htmldoc.jpg : %.png
	#cp $< $@
	convert -resize 1600x900^ $< -quality 90 $@

.SECONDEXPANSION:
	
# Class/Preset dirs depend on their respective source
$(Classes) $(Presets): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))
	mkdir -p $@
	touch $@

TARGETS =  README.html Assembly $(Presets) $(Preset_Thumbs) $(Preset_Assembly) $(Assembly_STL) #$(Preset_MP4)

clean-dir:
	rm -rf $(TARGETS)

all: $(SUBDIRS) $(TARGETS)
