include ../Makefile.in
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl
Stock_STL=Stock.stl Stock_Buttpad.stl \
          Stock_Latch.stl Stock_LatchPlunger.stl Stock_LatchRetainer.stl\
					Stock_LatchButton_Left.stl Stock_LatchButton_Right.stl

Forend Lower: FORCE
		$(MAKE) -C $@

.SECONDEXPANSION:
Receiver Frame Stock: $$($$@_STL) $$@.html $$@.mp4 $$@.png

all: index.html Receiver Frame Stock Lower Forend
