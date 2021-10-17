include ../Makefile.in

Components=Receiver Frame Stock FCG Lower
Components_HTML=$(addsuffix .html, $(Components))

Prints:= $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_prints,$(Component).scad)))
Hardware := $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_hardware,$(Component).scad)))
Fixtures := $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_fixtures,$(Component).scad)))
Projections := $(foreach Component,$(Components),$(addprefix $(Component)/, $(call list_projections,$(Component).scad)))

Prints_STL=$(addsuffix .stl, $(Prints))
Hardware_STL= $(addsuffix .stl, $(Hardware))
Fixtures_STL=$(addsuffix .stl, $(Fixtures))
Projections_DXF=$(addsuffix .dxf, $(Projections))
Projections_SVG=$(addsuffix .svg, $(Projections))

Prints_STL_thumbs=$(addsuffix _thumb.jpg, $(Prints))

Assembly_STL=$(addprefix Assembly/, $(Prints_STL) $(Hardware_STL))
Assembly: $(Assembly_STL)

# Special previews, specific configurations
Preview=Minuteman Frame Stock Lower FCG CAFE12 FP37
Preview_PNG=$(addprefix Preview_,$(addsuffix .png, $(Preview)))
Preview_JPG=$(addprefix Preview_,$(addsuffix .jpg, $(Preview)))

Previews: $(Preview_JPG)
	
TARGETS = README.html $(Preview_JPG) $(Components_HTML) $(Prints_STL) $(Prints_STL_thumbs) $(Assembly_STL)

Preview_Minuteman.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		$<
Preview_Frame.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,800,200,-100,0,0 \
		-D _SHOW_RECEIVER=true \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$<
Preview_Stock.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=-100,500,100,-250,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=true \
		$<
Preview_Lower.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=100,400,0,-100,0,-50 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=false \
		-D _SHOW_LOWER=true \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$<
Preview_FCG.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=100,400,200,-100,0,0 \
		-D _SHOW_RECEIVER=false \
		-D _SHOW_FCG=true \
		-D _SHOW_LOWER=false \
		-D _SHOW_FOREND=false \
		-D _SHOW_STOCK=false \
		$<
Preview_CAFE12+.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,1500,200,0,0,0 \
		-D _FOREND='"TopBreak"' \
		$<
Preview_CAFE12.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,1500,200,0,0,0 \
		-D _FOREND='"TopBreak"' \
		-p Forend/TopBreak.json -P "CAFE12" \
		$<
Preview_FP37.png: Assembly.scad
	$(OSBIN) $(OSOPTS) --preview --imgsize=1920,1080 -o $@ \
		--projection=p --camera=200,1500,200,0,0,0 \
		-D _FOREND='"TopBreak"' \
		-p Forend/TopBreak.json -P "FP37" \
		$<
		
.SECONDEXPANSION:
FCG Frame Stock: $$($$@_STL) $$($$@_thumbnails)

clean-dir:
	rm -rf $(TARGETS)

all: $(SUBDIRS) $(TARGETS)
 