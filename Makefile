REPORTS = soccerstats.pdf

.SUFFIXES:	.Rnw .pdf
.SUFFIXES:	.tex .pdf

all: $(REPORTS)

soccerstats.pdf: soccerstats.csv

.Rnw.tex:
	Rscript -e "library(knitr);knit('$<')" $*

.tex.pdf:
	pdflatex $<
	pdflatex $<
        
clean:
	rm -fr *.aux *.log *.out *.pdf *.tex *.toc figure
