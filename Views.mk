ifndef MAKEFILE_IN
include Makefile.in
endif

ASSEMBLY_SRC=src/Assembly.scad

$(VIEWS_DIR)/Preview_Minuteman.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
	  --projection=p --camera=200,800,200,-100,0,0 \
	  $< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Frame.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Stock.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-100,500,100,-250,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=true \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Lower.png: Lower.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		$(call scad_view,$<) \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_FCG.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=100,400,200,-100,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_CAFE12+.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _FOREND='"TopBreak"' \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_CAFE12.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _FOREND='"TopBreak"' \
		-p src/Forend/TopBreak.json -P "CAFE12" \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_FP37.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _FOREND='"TopBreak"' \
		-p src/Forend/TopBreak.json -P "FP37" \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_ZZR.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _FOREND='"Revolver"' \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_EVOLver.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _FOREND='"Evolver"' \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Minuteman.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _ALPHA=0.1 \
		-D _CONFIGURATION='"Stocked"' \
		-D _RECEIVER_SIZE='"Framed"' \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=true \
		-D _SHOW_FOREND=true \
		-D _SHOW_STOCK=true \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Lower.png: $(ASSEMBLY_SRC) src/Receiver/Lower.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		$(call scad_view,$<) \
		-D _ALPHA_LOWER=0.1 \
		-D _ALPHA_LOWER_MOUNT=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_FCG.png: $(ASSEMBLY_SRC) src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _ALPHA_RECEIVER=0.1 \
		-D _ALPHA_LOWER=0.1 \
		-D _ALPHA_FIRING_PIN_HOUSING=0.2 \
		-D _ALPHA_RECOIL_PLATE=0.2 \
		-D _ALPHA_FCG_TRIGGER=0.1 \
		-D _ALPHA_LOWER=0.2 \
		-D _CUTAWAY_RECEIVER=0.1 \
		-D _SHOW_LOWER_HARDWARE=true \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_CAFE.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=230,300,-100,125,0,0 \
		-p src/Forend/TopBreak.json -P "CAFE12" \
		-D _ALPHA=0.1 \
		-D _CONFIGURATION='"Stocked"' \
		-D _RECEIVER_SIZE='"Framed"' \
		-D _FOREND='"TopBreak"' \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=true \
		-D _SHOW_FOREND=true \
		-D _SHOW_STOCK=true \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

# Special previews, specific configurations
Preview=Minuteman CAFE12 FP37 ZZR EVOLver
Preview_PNG=$(addprefix Preview_,$(addsuffix .png, $(Preview)))

XRay=Minuteman CAFE
XRay_PNG=$(addprefix XRay_,$(addsuffix .png, $(XRay)))

VIEWS=$(Preview_PNG) $(XRay_PNG)

TARGETS = $(addprefix $(VIEWS_DIR)/, $(VIEWS))

.views/:
	mkdir -p $@

$(TARGETS): .views/

clean-dir: 
	rm -rf $(TARGETS)

all: $(TARGETS)
