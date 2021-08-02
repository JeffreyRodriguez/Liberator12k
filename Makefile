include Makefile.in

SUBDIRS := $(dir $(wildcard */Makefile))

$(SUBDIRS):
	$(MAKE) -C $@

MANUAL_IMAGES = $(wildcard .manual/*.jpg) $(shell find Receiver -name \*.jpg)
MARKDOWN = $(wildcard *.md) $(shell find Receiver -name \*.md)
MARKDOWN_HTML = $(addsuffix .html,$(basename $(MARKDOWN)))
DOCS = $(MARKDOWN_HTML) $(MANUAL_IMAGES)

MINUTEMAN_STL = Receiver/Frame_Receiver.stl $(wildcard Receiver/Components/*.stl) \
							$(wildcard Receiver/Stock*.stl) $(wildcard Receiver/Lower/*.stl) \
							$(wildcard Receiver/FCG*.stl)

FOREND_STL = $(wildcard Receiver/Forend/*_*/*.stl)

STL := $(MINUTEMAN_STL) $(FOREND_STL)
DIST := changelog.txt Manual.pdf $(STL)

STL: $(SUBDIRS)
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
	
Manual.pdf: $(DOCS) Version.md FORCE
	htmldoc --batch Manual.book

Liberator12k.zip: $(DIST) FORCE
	zip -r Liberator12k.zip $(DIST)

all: $(SUBDIRS) Liberator12k.zip
.PHONY: STL MARKDOWN_HTML $(SUBDIRS)