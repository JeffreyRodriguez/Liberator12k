include ../../Makefile.in
ANIMATE_BIN=../../bin/animate.sh
TopBreak_STL=TopBreak_ReceiverFront.stl \
             TopBreak_Forend.stl \
             TopBreak_BarrelCollar.stl \
						 TopBreak_Extractor.stl
TopBreak_CAFE12_STL=TopBreak_CAFE12/TopBreak_ReceiverFront.stl \
           TopBreak_CAFE12/TopBreak_Forend.stl \
           TopBreak_CAFE12/TopBreak_BarrelCollar.stl \
					 TopBreak_CAFE12/TopBreak_Extractor.stl
TopBreak_FP37_STL=TopBreak_FP37/TopBreak_ReceiverFront.stl \
				 TopBreak_FP37/TopBreak_Forend.stl \
				 TopBreak_FP37/TopBreak_BarrelCollar.stl \
				 TopBreak_FP37/TopBreak_Extractor.stl
Revolver_STL=Revolver_ReceiverFront.stl \
             Revolver_FrameSpacer.stl \
						 Revolver_BarrelSupport.stl \
             Revolver_Foregrip.stl \
						 Revolver_CylinderCore.stl \
						 Revolver_CylinderShell.stl \
						 Revolver_ForendSpindleToggleLinkage.stl \
						 Revolver_ForendSpindleToggleHandle.stl
PumpAR15_STL=


.SECONDEXPANSION:
all: index.html TopBreak Revolver PumpAR15 TopBreak_CAFE12 TopBreak_FP37

TopBreak Revolver PumpAR15: $$($$@_STL) $$@.html $$@.mp4 $$@.png

TopBreak_CAFE12.html: TopBreak_CAFE12.md
	$(MDBIN) $(basename $@).md | sed 's/\.md/\.html/' > $@

TopBreak_FP37.html: TopBreak_FP37.md
	$(MDBIN) $(basename $@).md | sed 's/\.md/\.html/' > $@

TopBreak_FP37: $$($$@_STL) $$@.html
TopBreak_CAFE12: $$($$@_STL) $$@.html