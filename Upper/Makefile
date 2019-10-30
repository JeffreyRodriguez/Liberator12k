MDBIN=markdown
OSBIN=openscad
OSOPTS=--colorscheme=$(COLORSCHEME)
RENDER_ANIMATIONS=true
RENDER_STL=true
RENDER_HTML=true
COLORSCHEME=Starnight
FRAME_COUNT=100
FRAMES=$(shell seq 0 $(FRAME_COUNT))

#Upper_Orthogonal.mp4:
#	(sh -c '../bin/animate.sh . Upper_Orthogonal.mp4')

all: HTML STL

HTML: Upper.html
STL: Upper_STL Lower_STL


Upper_STL: Upper_M.stl Upper_L.stl Upper_R.stl

Upper_M.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D Upper_PLATER_MIDDLE=true \
	  "Pipe Upper.scad"
Upper_L.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D Upper_PLATER_LEFT=true \
	  "Pipe Upper.scad"
Upper_R.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D Upper_PLATER_RIGHT=true \
	  "Pipe Upper.scad"
Upper_M.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D Upper_PLATER_MIDDLE=true \
		--viewall --autocenter --projection=p \
	  "Pipe Upper.scad"
Upper_L.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D Upper_PLATER_LEFT=true \
		--viewall --autocenter --projection=p \
	  "Pipe Upper.scad"
Upper_R.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D Upper_PLATER_RIGHT=true --projection=p \
		--viewall --autocenter \
	  "Pipe Upper.scad"

Upper.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	--camera=5,7,2,0,0,-0.75 --projection=p \
	--imgsize=1920,1080 \
	"Pipe Upper.scad"
Upper.mp4:
	for i in $(FRAMES); do \
	  FILE=`printf '$@_%05d.png' $$i`; \
	  T=`echo "1/$(FRAME_COUNT)*$$i" | bc -l`; \
	  $(OSBIN) $(OSOPTS) -o $$FILE -D '$$t'=`printf '%0.4f' $$T` \
				--camera=5,7,2,0,0,-0.75 --projection=p \
			  --imgsize=1920,1080 \
				"Pipe Upper.scad"; \
	done
	cd ../.. && ./bin/animate.sh Lower/$@_%05d.png Lower/$@

Upper.html: $(foreach var,.png _M.stl.png _L.stl.png _R.stl.png,$@$var)
	$(MDBIN) Upper.md > $@

Lower.html: $(foreach var,.png _M.stl.png _L.stl.png _R.stl.png,$@$var)
	$(MDBIN) Upper.md > $@

clean: clean_STL clean_MP4 clean_HTML clean_PNG
clean_STL:
	rm -f *.stl
clean_MP4:
	rm -f *.mp4
clean_HTML:
	rm -f *.html
clean_PNG:
	rm -f f*.png
