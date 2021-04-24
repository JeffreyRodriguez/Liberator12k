include ../Makefile.in
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl

Forend Lower: FORCE
		$(MAKE) -C $@

.SECONDEXPANSION:
Receiver Frame: $$($$@_STL) $$@.html $$@.mp4 $$@.png

all: index.html Receiver Frame Lower Forend
