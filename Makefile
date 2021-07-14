include Makefile.in

GIT_VERSION := $(shell git describe --always)

HTML := README.html About.html Printing.html Developers.html $(shell find Receiver -name \*.html) 
DOCS := $(HTML) .manual $(shell find Receiver -name \*.png)

RECEIVER_STL := Frame_Receiver.stl Components/Sightpost.stl \
							Stock*.stl Lower/*.stl \
							FCG*.stl
dist:
	mkdir -p $@

dist/docs: $(DOCS)
	mkdir -p $@
	cp *.html $@
	for file in $?; do \
	  mkdir -p "$@/`dirname $$file`"; \
	  cp -r $$file "$@/$$file"; \
  done

dist/changelog.txt: dist
	git log --oneline > dist/changelog.txt
dist/$(GIT_VERSION).version: dist
	touch "dist/$(GIT_VERSION).version"

dist/Receiver: Receiver dist
	mkdir -p $@
	cp $(addprefix Receiver/,$(RECEIVER_STL)) $@/

FORENDS := TopBreak_CAFE12 TopBreak_CAFE12+ TopBreak_FP37 Revolver_ZZR6x12
FOREND_DIST := $(addprefix dist/Forend/,$(FORENDS))

$(FOREND_DIST): Receiver
	mkdir -p $@
	cp -r $(addprefix Receiver/Forend/,$(FORENDS)) $@

Liberator12k.zip: dist/changelog.txt dist/$(GIT_VERSION).version dist/docs dist/Receiver $(FOREND_DIST)
	cd dist && zip ../Liberator12k.zip *

Receiver: FORCE
		$(MAKE) -C $@

all: $(HTML) Receiver Liberator12k.zip
