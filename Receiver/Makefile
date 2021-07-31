include ../Makefile.in
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl
Stock_STL=Stock.stl Stock_Buttpad.stl Stock_Backplate.stl
FCG_STL=FCG_Housing.stl FCG_Disconnector.stl FCG_FiringPinCollar.stl \
        FCG_ChargingHandle.stl \
				FCG_Hammer.stl FCG_HammerTail.stl \
				FCG_TriggerLeft.stl FCG_TriggerMiddle.stl FCG_TriggerRight.stl

				
Assembly_FramedReceiver.png: Frame.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=400,1500,300,0,0,0 \
		$(CLASS).scad
Assembly_FramedReceiver.jpg: Frame_Assembly.png
	convert $(basename $@).png -quality 90 $@
Assembly_FramedReceiver_thumb.jpg: Frame.png
	$(THUMBNAILBIN) $< $@
Assembly_FramedReceiver_htmldoc.jpg: .png
	cp $< $@
	#convert -resize 800x600^ $< -quality 90 $@

# Subdirs
Forend Lower Components: FORCE
	$(MAKE) -C $@

.SECONDEXPANSION:
Receiver FCG Frame Stock: $$($$@_STL) $$@.html

all: README.html Receiver FCG Frame Stock Lower Forend Components $(STL_PREVIEWS)
 