%.stl.mp4: %.stl
	$(eval PART=$(basename $(notdir $@)))
	$(eval FRAMES_DIR=$(basename $@)_frames)
	$(eval STL=$(notdir $(basename $@)))
	mkdir -p $(FRAMES_DIR)
	echo "rotate([0,0,360*\$$t]) import(\"../$(STL)\");" > $(FRAMES_DIR)/Spin.scad
	for i in `seq 0 $(SLOW_FRAME_COUNT)`; do \
	  echo openscad --imgsize=1920,1080 --quiet \
		  -o `printf '$(FRAMES_DIR)/frame%05d.png' $$i` \
		  -D \'\$$t=1/$(SLOW_FRAME_COUNT)*$$i\' \
			--projection=p --camera=0,500,600,0,0,100 \
			$(FRAMES_DIR)/Spin.scad; \
  done | nice parallel
	nice ffmpeg -y -loglevel quiet \
		-i "$(FRAMES_DIR)/frame%05d.png" -framerate 10 \
		-s:v 640:360 -c:v libx264 -crf 20 -pix_fmt yuv420p \
		"$@"
	rm -rf $(FRAMES_DIR)

.animations/%.mp4: %.scad
	$(eval FRAMES_DIR=.frames)
	$(eval COMPONENT=$(basename $(notdir $@)))
	$(eval POV=$(call scad_pov,$<))
	mkdir -p $(FRAMES_DIR) && \
	mkdir -p $(dir $@) && \
	$(OSBIN) $(OSOPTS) --imgsize=1920,1080 --quiet \
	  -o $(FRAMES_DIR)/$(COMPONENT).png \
	  --animate $(SLOW_FRAME_COUNT) \
	  --projection=p --camera=$(POV) \
	  $^ && \
	nice ffmpeg -y -loglevel quiet \
	  -i "$(FRAMES_DIR)/$(COMPONENT)%05d.png" -framerate 10 \
	  -s:v 1920:1080 -c:v libx264 -crf 20 -pix_fmt yuv420p \
	  "$@"