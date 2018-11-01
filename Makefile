##


export TEXMFHOME="~/texmf:"
PACKAGE = guitar-fretboard

cleanext := $(wildcard *.dvi *.aux *.glo *.ilg *.ind *.toc *.hd *.idx *.listing *.log *.out _minted-*)

listings := $(wildcard $(PACKAGE)-*.tex wildcard $(PACKAGE)-*.md5 wildcard $(PACKAGE)-*.pdf)

objects := $(PACKAGE).pdf

LATEX := $(shell which latex)
PDFLATEX := $(shell which pdflatex)
XELATEX := $(shell which xelatex)
PANDOC := $(shell which pandoc)

PDF_PROCESSOR := $(XELATEX)

CTANDIR := $(PACKAGE)
CTANDIST = Makefile README.md README \
	$(PACKAGE).pdf $(PACKAGE).dtx $(PACKAGE).sty

all: $(objects) README

#%.sty:
# 	$(RM) -f $@
# 	$(LATEX) '\let\install=y\input{$<}'

%.pdf: %.tex
	$(PDF_PROCESSOR) -shell-escape $<
	#makeindex -s gind.ist $(PACKAGE).idx
	$(PDF_PROCESSOR) -shell-escape $<
	#$(PDF_PROCESSOR) -shell-escape $<

clean:
	$(RM) -fr $(cleanext) $(listings) $(PACKAGE).zip

distclean: clean
	$(RM) -rf $(objects) README $(CTANDIR)

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


