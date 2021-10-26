include Makefile.in

MANUAL_HTML:=$(shell tail -n +3 Manual.book)
MANUAL_IMAGES=$(wildcard .manual/*.jpg) \
              $(shell find Receiver -name \*.jpg)

Assembly = Receiver/Assembly Forend/Assembly
Components = Frame Receiver Stock Lower FCG

Minuteman = $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Prints/*.stl)) \
                $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Fixtures/*.stl)) \
                $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Projections/))

Forends = $(filter-out Forend/Assembly/%, \
            $(shell find Forend/ -ipath '*_*/Prints/*.stl' ) \
						$(shell find Forend/ -ipath '*_*/Fixtures/*.stl' ) \
					  $(shell find Forend/ -ipath '*_*/Projections/*.dxf'))

ZIP_TARGETS:=changelog.txt Manual.pdf Liberator12k-source/
TARGETS:=$(ZIP_TARGETS) Liberator12k.zip Liberator12k-source.zip Liberator12k-assembly.zip

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

Manual.pdf: $(SUBDIRS) Version.md $(MANUAL_HTML) $(MANUAL_IMAGES)
	htmldoc --batch Manual.book

Liberator12k-source/: .git
	rm -rf $@ && \
	git init $@ && \
	cd $@ && \
	git pull ../ --depth=1 && \
	git remote add origin https://github.com/JeffreyRodriguez/Liberator12k.git

Liberator12k.zip: $(SUBDIRS) $(ZIP_TARGETS)
	zip -9r $@ $(ZIP_TARGETS) $(Minuteman) $(Forends)

Liberator12k-source.zip: Liberator12k-source/
	zip -9r $@ $^

Liberator12k-assembly.zip: $(SUBDIRS)
	zip -9r $@ $(Assembly)

dist: $(TARGETS) $(ZIP_TARGETS)
	mkdir -p dist/
	cp -r $^ $@/

clean-dir:
	rm -rf $(MARKDOWN_HTML) $(TARGETS) Version.md changelog.txt Liberator12k-source/ dist/

all: $(SUBDIRS) $(TARGETS) dist
