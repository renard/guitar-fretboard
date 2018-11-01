##


export TEXMFHOME="~/texmf:"
PACKAGE = guitar-fretboard

cleanext := $(wildcard *.dvi *.aux *.glo *.ilg *.ind *.toc *.hd *.idx *.listing *.log *.out _minted-*)

listings := $(wildcard $(PACKAGE)-*.tex wildcard $(PACKAGE)-*.md5 wildcard $(PACKAGE)-*.pdf)

objects := $(PACKAGE).pdf standalone.png

LATEX := $(shell which latex)
PDFLATEX := $(shell which pdflatex)
XELATEX := $(shell which xelatex)
PANDOC := $(shell which pandoc)

PDF_PROCESSOR := $(XELATEX)

CTANDIR := $(PACKAGE)
CTANDIST = Makefile README.md README \
	$(PACKAGE).pdf $(PACKAGE).sty \
	standalone.tex standalone.pdf

all: $(objects) README

#%.sty:
# 	$(RM) -f $@
# 	$(LATEX) '\let\install=y\input{$<}'

standalone.png: standalone.tex
	$(PDF_PROCESSOR) -shell-escape $<

%.pdf: %.tex
	$(PDF_PROCESSOR) -shell-escape $<
	#makeindex -s gind.ist $(PACKAGE).idx
	$(PDF_PROCESSOR) -shell-escape $<
	#$(PDF_PROCESSOR) -shell-escape $<

clean:
	$(RM) -fr $(cleanext) $(listings) $(PACKAGE).zip

distclean: clean
	$(RM) -rf $(objects) README $(CTANDIR) standalone.pdf

README: README.md
	$(PANDOC) -t plain -o $@ $<

CTAN: all README clean
	mkdir -p $(CTANDIR)
	cp $(CTANDIST) $(CTANDIR)
	zip -ll -q -r -X $(CTANDIR).zip $(CTANDIR)


.PHONY: %.dty
# lily:
# 	#lilypond-book --latex-program=pdflatex --pdf --lily-output-dir=out test-ly.lytex
# 	lilypond-book --output=out --pdf test-ly.lytex


