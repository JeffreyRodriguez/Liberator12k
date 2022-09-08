include ../../Makefile.in
include ../STL.mk
include ../Animation.mk

# Forend Classes
Classes := TopBreak Revolver Evolver

TopBreak_Presets := CAFE12 CAFE12+ FP37
Revolver_Presets := ZZR6x12
Evolver_Presets := 12GA
Presets := $(addprefix TopBreak_,$(TopBreak_Presets)) \
	$(addprefix Revolver_,$(Revolver_Presets)) \
        $(addprefix Evolver_,$(Evolver_Presets))

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

Preset_STL := $(addprefix $(EXPORT_DIR)/, $(Prints_STL))
Preset_PNG := $(addprefix $(EXPORT_DIR)/, $(addsuffix .png,$(basename $(Prints))))
Preset_MP4 := $(addprefix .animations, $(addsuffix .mp4, $(Presets)))
Preset_Fixtures_STL := $(addprefix $(EXPORT_DIR)/, $(Fixtures_STL))
Preset_Projections_DXF := $(addprefix $(EXPORT_DIR)/, $(Fixtures_STL))

Preset_Assembly_STL := $(addprefix $(ASSEMBLY_DIR)/, $(addsuffix .png,$(Presets)))
Preset_Assembly_PNG := $(addprefix $(ASSEMBLY_DIR)/, $(addsuffix .png,$(Presets)))

$(addsuffix .parts, $(Presets)):
	echo "$(subst ${space},${\n},$(filter .export/$(basename $@)%, $(Preset_STL)))" > $@

.SECONDEXPANSION:

# Class/Preset dirs depend on their respective source
$(addprefix .export/, $(Presets)): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))

TARGETS=$(Assembly_STL) $(Assembly_PNG) \
	  $(Preset_Assembly_STL) $(Preset_Assembly_PNG) \
          $(Preset_STL) $(Preset_PNG) \
	  $(Preset_Fixtures_STL) \
          $(Preset_Projections_DXF)

clean-dir:
	rm -rf $(TARGETS) $(EXPORT_DIR) $(ASSEMBLY_DIR) $(Presets)

all: $(SUBDIRS) $(TARGETS)
