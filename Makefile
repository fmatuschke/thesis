# build/:
# 	mkdir build
# 	find gfx -type d -exec mkdir build/{} \;
# 	find dev -type d -exec mkdir build/{} \;
# 	mkdir build/content
# 	mkdir build/tikz

# wget https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2020/tlnet-final/install-tl-unx.tar.gz
# sudo ./install-tl --repository=https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2020/tlnet-final/

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
	xdg-open thesis.pdf

.PHONY: split
split: 
	pdftk thesis.pdf cat 17-18 output thesis-chapter-01.pdf
	pdftk thesis.pdf cat 23-31 output thesis-chapter-02.pdf
	pdftk thesis.pdf cat 33-48 output thesis-chapter-03.pdf
	pdftk thesis.pdf cat 55-77 output thesis-chapter-04.pdf
	pdftk thesis.pdf cat 79-90 output thesis-chapter-05.pdf
	pdftk thesis.pdf cat 91-99 output thesis-chapter-06.pdf
	pdftk thesis.pdf cat 105-123 output thesis-chapter-07.pdf
	pdftk thesis.pdf cat 125-158 output thesis-chapter-08.pdf
	pdftk thesis.pdf cat 162-165 output thesis-chapter-09.pdf
	pdftk thesis.pdf cat 167-170 output thesis-chapter-10.pdf
	pdftk thesis.pdf cat 181-end output thesis-chapter-appendix.pdf
	
.PHONY: chapters
chapters:
	bash compile-chapters.sh

.PHONY: tikz
tikz:
	make -j$(shell nproc) -f thesis.makefile

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
	rm -f thesis-chapter*
	rm -f content/*.aux

.PHONY: clean-all
clean-all: clean tikz-clean
