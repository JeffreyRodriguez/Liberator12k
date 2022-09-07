ifndef MAKEFILE_IN
include Makefile.in
endif

ASSEMBLY_SRC=src/Assembly.scad

$(VIEWS_DIR)/Preview_Minuteman.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
	  --projection=p --camera=225,750,200,-100,0,-50 \
	  $< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Frame.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=25,250,75,-75,0,0 \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_HARDWARE=true \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Stock.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-175,400,75,-260,0,-25 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=true \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Lower.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=25,300,25,-75,0,-65 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=true \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_FCG.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-50,350,125,-75,0,-10 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_CAFE12+.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-D _SHOW_RECEIVER_HARDWARE=true \
		-D _SHOW_STOCK_HARDWARE=true \
		-D _SHOW_FCG=true \
		-D _SHOW_FCG_HARDWARE=true \
		-D _SHOW_TENSION_RODS=true \
		-D _ALPHA_RECEIVER=1 \
		-D _ALPHA_LOWER=1 \
		-D _ALPHA_STOCK=1 \
		-D _ALPHA_FCG=1 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=300,800,200,250,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_Forend.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=150,350,100,75,0,0 \
		-D _SHOW_BRANDING=false \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=false \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false \
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false \
		-D _SHOW_CLUSTER=false \
		-D _SHOW_CLUSTER_BOLTS=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_VERTICAL_GRIP=false \
		-D _SHOW_GRIP_HARDWARE=false \
		-D _SHOW_SIGHTPOST=false \
		-D _SHOW_HANDGUARD_BOLTS=false \
		-D _SHOW_BARREL=false \
		-D _ALPHA_FOREND=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_BarrelCollar.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=150,350,100,75,0,0 \
		-D _SHOW_BRANDING=false \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=true \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false \
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false \
		-D _SHOW_CLUSTER=false \
		-D _SHOW_CLUSTER_BOLTS=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_VERTICAL_GRIP=false \
		-D _SHOW_GRIP_HARDWARE=false \
		-D _SHOW_SIGHTPOST=false \
		-D _SHOW_HANDGUARD_BOLTS=false \
		-D _SHOW_BARREL=false \
		-D _ALPHA_FOREND=0.3\
		-D _ALPHA_COLLAR=1 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_Extractor.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=150,350,100,75,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=true \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=true \
		-D _SHOW_EXTRACTOR_HARDWARE=true \
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false \
		-D _SHOW_CLUSTER=false \
		-D _SHOW_CLUSTER_BOLTS=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_VERTICAL_GRIP=false \
		-D _SHOW_GRIP_HARDWARE=false \
		-D _SHOW_SIGHTPOST=false \
		-D _SHOW_HANDGUARD_BOLTS=false \
		-D _SHOW_BARREL=false \
		-D _ALPHA_FOREND=0.3\
		-D _ALPHA_COLLAR=0.3 \
		-D _ALPHA_EXTRACTOR=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_Latch.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=150,350,100,75,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=true \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false\
		-D _SHOW_LATCH=true \
		-D _SHOW_LATCH_HARDWARE=true\
		-D _SHOW_CLUSTER=false \
		-D _SHOW_CLUSTER_BOLTS=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_VERTICAL_GRIP=false \
		-D _SHOW_GRIP_HARDWARE=false \
		-D _SHOW_SIGHTPOST=false \
		-D _SHOW_HANDGUARD_BOLTS=false \
		-D _SHOW_BARREL=false \
		-D _ALPHA_COLLAR=0.3 \
		-D _ALPHA_LATCH=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_Cluster.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=300,350,100,200,0,-35 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=false \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false\
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false\
		-D _SHOW_CLUSTER=true \
		-D _SHOW_CLUSTER_BOLTS=false\
		-D _SHOW_FOREND=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_HANDGUARD_BOLTS=true\
		-D _SHOW_VERTICAL_GRIP=true \
		-D _SHOW_GRIP_HARDWARE=true \
		-D _SHOW_SIGHTPOST=false \
		-D _SHOW_BARREL=false \
		-D _ALPHA_CLUSTER=0.3 \
		-D _ALPHA_VERTICAL_FOREGRIP=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_Sightpost.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=500,350,200,410,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=false \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false\
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false\
		-D _SHOW_CLUSTER=false \
		-D _SHOW_CLUSTER_BOLTS=false\
		-D _SHOW_FOREND=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_VERTICAL_GRIP=false \
		-D _SHOW_GRIP_HARDWARE=false \
		-D _SHOW_SIGHTPOST=true \
		-D _SHOW_HANDGUARD_BOLTS=false\
		-D _SHOW_BARREL=false \
		-D _ALPHA_SIGHTPOST=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_Handguard.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=350,700,200,250,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=false \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false\
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false\
		-D _SHOW_CLUSTER=true \
		-D _SHOW_CLUSTER_BOLTS=true\
		-D _SHOW_FOREND=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=true \
		-D _SHOW_VERTICAL_GRIP=true \
		-D _SHOW_GRIP_HARDWARE=true \
		-D _SHOW_SIGHTPOST=true \
		-D _SHOW_HANDGUARD_BOLTS=true\
		-D _SHOW_BARREL=true \
		-D _ALPHA_COLLAR=0.3 \
		-D _ALPHA_CLUSTER=0.3 \
		-D _ALPHA_SIGHTPOST=0.3 \
		-D _ALPHA_FOREGRIP=0.3 \
		-D _ALPHA_VERTICAL_FOREGRIP=0.3 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_ForendAndBarrel.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=350,700,200,250,0,0 \
		-D _SHOW_BRANDING=false \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=true \
		-D _SHOW_COLLAR_HARDWARE=true \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false\
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false\
		-D _SHOW_CLUSTER=true \
		-D _SHOW_CLUSTER_BOLTS=true\
		-D _SHOW_FOREND=true \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=true \
		-D _SHOW_VERTICAL_GRIP=true \
		-D _SHOW_GRIP_HARDWARE=true \
		-D _SHOW_SIGHTPOST=true \
		-D _SHOW_HANDGUARD_BOLTS=true\
		-D _SHOW_BARREL=true \
		-D _ALPHA_COLLAR=0.3 \
		-D _ALPHA_FOREND=0.2 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_Forend_CAFE12+_ReceiverFront.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-50,-200,100,-15,0,0 \
		-D _SHOW_BRANDING=false \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_RECEIVER_FRONT=true \
		-D _SHOW_FCG=false \
		-D _SHOW_FCG_HARDWARE=true \
		-D _SHOW_LOWER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_COLLAR=false \
		-D _SHOW_COLLAR_HARDWARE=false \
		-D _SHOW_EXTRACTOR=false \
		-D _SHOW_EXTRACTOR_HARDWARE=false\
		-D _SHOW_LATCH=false \
		-D _SHOW_LATCH_HARDWARE=false\
		-D _SHOW_CLUSTER=false \
		-D _SHOW_CLUSTER_BOLTS=false\
		-D _SHOW_FOREND=false \
		-D _SHOW_FOREND_HARDWARE=false \
		-D _SHOW_FOREGRIP=false \
		-D _SHOW_VERTICAL_GRIP=false \
		-D _SHOW_GRIP_HARDWARE=false \
		-D _SHOW_SIGHTPOST=false \
		-D _SHOW_HANDGUARD_BOLTS=false\
		-D _SHOW_BARREL=false \
		-D _ALPHA_RECEIVER_FRONT=0.3 \
		-D _ALPHA_FCG=0.2 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_CAFE12.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-p src/Forend/TopBreak.json -P "CAFE12" \
		-D _SHOW_RECEIVER_HARDWARE=true \
		-D _SHOW_STOCK_HARDWARE=true \
		-D _SHOW_FCG=true \
		-D _SHOW_FCG_HARDWARE=true \
		-D _SHOW_TENSION_RODS=true \
		-D _ALPHA_RECEIVER=1 \
		-D _ALPHA_LOWER=1 \
		-D _ALPHA_STOCK=1 \
		-D _ALPHA_FCG=1 \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
