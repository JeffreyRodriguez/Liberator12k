include ../../Makefile.in

ANIMATE_BIN=../../bin/animate.sh

Lower_STL=Lower_Left.stl Lower_Middle.stl Lower_Right.stl
LowerMount_STL=LowerMount_Front.stl LowerMount_Rear.stl

.SECONDEXPANSION:
all: README.html Lower LowerMount

Lower LowerMount: $$($$@_STL) $$@.html
