include Makefile.in

Receiver: FORCE
	$(MAKE) -C $@

all: index.html Receiver