$(VIEWS_DIR)/Preview_FP37.png: src/Forend/TopBreak.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=$(call scad_pov,$<) \
		-p src/Forend/TopBreak.json -P "FP37" \
		-D _SHOW_RECEIVER_HARDWARE=true \
		-D _SHOW_STOCK_HARDWARE=true \
		-D _SHOW_FCG=true \
		-D _SHOW_FCG_HARDWARE=true \
		-D _SHOW_TENSION_RODS=true \
		-D _ALPHA_RECEIVER=1 \
		-D _ALPHA_LOWER=1 \
		-D _ALPHA_STOCK=1 \
		-D _ALPHA_FCG=1 \
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
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Trigger.png: src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=0,200,50,-55,0,-35 \
		-D _ALPHA_FCG_TRIGGER=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FIRE_CONTROL_HOUSING=false \
		-D _SHOW_FIRING_PIN=false \
		-D _SHOW_HAMMER=false \
		-D _SHOW_HAMMER_TAIL=false \
		-D _SHOW_CHARGING_HANDLE=false \
		-D _SHOW_DISCONNECTOR=false \
		-D _SHOW_DISCONNECTOR_HARDWARE=false \
		-D _SHOW_RECOIL_PLATE=false \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		-D _SHOW_TRIGGER=true \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Hammer.png: src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-60,200,50,-110,0,0 \
		-D _ALPHA_FCG_TRIGGER=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FIRE_CONTROL_HOUSING=false \
		-D _SHOW_FIRING_PIN=false \
		-D _SHOW_HAMMER=true \
		-D _SHOW_HAMMER_TAIL=true \
		-D _SHOW_CHARGING_HANDLE=false \
		-D _SHOW_DISCONNECTOR=false \
		-D _SHOW_DISCONNECTOR_HARDWARE=false \
		-D _SHOW_RECOIL_PLATE=false \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		-D _SHOW_SEAR=false \
		-D _SHOW_TRIGGER=false \
		-D _SHOW_TRIGGER_MIDDLE=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_FiringPin.png: src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=10,75,25,-10,0,0 \
		-D _ALPHA_FCG_TRIGGER=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FIRE_CONTROL_HOUSING=false \
		-D _SHOW_FIRING_PIN=true \
		-D _SHOW_HAMMER=false \
		-D _SHOW_HAMMER_TAIL=false \
		-D _SHOW_CHARGING_HANDLE=false \
		-D _SHOW_DISCONNECTOR=false \
		-D _SHOW_DISCONNECTOR_HARDWARE=false \
		-D _SHOW_RECOIL_PLATE=false \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		-D _SHOW_SEAR=false \
		-D _SHOW_TRIGGER=false \
		-D _SHOW_TRIGGER_MIDDLE=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_FiringPinHousing.png: src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-75,150,50,-10,0,0 \
		-D _ALPHA_FCG_TRIGGER=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FIRE_CONTROL_HOUSING=true \
		-D _SHOW_FIRE_CONTROL_HOUSING_BOLTS=true \
		-D _SHOW_FIRING_PIN=true \
		-D _SHOW_HAMMER=false \
		-D _SHOW_HAMMER_TAIL=false \
		-D _SHOW_CHARGING_HANDLE=false \
		-D _SHOW_DISCONNECTOR=true \
		-D _SHOW_DISCONNECTOR_HARDWARE=true\
		-D _SHOW_RECOIL_PLATE=true \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		-D _SHOW_SEAR=false \
		-D _SHOW_TRIGGER=false \
		-D _SHOW_TRIGGER_MIDDLE=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_FiringPinHousing_NoDisconnector.png: src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-75,150,50,-10,0,0 \
		-D _ALPHA_FCG_TRIGGER=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FIRE_CONTROL_HOUSING=true \
		-D _SHOW_FIRE_CONTROL_HOUSING_BOLTS=true \
		-D _SHOW_FIRING_PIN=true \
		-D _SHOW_HAMMER=false \
		-D _SHOW_HAMMER_TAIL=false \
		-D _SHOW_CHARGING_HANDLE=false \
		-D _SHOW_DISCONNECTOR=false \
		-D _SHOW_DISCONNECTOR_HARDWARE=false \
		-D _SHOW_RECOIL_PLATE=true \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		-D _SHOW_SEAR=false \
		-D _SHOW_TRIGGER=false \
		-D _SHOW_TRIGGER_MIDDLE=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_ChargingHandle.png: src/Receiver/FCG.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-70,250,75,-80,0,25 \
		-D _ALPHA_FCG_TRIGGER=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FIRE_CONTROL_HOUSING=false \
		-D _SHOW_FIRING_PIN=false \
		-D _SHOW_HAMMER=false \
		-D _SHOW_HAMMER_TAIL=false \
		-D _SHOW_CHARGING_HANDLE=true \
		-D _SHOW_DISCONNECTOR=false \
		-D _SHOW_DISCONNECTOR_HARDWARE=false \
		-D _SHOW_RECOIL_PLATE=false \
		-D _SHOW_RECOIL_PLATE_BOLTS=false \
		-D _SHOW_SEAR=false \
		-D _SHOW_TRIGGER=false \
		-D _SHOW_TRIGGER_MIDDLE=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Frame.png: src/Receiver/Frame.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=25,250,75,-75,0,0 \
		-D _ALPHA_FRAME=0.3 \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_FRAME_BOLTS=false \
		-D _SHOW_BRANDING=false \
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Lower.png: $(ASSEMBLY_SRC)
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=25,300,25,-75,0,-65 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=true \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		-D _ALPHA=0.3\
		$< && \
	  convert -fuzz 4% -transparent "#fafafa" $@ $@

$(VIEWS_DIR)/XRay_Stock.png: src/Receiver/Stock.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=$(OS_RES_LOW) -o $@ \
		--projection=p --camera=-175,400,75,-260,0,-25 \
		-D _ALPHA_STOCK=0.3 \
		-D _ALPHA_STOCK_BACKPLATE=0.3 \
		-D _ALPHA_BUTTPAD=0.3 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_STOCK_TAKEDOWN_PIN=false \
		-D _SHOW_LOWER=false \
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
Preview=Minuteman CAFE12 FP37 ZZR EVOLver FCG
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
