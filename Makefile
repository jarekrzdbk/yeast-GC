FSA_FILES = $(wildcard inputs/*.fsa)
GSCOUNT_FILES = ${FSA_FILES:inputs/%.fsa=outputs/%.gc}

all: gccount
gccount: ${GSCOUNT_FILES}
outputs/%.gc: inputs/%.fsa
	#!/bin/bash
	bin/fasta-unfold < $< | sed '/^>/d' | bin/gc-content > $@

clean: 
	rm ${GSCOUNT_FILES}
