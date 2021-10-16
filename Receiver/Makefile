include ../Makefile.in

Components=Receiver Frame Stock FCG Lower
Components_HTML=$(addsuffix .html, $(Components))

Frame_Renders=$(addprefix Frame/,$(call list_renders,Frame.scad))
Lower_Renders=$(addprefix Lower/,$(call list_renders,Lower.scad))
Receiver_Renders=$(addprefix Receiver/,$(call list_renders,Receiver.scad))
Stock_Renders=$(addprefix Stock/,$(call list_renders,Stock.scad))
FCG_Renders=$(addprefix FCG/,$(call list_renders,FCG.scad))


Renders:=$(Frame_Renders) $(Lower_Renders) $(Receiver_Renders) $(Stock_Renders) $(FCG_Renders)
Prints := $(filter Prints/%, $(Renders))
Fixtures := $(filter Fixtures/%, $(Renders))
Projections := $(filter Projection/%, $(Renders))
Hardware := $(filter Hardware/%, $(Renders))

Prints_STL=$(addsuffix .stl, $(Prints))
Prints_STL_png=$(addsuffix .png, $(Prints))
Prints_STL_thumb=$(addsuffix _thumb.jpg, $(Prints))

Fixtures_STL=$(filter-out Projection/,$(filter-out Hardware/,$(addsuffix .stl, $(Prints))))
Fixtures_STL_png=$(addsuffix .png, $(Prints))
Fixtures_STL_thumb=$(addsuffix _thumb.jpg, $(Prints))

Hardware_STL= $(addsuffix .stl, $(Hardware))

Assembly_STL=$(addprefix Assembly/, $(Prints_STL) $(Hardware_STL))
Assembly: $(Assembly_STL)

# Special previews, specific configurations
Preview=Minuteman Frame Stock Lower FCG CAFE12 FP37
Preview_PNG=$(addprefix Preview_,$(addsuffix .png, $(Preview)))
Preview_JPG=$(addprefix Preview_,$(addsuffix .jpg, $(Preview)))

Previews: $(Preview_JPG)

TARGETS = README.html $(Preview_JPG) $(Preview_PNG) $(Components_HTML) $(Prints_STL) $(Prints_STL_png) $(Prints_STL_thumb) $(Preview_STL) $(Assembly_STL)

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
$(addsuffix .html,$(Components)): $$(addsuffix _thumb.jpg, $$($$@_Renders))
# $(STLS): $$($$@_thumbnails)
# 	$(eval SOURCE=$(shell echo $($@) | awk -F _ '{ print $$1 }'))
# 	$(eval PART=$(basename $(notdir $@)))
# 	$(OSBIN) $(OSOPTS) -o $@.stl -o $(basename $@).png \
# 	--render -D _RENDER=\"$(PART)\" \
# 	--projection=p --autocenter --viewall \
# 	$(SOURCE).scad

FCG Frame Stock: $$($$@_STL) $$($$@_thumbnails) $$@.html

clean-dir:
	rm -rf $(TARGETS)

all: $(SUBDIRS) $(TARGETS)
 