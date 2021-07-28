include ../Makefile.in
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl
Stock_STL=Stock.stl Stock_Buttpad.stl Stock_Backplate.stl
FCG_STL=FCG_ChargingHandle.stl FCG_Disconnector.stl FCG_FiringPinCollar.stl \
        FCG_Housing.stl FCG_Hammer.stl FCG_HammerTail.stl \
				FCG_Trigger_Left.stl FCG_Trigger_Middle.stl FCG_Trigger_Right.stl

# Subdirs
Forend Lower Components: FORCE
	$(MAKE) -C $@

.SECONDEXPANSION:
Receiver FCG Frame Stock: $$($$@_STL) $$@.html

all: README.html Receiver FCG Frame Stock Lower Forend Components $(STL_PREVIEWS)
 