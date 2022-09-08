include ../../Makefile.in
include ../STL.mk
include ../Animation.mk

Components=Receiver Frame Stock FCG Lower

Prints:= $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_prints,$(Component).scad)))
Hardware := $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_hardware,$(Component).scad)))
Fixtures := $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_fixtures,$(Component).scad)))
Projections := $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_projections,$(Component).scad)))

Prints_STL=$(addsuffix .stl, $(Prints))
Hardware_STL= $(addsuffix .stl, $(Hardware))
Fixtures_STL=$(addsuffix .stl, $(Fixtures))
Projections_DXF=$(addsuffix .dxf, $(Projections))
Prints_PNG=$(addsuffix .png, $(Prints))

Assembly_STL=$(addprefix $(ASSEMBLY_DIR)/, $(Prints_STL) $(Hardware_STL))
Assembly_PNG=$(addprefix $(ASSEMBLY_DIR)/, $(addsuffix .png,$(Components)))

Assembly_PNG: $(Assembly_PNG)
Assembly: $(Assembly_STL) $(Assembly_PNG)

Animations_MP4=.animations/FCG.mp4

TARGETS = $(addprefix $(EXPORT_DIR)/, $(Prints_STL)) $(addprefix $(EXPORT_DIR)/, $(Prints_PNG)) \
          $(Assembly_STL) $(Assembly_PNG) \
          $(Animations_MP4)

clean-dir:
	rm -rf $(TARGETS) Assembly $(Components)

all: $(SUBDIRS) $(TARGETS)

