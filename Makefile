include Makefile.in

Receiver: FORCE
	$(MAKE) -C $@
	
Developers.html: Developers.md
	$(MDBIN) $^ > $@
	
About.html: About.md
	$(MDBIN) $^ > $@

dist: FORCE
	zip Liberator12k.zip `find . -regextype egrep -iregex '.*?\.(html|png|mp4|stl)$$' | egrep -v '.frames|./Media|./Documentation'`

all: index.html Developers.html About.html Receiver
