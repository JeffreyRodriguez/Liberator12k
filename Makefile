include Makefile.in

Assembly = Receiver/Assembly Forend/Assembly
Components = Frame Receiver Stock Lower FCG

Minuteman = $(foreach Component,$(Components),$(wildcard src/Receiver/$(Component)/Prints/*.stl)) \
                $(foreach Component,$(Components),$(wildcard src/Receiver/$(Component)/Fixtures/*.stl)) \
                $(foreach Component,$(Components),$(wildcard src/Receiver/$(Component)/Projections/))

Forends = $(filter-out src/Forend/Assembly/%, \
            $(shell find src/Forend/ -ipath '*_*/Prints/*.stl' ) \
						$(shell find src/Forend/ -ipath '*_*/Fixtures/*.stl' ) \
					  $(shell find src/Forend/ -ipath '*_*/Projections/*.dxf'))

ZIP_TARGETS:=changelog.txt Liberator12k-source/
TARGETS:=$(ZIP_TARGETS) Liberator12k.zip Liberator12k-source.zip Liberator12k-assembly.zip

changelog.txt:
	git log --oneline > changelog.txt

Liberator12k-source/: .git
	rm -rf $@ && \
	git clone --depth=1 "file://$(CURDIR)" $@ && \
	cd $@ && \
	git remote set-url origin https://github.com/JeffreyRodriguez/Liberator12k.git

Liberator12k.zip: $(SUBDIRS) $(ZIP_TARGETS)
	zip -9r $@ $(ZIP_TARGETS) $(Minuteman) $(Forends)

Liberator12k-source.zip: Liberator12k-source/
	zip -9r $@ $^

Liberator12k-assembly.zip: $(SUBDIRS)
	zip -9r $@ $(Assembly)

dist: $(TARGETS) $(ZIP_TARGETS)
	mkdir -p dist/
	cp -r *.zip $@/

.views: Views.mk
	mkdir -p $@
	$(MAKE) -f Views.mk all

clean-dir:
	rm -rf $(ASSEMBLY_DIR) $(BUILD_DIR) $(EXPORT_DIR)
	rm -rf $(TARGETS) changelog.txt Liberator12k-source/ dist/
clean-dir:

all: $(SUBDIRS) $(TARGETS) dist
