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
