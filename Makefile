include Makefile.in

Receiver: FORCE
	$(MAKE) -C $@
	
dist: FORCE
	zip Liberator12k.zip `find . -regextype egrep -iregex '.*?\.(html|png|mp4|stl)$$' | egrep -v '.frames|./Media|./Documentation'`

all: index.html Developers.html About.html Printing.html Receiver
