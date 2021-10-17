include Makefile.in

MANUAL_IMAGES = $(wildcard .manual/*.jpg) $(shell find Receiver -name \*.jpg)
MARKDOWN = $(wildcard *.md) $(shell find Receiver -name \*.md)
MARKDOWN_HTML = $(addsuffix .html,$(basename $(MARKDOWN)))

Assembly = Receiver/Assembly Receiver/Forend/Assembly
Components = Frame Receiver Stock Lower FCG

MINUTEMAN_STL = $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Prints/*.stl))

ForendPreset_STLS = $(wildcard Receiver/Forend/*_*/Prints/*.stl) \
                    $(wildcard Receiver/Forend/*_*/Projection/*.svg) \

STL:=$(MINUTEMAN_STL) $(ForendPreset_STLS)
EXTRA_DOCS:=changelog.txt Manual.pdf
ZIP_TARGETS:=$(EXTRA_DOCS) Source/
TARGETS:=Liberator12k.zip Liberator12k-assembly.zip

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
	
Manual.pdf: Version.md $(MARKDOWN_HTML) $(MANUAL_IMAGES)
	htmldoc --batch Manual.book

Source/: .git
	rm -rf $@ && \
	git init $@ && \
	cd $@ && \
	git pull ../ --depth=1 && \
	git remote add origin https://github.com/JeffreyRodriguez/Liberator12k.git

Liberator12k.zip: $(ZIP_TARGETS)
	zip -r $@ $(ZIP_TARGETS) $(STL)

Liberator12k-assembly.zip: $(Assembly)
	$(eval CWD=$(shell pwd))
	
	for DIR in $^; do \
		cd $$DIR && \
		zip -r $(abspath $@) * && \
		cd $(CWD); \
	done

clean-dir:
	rm -rf $(MARKDOWN_HTML) $(TARGETS) Version.md changelog.txt

all: $(SUBDIRS) $(TARGETS)