include Makefile.in

Receiver: FORCE
		$(MAKE) -C $@

dist/Common: Receiver/Frame_Receiver.stl Receiver/Components/Sightpost.stl
dist/Common: Receiver/Stock*.stl
dist/Common: Receiver/Lower/Lower_Left.stl Receiver/Lower/Lower_Middle.stl Receiver/Lower/Lower_Right.stl
dist/Common: Receiver/Lower/Trigger_Left.stl Receiver/Lower/Trigger_Middle.stl Receiver/Lower/Trigger_Right.stl

CAFE12 := $(shell find Receiver/Forend/TopBreak_CAFE12/ -name \*.stl)
CAFE12+ := $(shell find Receiver/Forend/TopBreak_CAFE12/ -name \*.stl)
FP37 := $(shell find Receiver/Forend/TopBreak_CAFE12/ -name \*.stl)
	
HTML := index.html About.html Printing.html Developers.html $(shell find Receiver -name \*.html) 
DOCS := $(HTML) .manual $(shell find Receiver -name \*.png)
dist/docs: $(DOCS)
	mkdir -p $@
	cp *.html $@
	for file in $?; do \
	  mkdir -p "$@/`dirname $$file`"; \
	  cp -r $$file "$@/$$file"; \
  done

dist/CAFE12: $(CAFE12)
dist/CAFE12+: $(CAFE12+)
dist/FP37: $(FP37)
dist/Common dist/CAFE12 dist/CAFE12+ dist/FP37:
	mkdir -p $@
	cp  -r $? $@
		
Liberator12k.zip: Receiver dist/Common dist/CAFE12 dist/CAFE12+ dist/FP37
	touch dist/"`git describe --always`".version
	zip Liberator12k.zip dist/*

all: $(HTML) Receiver Liberator12k.zip
