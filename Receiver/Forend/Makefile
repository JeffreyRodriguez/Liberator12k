include ../../Makefile.in

# Forend Classes
CLASSES := TopBreak Revolver
CLASS_HTML := $(addsuffix .html,$(CLASSES))

# Forend Class Parts
TopBreak_Parts := ReceiverFront \
		              Forend \
									Cluster\
									VerticalForegrip \
                  BarrelCollar \
                  Extractor \
									LatchTab \
						      Sightpost \
						      Fixture/BarrelSleeveFixture
TopBreak_Hardware := Hardware/Barrel \
                     Hardware/ExtractorBit \
										 Hardware/ExtractorRetainer \
										 Hardware/LatchBars \
										 Hardware/MlokBolts \
										 Hardware/ClusterBolts \
										 Hardware/SightpostBolts

Revolver_Parts := ReceiverFront \
						      FrameSpacer \
						      BarrelSupport \
						      Foregrip \
						      CylinderCore \
						      CylinderShell \
						      ForendSpindleToggleLinkage \
						      ForendSpindleToggleHandle

# Revolver_Hardware := Barrel \
#                      CylinderSpindle \
# 										 ForendSpindle \
# 										 ForendSpindlePin \
# 										 ForendSpindleLinkagePin \
# 										 ForendSpindleTogglePin \
# 										 PumpLockRod \
# 										 BlastPlateBolts \
# 										 BlatePlate \
# 										 Shield

# Forend Presets
TopBreak_PRESETS := CAFE12 CAFE12+ FP37
Revolver_PRESETS := ZZR6x12

PRESETS := $(addprefix TopBreak_,$(TopBreak_PRESETS)) $(addprefix Revolver_,$(Revolver_PRESETS))

# All Part STLs for all forend presets Class_Preset/Part.stl
TopBreak_STLS := $(addprefix TopBreak_, $(foreach PRESET,$(TopBreak_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(TopBreak_Parts)))))
Revolver_STLS := $(addprefix Revolver_, $(foreach PRESET,$(Revolver_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(Revolver_Parts)))))

TopBreak_Hardware_STL := $(addprefix TopBreak_, $(foreach PRESET,$(TopBreak_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(TopBreak_Hardware)))))
Revolver_Hardware_STL := $(addprefix Revolver_, $(foreach PRESET,$(Revolver_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(Revolver_Hardware)))))

PRESET_STLS := $(TopBreak_STLS) $(Revolver_STLS)
PRESET_THUMBS := $(addsuffix _thumb.jpg,$(basename $(PRESET_STLS)))
PRESET_ASSEMBLY_PNG := $(addsuffix /Assembly.png,$(PRESETS))
PRESET_HTML := $(addsuffix /README.html,$(PRESETS))
PRESET_MP4 := $(addsuffix .mp4, $(PRESET_STLS))


Assembly_STL=$(addprefix Assembly/, $(TopBreak_STLS) $(TopBreak_Hardware_STL) $(Revolver_STLS) $(Revolver_Hardware_STL));

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
