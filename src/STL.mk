include ../../Makefile.in

#$(@:%=$(call render_class,$@).scad)

$(EXPORT_DIR)/%.parts: %.scad
	mkdir -p $(dir $@) && \
	echo "$(subst ${space},${\n},$(call list_renders,$^))" > $@

# Build Dependency SCAD files, for freshness check
# %.png is a hack. OpenSCAD has no way to export just the build deps
# So this renders a 1x1 pixel, with an empty CSG tree so it renders instantly.
$(BUILD_DIR)/%.d $(BUILD_DIR)/%.png : %.scad
	@$(eval NAME=$(notdir $(basename $@)))
	@$(eval PNG=$(BUILD_DIR)/$(NAME).png)
	@$(eval SCAD=$(NAME).scad)
	@$(eval SCAD_POV=$(call scad_pov,$(SCAD)))
	rm -f $@ && \
	mkdir -p $(dir $@) && \
	$(OSBIN) $(OSOPTS) -o $(PNG) -d $@ \
		--csglimit 0 --render --projection=p \
		$(SCAD) && \
	sed -i '1d' $@ &&
	rm -f $(PNG)

.SECONDEXPANSION:
# include $(BUILD_DIR)/$$(call render_class,$$@).d
%.dxf %.png %.stl: $$(call render_class,$$@).scad $$(BUILD_DIR)/$$(call render_class,$$@).d
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
	$(OSBIN) $(OSOPTS) -o $@ -d $(CLASS).d \
		$(RENDER_MODE) --imgsize $(IMAGE_SIZE) --projection=p \
		$(VIEWPORT) \
		$(if $(PRESET),-p $(CLASS).json -P $(PRESET),) \
		-D _RENDER=\"$(PART)\" \
		-D _RENDER_PRINT=$(RENDER_PRINT) \
		$(CLASS).scad && \
	if  [ "$(suffix $@)" == ".png" ]; then
	  convert -fuzz 4% -transparent "#fafafa" $@ $@
	fi
