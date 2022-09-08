include ../../Makefile.in
include ../STL.mk
include ../Animation.mk

# Forend Classes
Classes := TopBreak Revolver Evolver

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

Assembly_STL=$(addprefix .assembly/, $(Prints_STL) $(Hardware_STL))
Assembly_PNG=$(addprefix .assembly/, $(addsuffix .png,$(Presets)))

Preset_STLS := $(Prints_STL)
Preset_PNG := $(addsuffix .png,$(basename $(Prints)))
Preset_Assembly_PNG := $(addprefix .assembly/, $(addsuffix .png,$(Presets)))
Preset_MP4 := $(addprefix .animations, $(addsuffix .mp4, $(Presets)))

.SECONDEXPANSION:

# Class/Preset dirs depend on their respective source
$(Classes) $(Presets): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))
	mkdir -p $@
	touch $@

TARGETS=$(Assembly_STL) $(Assembly_PNG) \
	  $(Preset_Assembly_PNG) \
          $(Preset_STLS) $(Preset_PNG) \
	  $(Fixtures_STL) $(Projections_DXF)


clean-dir:
	rm -rf $(TARGETS) Assembly $(Presets)

all: $(SUBDIRS) $(TARGETS)
