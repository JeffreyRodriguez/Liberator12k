include ../../Makefile.in

ANIMATE_BIN=../../bin/animate.sh

Trigger_STL=Trigger_Left.stl Trigger_Middle.stl Trigger_Right.stl
Lower_STL=Lower_Left.stl Lower_Middle.stl Lower_Right.stl
LowerMount_STL=LowerMount_Front.stl LowerMount_Rear.stl

.SECONDEXPANSION:
all: README.html Trigger Lower LowerMount

Trigger Lower LowerMount: $$($$@_STL) $$@.html .frames/$$@.mp4 $$@.mp4 $$@.png
