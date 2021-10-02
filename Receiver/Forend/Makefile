include ../../Makefile.in

# Forend Classes
CLASSES := TopBreak Revolver

# Forend Class Parts
TopBreak := ReceiverFront \
            Forend \
            BarrelCollar \
            Extractor \
						BarrelSleeveFixture
Revolver := ReceiverFront \
						FrameSpacer \
						BarrelSupport \
						Foregrip \
						CylinderCore \
						CylinderShell \
						ForendSpindleToggleLinkage \
						ForendSpindleToggleHandle

# Forend Presets
TopBreak_PRESETS := CAFE12 CAFE12+ FP37 
Revolver_PRESETS := ZZR6x12

PRESETS := $(addprefix TopBreak_,$(TopBreak_PRESETS)) $(addprefix Revolver_,$(Revolver_PRESETS))

# All Part STLs for all forend presets
TopBreak_STLS := $(addprefix TopBreak_, $(foreach PRESET,$(TopBreak_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(TopBreak)))))
Revolver_STLS := $(addprefix Revolver_, $(foreach PRESET,$(Revolver_PRESETS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(PRESET)),$(Revolver)))))

PRESET_STLS := $(TopBreak_STLS) $(Revolver_STLS)
PRESET_ASSEMBLY_PNG := $(addsuffix /Assembly.png,$(PRESETS))
PRESET_HTML := $(addsuffix /README.html,$(PRESETS))
PRESET_STL_PREVIEWS := $(addsuffix .mp4, $(PRESET_STLS))

CLASS_STLS := $(addsuffix .stl,$(CLASSES))
CLASS_HTML := $(addsuffix /README.html,$(CLASSES))

$(PRESET_STLS): $(PRESETS)
	$(eval CLASS_PRESET=$(firstword $(subst /, ,$@)))
	$(eval CLASS=$(shell echo $(CLASS_PRESET) | awk -F _ '{ print $$1 }'))
	$(eval PRESET=$(shell echo $(CLASS_PRESET) | awk -F _ '{ print $$2 }'))
	$(eval PART=$(basename $(notdir $@)))
	@echo Target: $@
	@echo Deps: $^
	@echo Class_Preset: $(CLASS_PRESET)
	@echo Class: $(CLASS)
	@echo Preset: $(PRESET)
	@echo Part: $(PART)
	@mkdir -p $(dir $@) && \
	$(OSBIN) $(OSOPTS) --render -D _RENDER=\"$(CLASS)_$(PART)\" \
		--projection=p --camera=0,400,400,0,100,100 \
		-o $@ -o $(CLASS_PRESET)/$(PART).png \
		-P $(PRESET) \
		$(CLASS).scad

.SECONDEXPANSION:
# Class/Preset dirs depend on their respective source
$(CLASSES) $(PRESETS): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))
	mkdir -p $@
	touch $@

# Assembly.png - the source of truth
$(addsuffix /Assembly.png,$(PRESETS)): %.png : $$(firstword $$(subst _, ,%)).scad
	$(eval CLASS_PRESET=$(firstword $(subst /, ,$@)))
	$(eval CLASS=$(shell echo $(CLASS_PRESET) | awk -F _ '{ print $$1 }'))
	$(eval PRESET=$(shell echo $(CLASS_PRESET) | awk -F _ '{ print $$2 }'))
	$(eval PART=$(basename $(notdir $@)))
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -P $(PRESET) -o $@ \
		--projection=p --camera=400,1500,300,0,0,0 \
		$(CLASS).scad
$(addsuffix /Assembly.jpg,$(PRESETS)): %.jpg : %.png
	convert $(basename $@).png -quality 90 $@
	
# Preview_htmldoc.jpg - Downsampled 800px
$(addsuffix /Preview_htmldoc.jpg,$(PRESETS)): %_htmldoc.jpg : %.png
	#cp $< $@
	convert -resize 1600x900^ $< -quality 90 $@

# HTML file for the preset
$(PRESET_HTML): %/README.html : %.md %/Assembly.jpg %/Preview_thumb.jpg %/Preview_htmldoc.jpg 
	$(MDBIN) $< | sed 's/\.md/\.html/' > $@
$(CLASS_HTML): %/README.html : %.md
	$(MDBIN) $< | sed 's/\.md/\.html/' > $@

all: README.html $(CLASSES) $(CLASS_HTML) $(PRESETS) $(PRESET_HTML) $(PRESET_STLS) $(PRESET_STL_PREVIEWS)
	