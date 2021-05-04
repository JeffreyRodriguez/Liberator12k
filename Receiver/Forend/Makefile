include ../../Makefile.in
ANIMATE_BIN=../../bin/animate.sh
TopBreak_STL=
Revolver_STL=Revolver_ReceiverFront.stl Revolver_FrameSpacer.stl \
             Revolver_Foregrip.stl Revolver_CylinderCore.stl Revolver_CylinderShell.stl Revolver_BarrelSupport.stl \
						 Revolver_ForendSpindleToggleLinkage.stl Revolver_ForendSpindleToggleHandle.stl
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
