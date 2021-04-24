include ../../Makefile.in
ANIMATE_BIN=../../bin/animate.sh
TopBreak_STL=
Revolver_STL=
PumpAR15_STL=
Trigun_STL=


%.stl:
	$(OSBIN) $(OSOPTS) -o $@ -o $(basename $@).png \
		--cache="`echo $(basename $@) | awk -F _ '{ print $$1 }'`.cache" \
	  --render -D _RENDER='"$(basename $@)"' \
		--projection=p --camera 0,1000,0,0,0,0\
	  `echo $(basename $@) | awk -F _ '{ print $$1 }'`.scad
	$(THUMBNAILBIN) $(basename $@).png $(basename $@)_thumb.png

.SECONDEXPANSION:
all: index.html TopBreak Revolver PumpAR15 Trigun

TopBreak Revolver PumpAR15 Trigun: $$($$@_STL) $$@.html $$@.mp4 $$@.png
