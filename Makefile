# build/:
# 	mkdir build
# 	find gfx -type d -exec mkdir build/{} \;
# 	find dev -type d -exec mkdir build/{} \;
# 	mkdir build/content
# 	mkdir build/tikz

.PHONY: compile
compile:
	lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis.tex

.PHONY: bibliography
bibliography:
	biber thesis

.PHONY: thesis
thesis: compile bibliography compile compile
	xdg-open 2>/dev/null thesis.pdf

.PHONY: tikz
tikz:
	make -j$(shell nproc) -f thesis.makefile

.PHONY: zip
zip:
	git archive --format=zip HEAD -o thesis.zip
	zip -u thesis.zip dev/**/*

.PHONY: tikz-clean
tikz-clean:
	rm -r tikz/*
	touch tikz/dummy.tex
	
.PHONY: clean
clean: tikz-clean
	rm thesis.acr
	rm thesis.aux
	rm thesis.auxlock
	rm thesis.bcf
	rm thesis.figlist
	rm thesis.log
	rm thesis.maf
	rm thesis.makefile
	rm thesis.mtc
	rm thesis.mtc0
	rm thesis.out
	rm thesis.pdf
	rm thesis.ptc1
	rm thesis.ptc2
	rm thesis.ptc3
	rm thesis.ptc4
	rm thesis.ptc5
	rm thesis.run.xml
	rm thesis.tdo
	rm thesis.toc
	rm content/*.aux
