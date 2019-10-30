MDBIN=markdown
OSBIN=nice openscad
OSOPTS=--colorscheme=$(COLORSCHEME)
RENDER_ANIMATIONS=true
RENDER_STL=true
RENDER_HTML=true
COLORSCHEME=Starnight
FRAME_COUNT=100
FRAMES=$(shell seq 0 $(FRAME_COUNT))
SLOW_FRAME_COUNT=300
SLOW_FRAMES=$(shell seq 0 $(SLOW_FRAME_COUNT))

#Trigger_Orthogonal.mp4:
#	(sh -c '../bin/animate.sh . Trigger_Orthogonal.mp4')

all: HTML STL

HTML: Trigger.html
STL: Trigger_STL Lower_STL


Trigger_STL: Trigger_M.stl Trigger_L.stl Trigger_R.stl

Trigger_M.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D TRIGGER_PLATER_MIDDLE=true \
	  "Trigger.scad"
Trigger_L.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D TRIGGER_PLATER_LEFT=true \
	  "Trigger.scad"
Trigger_R.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D TRIGGER_PLATER_RIGHT=true \
	  "Trigger.scad"
Trigger_M.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D TRIGGER_PLATER_MIDDLE=true \
    --camera=0,0,200,0,0,0 --projection=p \
    --imgsize=1920,1080 \
	  "Trigger.scad"
Trigger_L.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D TRIGGER_PLATER_LEFT=true \
    --camera=0,0,200,0,0,0 --projection=p \
    --imgsize=1920,1080 \
	  "Trigger.scad"
Trigger_R.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D TRIGGER_PLATER_RIGHT=true \
    --camera=0,0,200,0,0,0 --projection=p \
    --imgsize=1920,1080 \
	  "Trigger.scad"

Trigger.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	--camera=5,7,2,0,0,-0.75 --projection=p \
	--imgsize=1920,1080 \
	"Trigger.scad"
Trigger.mp4:
	for i in $(FRAMES); do \
	  FILE=`printf '$@_%05d.png' $$i`; \
	  T=`echo "1/$(FRAME_COUNT)*$$i" | bc -l`; \
	  $(OSBIN) $(OSOPTS) -o $$FILE -D '$$t'=`printf '%0.4f' $$T` \
		    --projection=p \
				--camera=5,7,2,0,0,-0.75 \
			  --imgsize=1920,1080 \
				"Trigger.scad"; \
	done
	cd .. && ./bin/animate.sh Lower/$@_%05d.png Lower/$@

Trigger.html: Trigger.png Trigger.mp4 Trigger_M.stl.png Trigger_L.stl.png  Trigger_R.stl.png
	$(MDBIN) Trigger.md > $@

Lower_STL: Lower_M.stl Lower_L.stl Lower_R.stl

Lower_M.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D LOWER_PLATER_MIDDLE=true \
	  "Lower.scad"
Lower_L.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D LOWER_PLATER_LEFT=true \
	  "Lower.scad"
Lower_R.stl:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D LOWER_PLATER_RIGHT=true \
	  "Lower.scad"

Lower_M.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D LOWER_PLATER_MIDDLE=true \
		--projection=p \
		--camera=0,0,500,0,0,0 \
    --imgsize=1920,1080 \
	  "Lower.scad"
Lower_L.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D LOWER_PLATER_LEFT=true \
		--projection=p \
		--camera=0,0,500,0,0,0 \
    --imgsize=1920,1080 \
	  "Lower.scad"
Lower_R.stl.png:
	$(OSBIN) $(OSOPTS) -o $@ \
	  -D LOWER_PLATER_RIGHT=true \
		--projection=p \
		--camera=0,0,500,0,0,0 \
    --imgsize=1920,1080 \
	  "Lower.scad"
Lower_Spin.mp4:
	for i in $(SLOW_FRAMES); do \
	  FILE=`printf '$@_%05d.png' $$i`; \
	  T=`echo "1/$(SLOW_FRAME_COUNT)*$$i" | bc -l`; \
	  $(OSBIN) $(OSOPTS) -o $$FILE -D '$$t'=`printf '%0.4f' $$T` \
	  		-D SPIN_REVOLUTIONS=2 \
			  --camera=4,12,3,0,0,-1.5 --projection=p \
			  --imgsize=1920,1080 \
				"Lower.scad"; \
	done
	cd .. && ./bin/animate.sh Lower/$@_%05d.png Lower/$@

Lower.mp4:
	for i in $(FRAMES); do \
	  FILE=`printf '$@_%05d.png' $$i`; \
	  T=`echo "1/$(FRAME_COUNT)*$$i" | bc -l`; \
	  $(OSBIN) $(OSOPTS) -o $$FILE -D '$$t'=`printf '%0.4f' $$T` \
	  	  -D SHOW_RIGHT=false \
			  --camera=4,12,3,0,0,-1.5 --projection=p \
			  --imgsize=1920,1080 \
				"Lower.scad"; \
	done
	cd .. && ./bin/animate.sh Lower/$@_%05d.png Lower/$@
Lower.html: $(foreach var,.png _M.stl.png _L.stl.png _R.stl.png,$@$var)
	$(MDBIN) Trigger.md > $@

clean: clean_STL clean_MP4 clean_HTML clean_PNG
clean_STL:
	rm -f *.stl
clean_MP4:
	rm -f *.mp4
clean_HTML:
	rm -f *.html
clean_PNG:
	rm -f f*.png
