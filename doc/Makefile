include ../Makefile.in

MANUAL_IMAGES=$(wildcard doc/.manual/*.jpg)

TARGETS:=CAFE12.pdf

changelog.txt:
	git log --oneline > changelog.txt

Version.adoc:
	:revdate: $(GIT_DATE)
	:revnumber: $(GIT_VERSION)

%.pdf: %.adoc
	asciidoctor-pdf $^

clean-dir:
	rm -rf $(TARGETS) Version.adoc changelog.txt 

all: $(TARGETS)
