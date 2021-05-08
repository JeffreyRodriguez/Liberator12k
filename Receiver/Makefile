include ../Makefile.in
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl
Stock_STL=Stock.stl Stock_Buttpad.stl \
          Stock_Latch.stl Stock_LatchPlunger.stl Stock_LatchRetainer.stl\
					Stock_LatchButton_Left.stl Stock_LatchButton_Right.stl
FCG_STL=FCG_ChargingHandle.stl FCG_Disconnector.stl FCG_Housing.stl \
        FCG_Hammer.stl FCG_HammerTail.stl

# Subdirs
Forend Lower: FORCE
		$(MAKE) -C $@

.SECONDEXPANSION:
Receiver FCG Frame Stock: $$($$@_STL) $$@.html $$@.mp4 $$@.png

all: index.html Receiver FCG Frame Stock Lower Forend
