include ../../Makefile.in
ANIMATE_BIN=../../bin/animate.sh

# Forend Classes
CLASSES := TopBreak Revolver

# Forend Class Parts
TopBreak := ReceiverFront \
            Forend \
            BarrelCollar \
            Extractor
Revolver := ReceiverFront \
            FrameSpacer \
            BarrelSupport \
            Foregrip \
            CylinderCore \
            CylinderShell \
            ForendSpindleToggleLinkage \
            ForendSpindleToggleHandle

# Forend Models
TopBreak_MODELS := CAFE12 CAFE12+ FP37 
Revolver_MODELS := ZZR6x12

MODELS := $(addprefix TopBreak_,$(TopBreak_MODELS)) $(addprefix Revolver_,$(Revolver_MODELS))

# All Part STLs for all forend models
TopBreak_STLS := $(addprefix TopBreak_, $(foreach MODEL,$(TopBreak_MODELS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(MODEL)),$(TopBreak)))))
Revolver_STLS := $(addprefix Revolver_, $(foreach MODEL,$(Revolver_MODELS),$(addsuffix .stl, $(addprefix $(addsuffix /, $(MODEL)),$(Revolver)))))

MODEL_STLS := $(TopBreak_STLS) $(Revolver_STLS)
MODEL_HTML := $(addsuffix .html,$(MODELS))

.SECONDEXPANSION:
# Forend Classes
$(CLASSES): $$@.html $$@.mp4 $$@.png
.PHONY: $(CLASSES)

# Model dirs depends on their respective source
$(MODELS): $$(addsuffix .scad,$$(firstword $$(subst _, ,$$@)))
	mkdir -p $@
	touch $@

# Model STL depend on their respective source file
$(MODEL_STLS):
	$(eval CLASS_MODEL=$(firstword $(subst /, ,$@)))
	$(eval CLASS=$(shell echo $(CLASS_MODEL) | awk -F _ '{ print $$1 }'))
	$(eval MODEL=$(shell echo $(CLASS_MODEL) | awk -F _ '{ print $$2 }'))
	$(eval PART=$(basename $(notdir $@)))
	@echo Target: $@
	@echo Deps: $^
	@echo Class_Model: $(CLASS_MODEL)
	@echo Class: $(CLASS)
	@echo Model: $(MODEL)
	@echo Part: $(PART)
	$(OSBIN) $(OSOPTS) --render -D _RENDER=\"$(CLASS)_$(PART)\" \
	  --projection=p --autocenter --viewall \
		-o $@ -o $(CLASS_MODEL)/$(PART).png \
		-P $(MODEL) \
		$(CLASS).scad
	$(THUMBNAILBIN) $(CLASS_MODEL)/$(PART).png $(CLASS_MODEL)/$(PART)_thumb.png

# HTML file for the model
$(addsuffix .html,$(MODELS)): %.html : %.md
	$(MDBIN) $(basename $@).md | sed 's/\.md/\.html/' > $@

all: README.html $(CLASSES) $(MODELS) $(MODEL_HTML) $(MODEL_STLS)