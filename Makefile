FSA_FILES = $(wildcard inputs/*.fsa)
GSCOUNT_FILES = ${FSA_FILES:inputs/%.fsa=outputs/%.gc}
TEX_FILES = $(wildcard *.tex)
AUX_FILES = $(TEX_FILES:%.tex=%.aux)
OUT_FILES = $(TEX_FILES:%.tex=%.out)
LOG_FILES = $(TEX_FILES:%.tex=%.log)
PDF_FILES = $(TEX_FILES:%.tex=%.pdf)
TOC_FILES = $(TEX_FILES:%.tex=%.toc)
SNM_FILES = $(TEX_FILES:%.tex=%.snm)
NAV_FILES = $(TEX_FILES:%.tex=%.nav)
DVI_FILES = $(TEX_FILES:%.tex=%.dvi)

all: gccount presentation.pdf report.pdf
gccount: ${GSCOUNT_FILES}

generate-plots: gccount
	Rscript bin/generate-plots.R

outputs/%.gc: inputs/%.fsa
	#!/bin/bash
	bin/fasta-unfold < $< | bin/find-orfs | bin/gc-content > $@

# %.dvi: %.tex psfiles
# 	latex $<
# %.ps: %.dvi
# 	dvips $<
%.pdf: %.tex generate-plots
	pdflatex $<

#DEPENDENCY_FILES = ${TEX_FILES:%.tex=.%.d}

#include ${DEPENDENCY_FILES}

#.%.d: %.tex
#	mktexdepend $< > $@

clean: 
	rm -f ${GSCOUNT_FILES} outputs/*.pdf
	rm -f ${AUX_FILES} ${OUT_FILES} ${PDF_FILES} ${LOG_FILES} ${TOC_FILES} ${SNM_FILES} ${NAV_FILES} ${DVI_FILES}
