include Makefile.in

MANUAL_IMAGES = $(wildcard .manual/*.jpg) \
                $(shell find Receiver -name \*.jpg)
MARKDOWN = $(wildcard *.md) $(shell find Receiver -name \*.md)
MARKDOWN_HTML = $(addsuffix .html,$(basename $(MARKDOWN)))

Assembly = Receiver/Assembly Receiver/Forend/Assembly
Components = Frame Receiver Stock Lower FCG

Minuteman = $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Prints/*.stl)) \
                $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Fixtures/*.stl)) \
                $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Projections/))

Forends = $(filter-out Receiver/Forend/Assembly/%, \
            $(shell find Receiver/Forend/ -ipath '*_*/Prints/*.stl' ) \
						$(shell find Receiver/Forend/ -ipath '*_*/Fixtures/*.stl' ) \
					  $(shell find Receiver/Forend/ -ipath '*_*/Projections/*.dxf'))

EXTRA_DOCS:=changelog.txt Manual.pdf
ZIP_TARGETS:=$(EXTRA_DOCS) Liberator12k-source/
TARGETS:=Liberator12k.zip Liberator12k-source.zip Liberator12k-assembly.zip

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

Manual.pdf: $(SUBDIRS) Version.md $(MARKDOWN_HTML) $(MANUAL_IMAGES)
	htmldoc --batch Manual.book

Liberator12k-source/: .git
	rm -rf $@ && \
	git init $@ && \
	cd $@ && \
	git pull ../ --depth=1 && \
	git remote add origin https://github.com/JeffreyRodriguez/Liberator12k.git

Liberator12k.zip: $(SUBDIRS) $(ZIP_TARGETS)
	zip -9r $@ $(ZIP_TARGETS) $(Minuteman) && \
	cd Receiver && zip -r $(abspath $@) $(subst Receiver/Forend/,Forend/,$(Forends))

Liberator12k-source.zip: Liberator12k-source/
	zip -9r $@ $^

Liberator12k-assembly.zip: $(SUBDIRS)
	$(eval CWD=$(shell pwd))

	for DIR in $(Assembly); do \
		cd $$DIR && \
		zip -9r $(abspath $@) * && \
		cd $(CWD); \
	done

clean-dir:
	rm -rf $(MARKDOWN_HTML) $(TARGETS) Version.md changelog.txt

all: $(SUBDIRS) $(TARGETS)
