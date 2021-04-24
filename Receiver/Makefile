include ../Makefile
ANIMATE_BIN=../bin/animate.sh
Receiver_STL=Receiver.stl Receiver_Back.stl
Frame_STL=Frame_Receiver.stl

.SECONDEXPANSION:
all: index.html Receiver Frame

Receiver Frame: $$($$@_STL) $$@.html $$@.mp4 $$@.png
