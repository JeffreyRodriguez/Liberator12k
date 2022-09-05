include ../Makefile.in

Assembly = Receiver/Assembly Forend/Assembly
Components = Frame Receiver Stock Lower FCG

Minuteman = $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Prints/*.stl)) \
                $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Fixtures/*.stl)) \
                $(foreach Component,$(Components),$(wildcard Receiver/$(Component)/Projections/))

Forends = $(filter-out Forend/Assembly/%, \
            $(shell find Forend/ -ipath '*_*/Prints/*.stl' ) \
						$(shell find Forend/ -ipath '*_*/Fixtures/*.stl' ) \
					  $(shell find Forend/ -ipath '*_*/Projections/*.dxf'))

TARGETS:=$(SUBDIRS)

clean-dir:
	rm -rf $(TARGETS)

all: $(TARGETS)
