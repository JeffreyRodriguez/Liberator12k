include ../Makefile.in
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl
Stock_STL=Stock.stl Stock_Buttpad.stl Stock_Backplate.stl
FCG_STL=FCG_Housing.stl FCG_Disconnector.stl FCG_FiringPinCollar.stl \
        FCG_ChargingHandle.stl \
				FCG_Hammer.stl FCG_HammerTail.stl \
				FCG_TriggerLeft.stl FCG_TriggerMiddle.stl FCG_TriggerRight.stl
	
Assembly_VIEWS=Minuteman FramedReceiver Stock Lower FCG
	
Assembly_Minuteman.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		$<
Assembly_FramedReceiver.png: Assembly.scad
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

README.html: $(addprefix Assembly_,$(addsuffix .jpg, $(Assembly_VIEWS)))

# Subdirs
Forend Lower Components: FORCE
	$(MAKE) -C $@

.SECONDEXPANSION:
Receiver FCG Frame Stock: $$($$@_STL) $$@.html

all: README.html Receiver FCG Frame Stock Lower Forend Components $(STL_PREVIEWS)
 