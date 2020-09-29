DOC=README

all: $(DOC).html $(DOC).pdf


%.tex: %.md
	pandoc -f markdown -t latex -s -o $(DOC).tex $<

%.html: %.md
	pandoc -f markdown -t html -o $(DOC).html $<

%.aux: %.tex
	pdflatex $<

%.pdf: %.tex %.aux
	pdflatex $<

clean:
	rm -f $(DOC).pdf $(DOC).tex $(DOC).html $(DOC).aux $(DOC).log texput.log
