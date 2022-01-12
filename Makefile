# build/:
# 	mkdir build
# 	find gfx -type d -exec mkdir build/{} \;
# 	find dev -type d -exec mkdir build/{} \;
# 	mkdir build/content
# 	mkdir build/tikz

# wget https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2020/tlnet-final/install-tl-unx.tar.gz
# sudo ./install-tl --repository=https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2020/tlnet-final/

TIKZ=all

.PHONY: compile
compile:
	lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis.tex

.PHONY: bibliography
bibliography:
	biber thesis

.PHONY: thesis
thesis:
	sed -i '/^[^%].*\%gitignore/ s/./\% &/' thesis.tex
	$(MAKE) compile
	$(MAKE) bibliography
	$(MAKE) compile
	$(MAKE) compile
	cp thesis.pdf thesis_.pdf
	xdg-open thesis.pdf 2>/dev/null

.PHONY: split
split:
	bash split-chapters.sh

.PHONY: tikz
tikz:
	bash compile-chapters.sh $(TIKZ)

.PHONY: zip
zip:
	git archive --format=zip HEAD -o thesis.zip
	zip -ur thesis.zip dev/

.PHONY: textidote
textidote:
	textidote --output html --check en thesis.tex > thesis.html
	xdg-open thesis.html
#  textidote --output html --check en content/03-chapter-theory.tex > thesis.html

.PHONY: tikz-clean
tikz-clean:
	rm -r tikz/*
	touch tikz/dummy.tex

.PHONY: clean
clean:
	rm -f thesis.acr
	rm -f thesis.aux
	rm -f thesis.auxlock
	rm -f thesis.bbl
	rm -f thesis.bcf
	rm -f thesis.blg
	rm -f thesis.figlist
	rm -f thesis.log
	rm -f thesis.maf
	rm -f thesis.makefile
	rm -f thesis.mtc
	rm -f thesis.mtc0
	rm -f thesis.out
	rm -f thesis.pdf
	rm -f thesis.ptc1
	rm -f thesis.ptc2
	rm -f thesis.ptc3
	rm -f thesis.ptc4
	rm -f thesis.ptc5
	rm -f thesis.run.xml
	rm -f thesis.tdo
	rm -f thesis.toc
	rm -f thesis-tikz*
	rm -f thesis-chapter*
	rm -f thesis-appendix.pdf
	rm -f thesis.html
	rm -f content/*.aux

.PHONY: clean-all
clean-all: clean tikz-clean
