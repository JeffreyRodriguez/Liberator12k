include Makefile.in

MANUAL_IMAGES = $(wildcard .manual/*.jpg) $(shell find Receiver -name \*.jpg)
MARKDOWN = $(wildcard *.md) $(shell find Receiver -name \*.md)
MARKDOWN_HTML = $(addsuffix .html,$(basename $(MARKDOWN)))

Assembly = Receiver/Assembly Receiver/Forend/Assembly

MINUTEMAN_STL = Receiver/Frame_Receiver.stl $(wildcard Receiver/Components/*.stl) \
							$(wildcard Receiver/Stock*.stl) $(wildcard Receiver/Lower*.stl) \
							$(wildcard Receiver/FCG*.stl)

FOREND_STL = $(wildcard Receiver/Forend/*_*/*.stl)

STL := $(MINUTEMAN_STL) $(FOREND_STL)
EXTRA_DOCS := changelog.txt Manual.pdf
DIST := $(STL) $(EXTRA_DOCS)

MARKDOWN_HTML: $(MARKDOWN_HTML)
$(MARKDOWN_HTML): $(addsuffix .md, $(basename $@))

changelog.txt:
	git log --oneline > changelog.txt

Version.md:
	@echo "---" > $@ && \
	echo "title: #Liberator12k Manual" >> $@ && \
	echo "author: Jeff Rodriguez" >> $@ && \
	echo "copyright: Unlicensed" >> $@ && \
	echo "version: $(GIT_VERSION)" >> $@ && \
	echo "language: en-US" >> $@ && \
	echo "subject: How-To" >> $@ && \
	echo "---" >> $@
	
Manual.pdf: Version.md $(MARKDOWN_HTML) $(MANUAL_IMAGES) FORCE
	htmldoc --batch Manual.book
	
Liberator12k-src/:
	rm -rf $@ && \
	git init $@ && \
	cd $@ && \
	git pull ../ --depth=1 && \
	git remote add origin https://github.com/JeffreyRodriguez/Liberator12k.git

Liberator12k.zip: $(DIST) $(Assembly) Liberator12k-src/ FORCE
	zip $@ $(DIST)
	zip -r $@ $(Assembly) Liberator12k-src/
	
dist: FORCE $(SUBDIRS)
	$(MAKE) Liberator12k.zip

clean-dir:
	rm -rf $(MARKDOWN_HTML) Liberator12k.zip Version.md changelog.txt

all: $(SUBDIRS) dist
.PHONY: STL MARKDOWN_HTML dist Assembly