include ../Makefile.in

Components=Receiver Frame Stock FCG
Components_HTML=$(addsuffix .html, $(Components))

Receiver_Parts=Receiver Receiver_Back
Receiver_Hardware=Receiver_MlokBolts Receiver_TakedownPin Receiver_TensionBolts

Frame_Parts=Frame_Receiver
Frame_Hardware=Frame_Bolts

Stock_Parts=Stock Stock_Buttpad Stock_Backplate
Stock_Hardware=Stock_ButtpadBolt Stock_TakedownPin Stock_TakedownPinRetainer

FCG_Parts=FCG_Housing FCG_Disconnector FCG_FiringPinCollar \
          FCG_ChargingHandle \
				  FCG_Hammer FCG_HammerTail \
				  FCG_TriggerLeft FCG_TriggerMiddle FCG_TriggerRight
FCG_Hardware=FCG_ActionRod FCG_RecoilPlate \
             FCG_DisconnectorTripBolt FCG_DisconnectorPivotPin \
						 FCG_HammerBolt FCG_Sear FCG_FiringPin FCG_FiringPinSpring \
						 FCG_RecoilPlateCenterBolts FCG_RecoilPlateSideBolts \
						 FCG_ChargingHandleBolt FCG_ChargingHandleSpring

Receiver_STL=$(addsuffix .stl, $(Receiver_Parts))
Frame_STL=$(addsuffix .stl, $(Frame_Parts))
Stock_STL=$(addsuffix .stl, $(Stock_Parts))
FCG_STL=$(addsuffix .stl, $(FCG_Parts))

Parts=$(Receiver_Parts) $(Frame_Parts) $(Stock_Parts) $(FCG_Parts)
Parts_STL=$(addsuffix .stl, $(Parts))
Parts_STL_thumbs=$(addsuffix _thumb.jpg, $(Parts))

Hardware=$(Receiver_Hardware) $(Frame_Hardware) $(Stock_Hardware) $(FCG_Hardware)
Hardware_STL= $(addsuffix .stl, $(Hardware))

Assembly_STL=$(addprefix Assembly/, $(Parts_STL) $(Hardware_STL));
Assembly_VIEWS=CAFE12 Minuteman Frame Stock Lower FCG
ASSEMBLY_JPG=$(addprefix Assembly_,$(addsuffix .jpg, $(Assembly_VIEWS)))

TARGETS = README.html $(ASSEMBLY_JPG) $(Components_HTML) $(Parts_STL) $(THUMBNAILS) $(Assembly_STL)

Assembly_Minuteman.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		$<
Assembly_Frame.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$<
Assembly_Stock.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=true \
		$<
Assembly_Lower.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=true \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$<
Assembly_FCG.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$<
Assembly_CAFE12.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,1500,200,0,0,0 \
		-D _FOREND='"TopBreak"' \
		$<
		
.SECONDEXPANSION:
$(addsuffix .html,$(Components)): $$(addsuffix _thumb.jpg, $$($$@_Parts))
# $(STLS): $$($$@_thumbnails)
# 	$(eval SOURCE=$(shell echo $($@) | awk -F _ '{ print $$1 }'))
# 	$(eval PART=$(basename $(notdir $@)))
# 	$(OSBIN) $(OSOPTS) -o $@.stl -o $(basename $@).png \
# 	--render -D _RENDER=\"$(PART)\" \
# 	--projection=p --autocenter --viewall \
# 	$(SOURCE).scad

FCG Frame Stock: $$($$@_STL) $$($$@_thumbnails) $$@.html

clean-dir:
	rm -rf $(TARGETS)

all: $(SUBDIRS) $(TARGETS)
 