ifndef MAKEFILE_IN
include ../../Makefile.in
endif

%.dxf %.png %.stl:
	@$(eval NAME=$(call render_name,$@))
	@$(eval CLASS_PRESET=$(call render_class_preset,$@))
	@$(eval CLASS=$(call render_class,$@))
	@$(eval PRESET=$(call render_preset,$@))
	@$(eval PART=$(call render_part,$@))
	@$(eval IS_ASSEMBLY=$(findstring $(ASSEMBLY_DIR),$@))
	@$(eval RENDER_MODE=$(if $(IS_ASSEMBLY),--preview,--render))
	@$(eval RENDER_PRINT=$(if $(IS_ASSEMBLY),false,true) )
	@$(eval SCAD_POV=$(call scad_pov,$(CLASS).scad))
	@$(eval CAMERA=$(if $(SCAD_POV),--camera=$(SCAD_POV),$(OS_CAM_ASSEMBLY)))
	@$(eval VIEWPORT=$(if $(IS_ASSEMBLY),$(CAMERA),$(OS_CAM_STL)))
	@$(eval IMAGE_SIZE=$(if $(IS_ASSEMBLY),$(OS_RES_HIGH),$(OS_RES_LOW)))
	@echo Target: $@
	@echo Target Dir: $(dir $@)
	@echo Deps: $^
	@echo Name: $(NAME)
	@echo Class_Preset: $(CLASS_PRESET)
	@echo Class: $(CLASS)
	@echo Preset: $(PRESET)
	@echo Part: $(PART)
	@echo Render for Print: $(RENDER_PRINT)
	@echo Render Mode: $(RENDER_MODE)
	mkdir -p $(dir $@) && \
	$(OSBIN) $(OSOPTS) -o $@ \
		$(RENDER_MODE) --imgsize $(IMAGE_SIZE) --projection=p \
		$(VIEWPORT) \
		$(if $(PRESET),-p $(CLASS).json -P $(PRESET),) \
		-D _RENDER=\"$(PART)\" \
		-D _RENDER_PRINT=$(RENDER_PRINT) \
		$(CLASS).scad && \
	if  [ "$(suffix $@)" == ".png" ]; then
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
	fi

$(ASSEMBLY_DIR)/:
	mkdir -p $(ASSEMBLY_DIR)
