include Makefile.in

GIT_VERSION := $(shell git describe --always)

Receiver: FORCE
		$(MAKE) -C $@

HTML := README.html About.html Printing.html Developers.html $(shell find Receiver -name \*.html) 
DOCS := $(HTML) .manual $(shell find Receiver -name \*.png)

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

dist/Receiver: dist Receiver/Frame_Receiver.stl Receiver/Components/Sightpost.stl
dist/Receiver: Receiver/Stock*.stl
dist/Receiver: Receiver/Lower/Lower_*.stl
dist/Receiver: Receiver/Lower/Trigger_*.stl
	mkdir -p $@
	
FORENDS := TopBreak_CAFE12 TopBreak_CAFE12+ TopBreak_FP37 Revolver_ZZR6x12
$(addprefix dist/Forend/,$(FORENDS)):
	mkdir -p $@
	cp -r $(addprefix Receiver/Forend/,$(FORENDS)) $@


.SECONDEXPANSION:
$(FORENDS): $$($$@)

Liberator12k.zip: dist/changelog.txt dist/$(GIT_VERSION).version dist/docs dist/Receiver $(addprefix dist/Forend/,$(FORENDS))
	cd dist && zip ../Liberator12k.zip *

all: $(HTML) Receiver Liberator12k.zip
