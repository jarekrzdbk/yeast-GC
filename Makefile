FSA_FILES = $(wildcard inputs/*.fsa)
GSCOUNT_FILES = ${FSA_FILES:inputs/%.fsa=outputs/%.gc}
TEX_FILES = $(wildcard *.tex)
AUX_FILES = $(TEX_FILES:%.tex=%.aux)
OUT_FILES = $(TEX_FILES:%.tex=%.out)
LOG_FILES = $(TEX_FILES:%.tex=%.log)
PDF_FILES = $(TEX_FILES:%.tex=%.pdf)

all: gccount presentation.pdf
gccount: ${GSCOUNT_FILES}
outputs/%.gc: inputs/%.fsa
	#!/bin/bash
	bin/fasta-unfold < $< | bin/find-orfs-grep | bin/gc-content > $@

%.dvi: %.tex
	latex $<
%.ps: %.dvi
	dvips $<
%.pdf: %.ps
	ps2pdf $<

%.ps: %.png
	pngtopnm $< | pnmtops -noturn > $@

DEPENDENCY_FILES = ${TEX_FILES:%.tex=.%.d}

include ${DEPENDENCY_FILES}

.%.d: %.tex
	mktexdepend $< > $@

clean: 
	#rm -f ${GSCOUNT_FILES}
	rm -f ${AUX_FILES} ${OUT_FILES} ${PDF_FILES} ${LOG_FILES}
