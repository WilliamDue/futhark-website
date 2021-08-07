## General rules for compiling all literate Futhark programs to Markdown.

FUTHARK_BACKEND ?= multicore

all: $(patsubst %.fut, %.md, $(wildcard *.fut))

%.md: %.fut
	futhark literate --backend=$(FUTHARK_BACKEND) --stop-on-error $<

.PHONY: clean

clean:
	rm -f $(patsubst %.fut, %.md, $(wildcard *.fut))
