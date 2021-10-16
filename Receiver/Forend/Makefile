include ../../Makefile.in

# Forend Classes
CLASSES := TopBreak Revolver
CLASS_HTML := $(addsuffix .html,$(CLASSES))

# Forend Class Parts
TopBreak_Renders := $(call list_renders,TopBreak.scad)
TopBreak_Prints := $(filter Prints/%, $(TopBreak_Renders))
TopBreak_Fixtures := $(filter Fixtures/%, $(TopBreak_Renders))
TopBreak_Projections := $(filter Projection/%, $(TopBreak_Renders))
TopBreak_Hardware := $(filter Hardware/%, $(TopBreak_Renders))

Revolver_Renders := $(call list_renders,Revolver.scad)
Revolver_Prints := $(filter Prints/%, $(Revolver_Renders))
Revolver_Fixtures := $(filter Fixtures/%, $(Revolver_Renders))
Revolver_Projections := $(filter Projection/%, $(Revolver_Renders))
Revolver_Hardware := $(filter Hardware/%, $(Revolver_Renders))

# Forend Presets
TopBreak_PRESETS := CAFE12 CAFE12+ FP37
Revolver_PRESETS := ZZR6x12

PRESETS := $(addprefix TopBreak_,$(TopBreak_PRESETS)) $(addprefix Revolver_,$(Revolver_PRESETS))

# All Part STLs for all forend presets Class_Preset/Part.stl
TopBreak_STLS := $(addprefix TopBreak_, $(foreach PRESET,$(TopBreak_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(TopBreak_Prints)))))
Revolver_STLS := $(addprefix Revolver_, $(foreach PRESET,$(Revolver_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(Revolver_Prints)))))

Forend_STLS := $(TopBreak_STLS) $(Revolver_STLS)

PRESET_STLS := $(filter-out */Projection/, $(filter-out Hardware/, $(Forend_STLS)))
PRESET_THUMBS := $(addsuffix _thumb.jpg,$(basename $(PRESET_STLS)))
PRESET_ASSEMBLY_PNG := $(addsuffix /Assembly.png,$(PRESETS))
PRESET_HTML := $(addsuffix /README.html,$(PRESETS))
PRESET_MP4 := $(addsuffix .mp4, $(PRESET_STLS))

Assembly_STL=$(addprefix Assembly/, $(TopBreak_STLS) $(Revolver_STLS));

Assembly: $(Assembly_STL)

Assembly/%_*: %.scad Assembly/
	$(eval CLASS_PRESET=$(firstword $(subst /, , $(subst Assembly/,, $@))))
	$(eval CLASS=$(shell echo $(CLASS_PRESET) | awk -F _ '{ print $$1 }'))
	$(eval PRESET=$(shell echo $(CLASS_PRESET) | awk -F _ '{ print $$2 }'))
	$(eval PART=$(basename $(notdir $@)))
	$(OSBIN) $(OSOPTS) -o $@ --render \
	  -D _RENDER=\"$(PART)\"  -D _RENDER_PRINT=false \
	  $(CLASS).scad

# Preview_htmldoc.jpg - Downsampled 800px
$(addsuffix /Preview_htmldoc.jpg,$(PRESETS)): %_htmldoc.jpg : %.png
	#cp $< $@
	convert -resize 1600x900^ $< -quality 90 $@

# HTML file for the preset
$(PRESET_HTML): %/README.html : %.md %/Assembly.jpg %/Preview_thumb.jpg %/Preview_htmldoc.jpg 
	mkdir -p $(dir $@)
	$(MDBIN) $< | sed 's/\.md/\.html/' > $@
	
$(CLASS_HTML): %.html : %.md
	mkdir -p $(dir $@)
	$(MDBIN) $< | sed 's/\.md/\.html/' > $@

.SECONDEXPANSION:
	
# Class/Preset dirs depend on their respective source
$(CLASSES) $(PRESETS): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))
	mkdir -p $@
	touch $@

TARGETS =  README.html $(CLASS_HTML) $(PRESET_STLS) $(PRESET_THUMBS) $(PRESET_HTML) $(Assembly_STL) #$(PRESET_MP4)

clean-dir:
	rm -rf $(TARGETS)

all: $(SUBDIRS) $(TARGETS)
