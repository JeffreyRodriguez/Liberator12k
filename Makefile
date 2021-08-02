include Makefile.in

GIT_VERSION := $(shell git describe --always)
DATE := $(shell date +'%Y-%m-%d')

HTML := README.html About.html Printing.html Developers.html Unlicense.html Ammo/README.html $(shell find Receiver -name \*.html) 
DOCS := $(HTML) .manual $(shell find Receiver -name \*.jpg)  $(shell find Receiver -name \*.mp4)

RECEIVER_STL := Frame_Receiver.stl Components/Sightpost.stl \
							Stock*.stl Lower/*.stl \
							FCG*.stl
dist:
	mkdir -p $@

dist/docs: Receiver $(DOCS)
	mkdir -p $@
	cp *.html $@
	for file in $?; do \
	  mkdir -p "$@/`dirname $$file`"; \
	  cp -r $$file "$@/$$file"; \
  done

dist/Manual.pdf: dist/docs $(shell find dist/docs) $(DOCS) dist/docs/Version.md
	htmldoc --batch Manual.book

dist/changelog.txt: dist
	git log --oneline > dist/changelog.txt
dist/$(GIT_VERSION).version: dist
	touch "dist/$(GIT_VERSION).version"

dist/docs/Version.md:
	@echo "---" > $@ && \
	echo "title: #Liberator12k Manual" >> $@ && \
	echo "author: Jeff Rodriguez" >> $@ && \
	echo "copyright: Unlicensed" >> $@ && \
	echo "version: $(GIT_VERSION)" >> $@ && \
	echo "language: en-US" >> $@ && \
	echo "subject: How-To" >> $@ && \
	echo "---" >> $@

dist/Receiver: Receiver dist
	mkdir -p $@
	cp $(addprefix Receiver/,$(RECEIVER_STL)) $@/

FORENDS := TopBreak_CAFE12 TopBreak_CAFE12+ TopBreak_FP37 Revolver_ZZR6x12
FOREND_DIST := $(addprefix dist/Forend/,$(FORENDS))

$(FOREND_DIST): Receiver
	mkdir -p $@
	cp -r Receiver/$(shell echo "$@" | sed 's/^dist\///')/*.stl "$@/"
	
Liberator12k.zip: dist/changelog.txt dist/$(GIT_VERSION).version dist/docs dist/Manual.pdf dist/Receiver $(FOREND_DIST)
	cd dist && zip -r ../Liberator12k.zip *

Ammo Receiver: FORCE
		$(MAKE) -C $@

all: $(HTML) Receiver Liberator12k.zip
