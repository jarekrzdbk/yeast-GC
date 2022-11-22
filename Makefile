FSA_FILES = $(wildcard inputs/*.fsa)
PDF_RESOURCES_FILES = outputs/cen_gc_frequency_ratio.pdf outputs/ec_gc_frequency_ratio.pdf outputs/fl_gc_frequency_ratio.pdf outputs/combined_histogram.pdf outputs/combined_boxplot.pdf outputs/combined_densityplot.pdf
GCCOUNT_FILES = ${FSA_FILES:inputs/%.fsa=outputs/%.gc}
TEX_FILES = $(wildcard *.tex)
AUX_FILES = $(TEX_FILES:%.tex=%.aux)
OUT_FILES = $(TEX_FILES:%.tex=%.out)
LOG_FILES = $(TEX_FILES:%.tex=%.log)
PDF_FILES = $(TEX_FILES:%.tex=%.pdf)
TOC_FILES = $(TEX_FILES:%.tex=%.toc)
SNM_FILES = $(TEX_FILES:%.tex=%.snm)
NAV_FILES = $(TEX_FILES:%.tex=%.nav)
DVI_FILES = $(TEX_FILES:%.tex=%.dvi)
PDF_FILES = ${TEX_FILES:%.tex=%.pdf}

.PHONY: all

all: ${PDF_FILES}

${PDF_RESOURCES_FILES} &: ${GCCOUNT_FILES}
	Rscript bin/generate-plots.R

outputs/%.gc: inputs/%.fsa
	#!/bin/bash
	bin/fasta-unfold < $< | bin/find-orfs | bin/gc-content > $@

%.pdf: %.tex ${PDF_RESOURCES_FILES}
	pdflatex $<

.PHONY: clean

clean: 
	rm -f ${GCCOUNT_FILES} outputs/*.pdf
	rm -f ${AUX_FILES} ${OUT_FILES} ${PDF_FILES} ${LOG_FILES} ${TOC_FILES} ${SNM_FILES} ${NAV_FILES} ${DVI_FILES}
