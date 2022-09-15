include ../../Makefile.in

#$(@:%=$(call render_class,$@).scad)

.SECONDEXPANSION:
# include $(BUILD_DIR)/$$(call render_class,$$@).d
%.dxf %.png %.stl: $$(call render_class,$$@).scad $$(BUILD_DIR)/$$(call render_class,$$@).d
	$(eval CLASS=$(call render_class,$@))
	$(eval PRESET=$(call render_preset,$@))
	$(eval IS_ASSEMBLY=$(findstring $(ASSEMBLY_DIR),$@))
	$(eval SCAD_POV=$(call scad_pov,$(CLASS).scad))
	$(eval CAMERA=$(if $(SCAD_POV),--camera=$(SCAD_POV),$(OS_CAM_ASSEMBLY)))
	$(eval PNG=$(basename $@).png)
	@echo Target: $@
	mkdir -p $(dir $@) && \
	$(OSBIN) $(OSOPTS) \
	  -o $@ -o $(PNG) \
	  $(if $(IS_ASSEMBLY),--preview,--render) \
	  --imgsize $(if $(IS_ASSEMBLY),$(OS_RES_HIGH),$(OS_RES_LOW)) \
	  --projection=p \
	  $(if $(IS_ASSEMBLY),$(CAMERA),$(OS_CAM_STL)) \
	  $(if $(PRESET),-p $(CLASS).json -P $(PRESET),) \
	  -D _RENDER=\"$(call render_part,$@)\" \
	  -D _RENDER_PRINT=$(if $(IS_ASSEMBLY),false,true) \
	  $(CLASS).scad && \
	convert -fuzz 4% -transparent "#fafafa" $(PNG) $(PNG),
