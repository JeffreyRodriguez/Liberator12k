include Makefile.in

Receiver: FORCE
	$(MAKE) -C $@
	
QuickStart.html: QuickStart.md
	$(MDBIN) $^ > $@
	
About.html: About.md
	$(MDBIN) $^ > $@

dist: FORCE
	zip Liberator12k.zip `find . -regextype egrep -iregex '.*?\.(html|png|mp4|stl)$$' | egrep -v '.frames|./Media|./Documentation'`

all: index.html QuickStart.html About.html Receiver
