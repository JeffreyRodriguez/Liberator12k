MDBIN=cmark-gfm -e table --unsafe
OSBIN=nice openscad
THUMBNAILBIN=convert -thumbnail 200
OSOPTS=--imgsize=1920,1080
RENDER_ANIMATIONS=true
RENDER_STL=true
RENDER_HTML=true
COLORSCHEME=Starnight
FRAME_COUNT=20
FRAMES=$(shell seq 0 $(FRAME_COUNT))
SLOW_FRAME_COUNT=300
SLOW_FRAMES=$(shell seq 0 $(SLOW_FRAME_COUNT))

Trigger_STL=Trigger_Left.stl Trigger_Middle.stl Trigger_Right.stl
Lower_STL=Lower_Left.stl Lower_Middle.stl Lower_Right.stl
LowerMount_STL=LowerMount_Front.stl LowerMount_Rear.stl

.frames/%.mp4: %.scad
	mkdir -p $@
	for i in $(FRAMES); do \
	  FILE=`printf '$@/frame%05d.png' $$i`; \
	  T=`echo "1/$(FRAME_COUNT)*$$i" | bc -l`; \
	  $(OSBIN) $(OSOPTS) -o $$FILE -D '$$t'=`printf '%0.4f' $$T` \
				--projection=p --autocenter --viewall \
				$<; \
	done

%.mp4: %.scad .frames/%.mp4
	../../bin/animate.sh .frames/$@/ $@

%.png: %.scad
	$(OSBIN) $(OSOPTS) -o $@ \
	--projection=p --autocenter --viewall \
	"$(basename $@).scad"
	
	$(THUMBNAILBIN) $@ $(basename $@)_thumb.png

%.html: %.scad %.md %.png %.mp4
	$(MDBIN) $(basename $@).md > $@

%_Left.stl %_Right.stl %_Middle.stl %_Front.stl %_Rear.stl: %.scad
	$(OSBIN) $(OSOPTS) -o $@ -o $(basename $@).png \
	  --render -D _RENDER='"$(basename $@)"' \
		--projection=p --autocenter --viewall \
	  $<

	$(THUMBNAILBIN) $(basename $@).png $(basename $@)_thumb.png

clean: clean_ANIMATE clean_STL cleanGCODE cleanMP4 clean_HTML clean_PNG
clean_ANIMATE:
	rm -rf .frames
cleanGCODE:
	rm -f *.gcode
clean_STL:
	rm -f *.stl
cleanMP4:
	rm -f *.mp4
clean_HTML:
	rm -f *.html
clean_PNG:
	rm -f *.png

.SECONDEXPANSION:
all:  Trigger Lower

Trigger Lower: $$($$@_STL) $$@.html
