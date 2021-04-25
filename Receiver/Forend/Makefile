include ../../Makefile.in
ANIMATE_BIN=../../bin/animate.sh
TopBreak_STL=
Revolver_STL=
PumpAR15_STL=
Trigun_STL=


CAFE12: CAFE12.html
CAFE12.html: CAFE12.md
	$(MDBIN) $^ > $@
	
FP37: FP37.html
FP37.html: FP37.md
	$(MDBIN) $^ > $@

.SECONDEXPANSION:
all: index.html TopBreak Revolver PumpAR15 Trigun CAFE12 FP37

TopBreak Revolver PumpAR15 Trigun: $$($$@_STL) $$@.html $$@.mp4 $$@.png
