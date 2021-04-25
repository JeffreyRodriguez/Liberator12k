include Makefile.in

Receiver: FORCE
	$(MAKE) -C $@
	
QuickStart.html: QuickStart.md
	$(MDBIN) $^ > $@
	
About.html: About.md
	$(MDBIN) $^ > $@

all: index.html QuickStart.html About.html Receiver
