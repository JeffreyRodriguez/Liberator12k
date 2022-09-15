.animations/%.mp4: %.scad
	$(eval FRAMES_DIR=.frames)
	$(eval COMPONENT=$(basename $(notdir $@)))
	$(eval POV=$(call scad_pov,$<))
	@echo Target: $@
	mkdir -p $(FRAMES_DIR) && \
	mkdir -p $(dir $@) && \
	$(OSBIN) $(OSOPTS) --imgsize=1920,1080 \
	  -o $(FRAMES_DIR)/$(COMPONENT).png \
	  --animate $(SLOW_FRAME_COUNT) \
	  --projection=p --camera=$(POV) \
	  $^ && \
	nice ffmpeg -y -loglevel quiet \
	  -i "$(FRAMES_DIR)/$(COMPONENT)%05d.png" -framerate 10 \
	  -s:v 1920:1080 -c:v libx264 -crf 20 -pix_fmt yuv420p \
	  "$@"
